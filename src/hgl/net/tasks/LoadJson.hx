package hgl.net.tasks;

import haxe.Json;
import haxe.io.Bytes;
import hgl.common.signals.OneSignal;

/**
 * Load json
 * @author rzer
 */

class LoadJson extends LoadTask{
	
	public var onLoaded:OneSignal<Dynamic> = new OneSignal<Dynamic>();
	
	override public function whenLoaded(data:Bytes):Void {
		
		this.data = data;
		
		var jsonStr:String = data.toString();
		var obj:Dynamic = null;
		
		try {
			obj = Json.parse(jsonStr);
		}catch (e:Dynamic){
			fail("bad json");
		}
		
		onLoaded.fire(obj);
		complete();
		
		
	}
	
}