package hgl.net.tasks;

import haxe.io.Bytes;
import hgl.common.signals.OneSignal;

/**
 * Load bytes
 * @author rzer
 */

class LoadBytes extends LoadTask{
	
	public var onLoaded:OneSignal<Bytes> = new OneSignal<Bytes>();
	
	override public function whenLoaded(data:Bytes):Void {
		
		this.data = data;
		onLoaded.fire(data);
		complete();
		
	}

	
}