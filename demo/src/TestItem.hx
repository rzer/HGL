package;

import hgl.common.sync.SyncItem;
import haxe.io.Bytes;

class TestItem extends SyncItem{

	@:sync public function testFunc(a:Bytes):Void{
		trace("ok");
		
	}

}