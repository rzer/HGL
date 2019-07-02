package hgl.common.sync;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import hgl.common.types.Byte;
import hgl.common.types.Short;

@:autoBuild(hgl.common.sync.SyncMacro.build())
class SyncItem {

	public var _syncLinks:Array<Int> = [];

	public var box:SyncBox;
	public var placeIndex:Int;

	public function new(box:SyncBox = null):Void{
		if (box != null){
			this.box = box;
			box.addItem(this);
			create();
		}
	}

	public function create():Void{

	}

	public function restore():Void{

	}

	public function _getName():String {
		return "SyncItem";
	}
	
	public function _getClassName():String{
		return "hgl.common.sync.SyncItem";
	}

	//Удалённый вызов функции
	public function _remoteCall(funcId:Int, input:BytesInput):Void{
		//override in macro
	}

	//Пакуем состояние объекта в массив байт для передачи по сети
	public function _toBytes(output:BytesOutput):Void{
		//override in macro
	}
	
	//Распаковываем состояние объекта полученное по сети
	public function _fromBytes(input:BytesInput):Void{
		//override in macro
	}

	public function _linkBytes():Void{
		//override in macro
	}

	//Пакуем состояние объекта в json для сохранения на диске
	public function _toJSON(output:Dynamic):Void{
		//override in macro
	}
	
	//Распаковываем состояние объекта полученное из сейва
	public function _fromJSON(input:Dynamic):Void{
		//override in macro
	}

	public function _linkJSON():Void{
		//override in macro
	}
	

	public function _writeBool(output:BytesOutput, value:Bool):Void{
		output.writeInt8(value ? 1 : 0);
	}

	public function _writeByte(output:BytesOutput, value:Byte):Void{
		output.writeInt8(value);
	}

	public function _writeShort(output:BytesOutput, value:Short):Void{
		output.writeInt16(value);
	}

	public function _writeInt(output:BytesOutput, value:Int):Void{
		output.writeInt32(value);
	}

	public function _writeBytes(output:BytesOutput, bytes:Bytes):Void{
		if (bytes == null){
			output.writeInt16(0);
			return;
		}
		output.writeInt16(bytes.length+1);
		output.writeBytes(bytes,0,bytes.length);
	}

	public function _writeFloat(output:BytesOutput, value:Byte):Void{
		output.writeFloat(value);
	}

	public function _writeString(output:BytesOutput, value:String):Void{
		output.writeInt16(value.length);
		output.writeString(value);
	}

	public function _writeArray<T>(output:BytesOutput, a:Array<T>, f:(BytesOutput,T)->Void):Void {

		if(a == null) {
			_writeInt(output, 0);
			return;
		}
		
		_writeInt(output, a.length + 1);
		for(v in a) f(output, v); 
			
	}

	public function _writeItem(output:BytesOutput, value:SyncItem):Void{
		if (value == null || value.placeIndex == -1) _writeInt(output, 0);
		_writeInt(output, value.placeIndex + 1);
	}

	public function _readBool(input:BytesInput):Bool{
		return input.readInt8() == 1;
	}

	public function _readByte(input:BytesInput):Byte{
		return input.readInt8();
	}

	public function _readShort(input:BytesInput):Int{
		return input.readInt16();
	}

	public function _readInt(input:BytesInput):Int{
		return input.readInt32();
	}

	public function _readBytes(input:BytesInput):Bytes{
		var len:Int = input.readInt16();
		if (len == 0) return null;
		len--;
		return input.read(len);
	}

	public function _readFloat(input:BytesInput):Float{
		return input.readFloat();
	}

	public static function _readString(input:BytesInput):String{
		return input.readString(input.readInt16());
	}

	public function _readArray<T>(input:BytesInput, f:(BytesInput)->T, list:Array<T> = null):Array<T>{

		var len:Int = _readInt(input);
		if (len == 0) return null;
		len--;

		var result:Array<T> = list == null ? [] : list;

		for(i in 0...len){
			result.push(f(input));
		}

		return result;
	}

	public function _readItem(input:BytesInput):SyncItem{
		var placeIndex:Int = _readInt(input);
		if (placeIndex == 0) return null;
		return box.getItem(placeIndex-1);
	}

	public function _readLink(input:BytesInput):Void{
		_syncLinks.push(_readInt(input));
	}

	public function _readSyncItems():Array<SyncItem>{

		var len:Int = _syncLinks.shift();
		if (len == 0) return null;
		len--;

		var result:Array<SyncItem> = [];

		for(i in 0...len){
			result.push(box.getItem(_syncLinks.shift()));
		}

		return result;
	}

	public function _readSyncItem():SyncItem{
		var placeIndex:Int = _syncLinks.shift();
		if (placeIndex == 0) return null;
		return box.getItem(placeIndex--);
	}
	

	public function dispose():Void{
		box.removeItem(this);
		this.placeIndex = -1;
	}
}