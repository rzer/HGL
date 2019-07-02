package hgl.common.sync;

class SyncStep extends SyncItem {

	@:sync public var step:Int = 0;

	@:sync public function update():Void{
		step++;
		onUpdate();
	}

	public function onUpdate():Void{
		//override
		var app:TestApp = cast box;
		trace(app.isMain, "updatem", app.rnd.nextIntRange(0,20));
	}
	
}