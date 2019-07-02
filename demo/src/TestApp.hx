package;

import hgl.common.sync.SyncBox;
import hgl.common.sync.SyncRandom;
import hgl.common.sync.SyncStep;

class TestApp extends SyncBox{

	@:sync public var list:Array<TestItem> = [];
	@:sync public var rnd:SyncRandom;
	@:sync public var step:SyncStep;
	
	public override function create(){
		super.create();
		rnd = new SyncRandom(box);
		step = new SyncStep(box);
		list = [];
	}
	
	@:sync public function test(a:Int, b:Array<Int>):Void{
		trace("ok",a);
	}
}