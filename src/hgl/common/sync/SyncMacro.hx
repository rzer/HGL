package hgl.common.sync;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.MacroStringTools;
import haxe.macro.Type;
import haxe.Json;

#if macro

class SyncMacro{

	public static var funcIds:Map<String,Int> = [
		"hgl.common.sync.SyncItem" => 0
	];

	public var currentClass:ClassType;
	public var superClass:ClassType;
	public var nextFunctionId:Int ;
	public var fields:Array<Field>;
	public var className:String;
	
	public var _remoteCall:Array<Expr>;

	public var _toBytes:Array<Expr>;
	public var _fromBytes:Array<Expr>;
	public var _linkBytes:Array<Expr>;

	public var _toJSON:Array<Expr>;
	public var _fromJSON:Array<Expr>;
	public var _linkJSON:Array<Expr>;

	public function new(){}

	//Проходим все поля класса парсим их и генерируем на их основе методы
	macro public static function build():Array<Field> {
		
		var p:SyncMacro = new SyncMacro();
		return p.run();

	}

	public function run():Array<Field>{

		fields = Context.getBuildFields();

		_remoteCall = [];

		_toBytes = [];
		_fromBytes = [];
		_linkBytes = [];
		
		_toJSON = [];
		_fromJSON = [];
		_linkJSON = [];
		
		currentClass = Context.getLocalClass().get();
		superClass = currentClass.superClass.t.get();
		
		nextFunctionId = funcIds.get(getClassName(superClass));
		className = getClassName(currentClass);

		//Только классы унаследованные от SyncItem
		if (funcIds.exists(className)) return fields;
		
		for (field in fields) {
			if (!hasMeta(field,":sync")) continue;

			switch(field.kind){
				case FFun(func):
					parseFunc(field.name, func);
				case FVar(TPath(v)):
					parseVar(field.name, v);
				case _:
			}

		}
		
		funcIds.set(className, nextFunctionId);

		addFields(macro class {

			public static var _addClass:Bool = hgl.common.sync.SyncBox.addClass($v{className});

			public override function _getClassName():String {
				return $v{className};
			}

			public override function _getName():String {
				return $v{className.split(".").pop()};
			}

			public override function _toBytes(output:haxe.io.BytesOutput):Void {
				$b{_toBytes}
				super._toBytes(output);
			}

			public override function _fromBytes(input:haxe.io.BytesInput):Void {
				$b{_fromBytes}
				super._fromBytes(input);
			}

			public override function _toJSON(output:Dynamic):Void {
				$b{_toJSON}
				super._toJSON(output);
			}

			public override function _fromJSON(input:Dynamic):Void {
				$b{_fromJSON}
				super._fromJSON(input);
			}

			public override function _linkBytes():Void {
				$b{_linkBytes}
				super._linkBytes();
			}
			
			public override function _remoteCall(funcId:Int, input:haxe.io.BytesInput):Void {
				$b{_remoteCall}
				super._remoteCall(funcId, input);
			}
			
		});

		return fields;
	}

	public function parseFunc(name:String, func:Function):Void{

		var _send:Array<Expr> = [];
		var _recieve:Array<Expr> = [];

		for (arg in func.args) {
			switch (arg.type) {
				case TPath(type):

					var argName:String = arg.name;
					var argType:String = type.name;

					switch argType {

						case "Array":

							switch (type.params[0]) {
								case TPType(TPath(o)):

									var write:String = writeFunction(o.name);
									var read:String = readFunction(o.name);
									
									_send.push(macro _writeArray(output, $i{argName}, this.$write));
									_recieve.push(macro args.push(_readArray(input, this.$read)));

								case _:
							}

						default:

							var write:String = writeFunction(argType);
							var read:String = readFunction(argType);

							_send.push(macro this.$write(output, $i{argName}));
							_recieve.push(macro args.push(this.$read(input)));

					}
					
				case _:
			}
		}


		//Упаковка
		var packCode:Expr = macro {
			
			if (!box.isRemoteCall()) {

				var output:haxe.io.BytesOutput = new haxe.io.BytesOutput();
				output.writeInt32(box.boxId);
				output.writeInt32(placeIndex);
				output.writeInt32($v{nextFunctionId});
				$b{_send}
				box.send(0, output.getBytes());
				if (!box.isMain) return;
			}

		}

		switch (func.expr.expr) {
			
			case EBlock(exprs): 
				exprs.unshift(packCode);
			case _:
		}

		//Распаковка
		var unpackCode:Expr = macro {
			if (funcId == $v{nextFunctionId}){
				var args:Array<Dynamic> = [];
				$b{_recieve}
				Reflect.callMethod(this, $i{name}, args);
				return;
			}
		}
		
		
		_remoteCall.push(unpackCode);
		nextFunctionId++;
	}

	public function parseVar(name:String, t:TypePath):Void{
		switch(t.name){

			case "Array":

				switch (t.params[0]) {

					case TPType(TPath(o)):

						if (isSimpleType(o.name)){
							var write:String = "_write" +  o.name;
							var read:String = "_read" +  o.name;

							_toBytes.push(macro _writeArray(output, $i{name}, this.$write));
							_fromBytes.push(macro $i{name} = _readArray(input, this.$read));
						}else{
							_toBytes.push(macro _writeArray(output, $i{name}, _writeItem));
							_fromBytes.push(macro _readArray(input,_readInt, _syncLinks));
							_linkBytes.push(macro $i{name} = cast _readSyncItems());
						}

					case _:
				}	

			default:

				if (isSimpleType(t.name)){
					
					var write:String = "_write" + t.name;
					var read:String	= "_read" + t.name;

					_toBytes.push(macro this.$write(output, $i{name}));
					_fromBytes.push(macro this.$read(input));

				}else{
					_toBytes.push(macro _writeItem(output, $i{name}));
					_fromBytes.push(macro _readLink(input));
					_linkBytes.push(macro $i{name} = cast _readSyncItem());
				}
				
		}
	}


	public function readFunction(type:String):String{
		return "_read" + (isSimpleType(type) ? type : "Item");
	}

	public function writeFunction(type:String):String{
		return "_write" + (isSimpleType(type) ? type : "Item");
	}

	public function isSimpleType(type:String):Bool{
		switch(type){
			case "Byte","Int","Short","Bytes","String","Bool","Float": return true;
		}
		return false;
	}

	//Вспомогательные методы
	public function getFieldClassType(field:Field):ClassType{
		switch (field.kind) {
			
			case FVar(t):
				
				var type:Type = Context.resolveType(t, field.pos);
				
				switch (type) {
					case TInst(t2,_):
						return t2.get();
					default:
						return null;
				}
				
			default:
				return null;
		}
	}
	
	public function getClassName(classType:ClassType):String{
		return classType.pack.concat([classType.name]).join(".");
	}
	
	public function isExtendedFrom(current:ClassType, className:String):Bool{
		if (getClassName(current) == className) return true;
		
		if (current.superClass == null) return false;
		return isExtendedFrom(current.superClass.t.get(), className);
	}
	
	public function addFields(def:TypeDefinition):Void{
		for (field in def.fields) fields.push(field);
	}

	public function hasMeta(field:Field,tag:String):Bool{

		if(field.meta == null) return false;

		for(meta in field.meta){
			if(meta.name == tag) return true;
		}

		return false;

	}

}

#end