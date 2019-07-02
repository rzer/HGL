package hgl.common.sync;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import hgl.common.signals.VoidSignal;
import hgl.common.signals.TwoSignal;

class SyncBox extends SyncItem{

	private static var classList:Array<String> = [];

	public static function addClass(name:String):Bool{
		classList.push(name);
		return true;
	}

	public var onBytes:TwoSignal<Int,Bytes> = new TwoSignal<Int,Bytes>();

	public var isDirty:Bool = false;
	
	public var isMain:Bool = true;
	public var boxId:Int = 0;

	public var callBox:Int = 0;
	public var callBytes:Bytes = null;

	public var items:Array<SyncItem> = [];
	public var vacantPlaces:Array<Int> = [];

	public function new() {

		super(this);

		classList.sort(function(a:String, b:String):Int{
			a = a.toLowerCase();
			b = b.toLowerCase();
			if (a < b) return -1;
			if (a > b) return 1;
			return 0;
		});
	}
	
	public function isRemoteCall():Bool{
		return callBytes != null;
	}

	public function addItem(item:SyncItem, placeIndex:Int = 0):Void{

		if (placeIndex == 0){

			if (vacantPlaces.length > 0){
				placeIndex = vacantPlaces.shift();
				items[placeIndex] = item;
			}else{
				placeIndex = items.push(item) - 1;
			}
			
		}else{
			items[placeIndex] = item;
		}

		item.box = this;
		item.placeIndex = placeIndex;
	}

	public function removeItem(item:SyncItem):Void{
		items[item.placeIndex] = null;
		vacantPlaces.push(item.placeIndex);
	}

	public function getItem(placeIndex:Int):SyncItem{
		if (placeIndex < 0 || placeIndex > items.length) return null;
		return items[placeIndex];
	}

	public function remoteCall(bytes:Bytes):Void{

		trace("remoteCall", isMain);
		traceItems();
	
		var input:BytesInput = new BytesInput(bytes);

		//Контекст вызова функции
		callBytes = bytes;
		callBox = input.readInt32();
		
		var placeIndex:Int = input.readInt32();

		trace(isMain, "get", placeIndex);

		//Пришёл пакет синхронизации
		if (placeIndex == -1){
			
			if (isMain){

				sendState(callBox);

				callBytes = null;
				callBox = boxId;
				return;
			}

			loadBytes(input);
			return;
		}

		//Если коробка рассинхронизирована - обрабатывает только пакет синхронизации
		//всё что придёт до пакета синхронизации отбрасывается
		if (isDirty){
			callBytes = null;
			callBox = boxId;
			return;
		}

		var funcId:Int = input.readInt32();
		var item:SyncItem = items[placeIndex];

		trace(item != null ? item._getName() : "null", funcId);

		//Состояние бокса приславшего пакет отличается от текущего
		if (item == null) {

			if (isMain){
				sendState(callBox);
			}else{
				askState();
			}

			//Сбрасываем контекст
			callBytes = null;
			callBox = boxId;
			return;
		}

		//Удалённый вызов пришедший в главную коробку сразу ретранслируем всем остальным
		if (isMain) broadcast(bytes);
		item._remoteCall(funcId, input);

		//Сбрасываем контекст
		callBytes = null;
		callBox = boxId;
	}

	public function traceItems():Void{
		for (i in 0...items.length){
			trace(i,items[i] != null ? items[i]._getName(): "null");
		}
	}

	public function broadcast(bytes:Bytes):Void{
		onBytes.fire(-1, bytes);
	}

	public function send(recieverBox:Int, bytes:Bytes):Void{
		onBytes.fire(recieverBox, bytes);
	}

	//Запрашиваем у главной коробки пакет синхронизации
	public function askState():Void{
		isDirty = true;

		var output:BytesOutput = new BytesOutput();
		output.writeInt32(boxId);
		output.writeInt32(-1);

		send(0, output.getBytes());
	}

	public function sendState(boxId:Int):Void{
		var output:BytesOutput = new BytesOutput();
		saveBytes(output);
		send(boxId,output.getBytes());
	}
	
	//Загружаем состояние из слепка мира
	public function loadBytes(input:BytesInput):Void{

		var lastOccupiedPlace:Int = 0;
		vacantPlaces = [];

		//Восстанавливаем все объекты в памяти
		while (input.position < input.length) {
			
			var placeIndex:Int = input.readInt32();
			var classIndex:Int = input.readInt32();
			
			var className:String = classList[classIndex];
			var item:SyncItem = getItem(placeIndex);

			trace("add", className, placeIndex);
			
			//Коробка единственная которая не создаётся заново
			if (placeIndex != 0) {
				item = cast(Type.createInstance(Type.resolveClass(className), []), SyncItem);
				addItem(item, placeIndex);
			}
			
			item._fromBytes(input);

			//Формируем список вакантных мест
			lastOccupiedPlace++;

			while(lastOccupiedPlace < placeIndex){
				items[lastOccupiedPlace] = null;
				vacantPlaces.push(lastOccupiedPlace);
				lastOccupiedPlace++;
			}
		}
		
		//Восстанавливаем ссылки на объекты
		for (item in items){
			if (item != null) item._linkBytes();
		}

		for (item in items){
			if (item != null) item.restore();
		}

		isDirty = false;
	}

	public function saveBytes(output:BytesOutput):Void{

		output.writeInt32(boxId);
		output.writeInt32(-1);

		for (item in items){

			if (item == null || item.placeIndex == -1) continue;

			var classIndex:Int = classList.indexOf(item._getClassName());

			output.writeInt32(item.placeIndex);
			output.writeInt32(classIndex);
			item._toBytes(output);
			
		}

	}


}