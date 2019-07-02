package hgl.net.tasks;

import haxe.io.Bytes;
import hgl.common.signals.OneSignal;

/**
 * Load string
 * @author rzer
 */

class LoadText extends LoadTask{
	
	public var onLoaded:OneSignal<String> = new OneSignal<String>();
	
	override public function whenLoaded(data:Bytes):Void {
		
		this.data = data;
		
		onLoaded.fire(data.toString());
		complete();
		
	}

	
}