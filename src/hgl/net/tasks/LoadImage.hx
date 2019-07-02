package hgl.net.tasks;

import h2d.Tile;
import haxe.io.Bytes;
import hgl.common.signals.OneSignal;
import hgl.common.tasks.Task;
import hxd.BitmapData;
import hxd.res.Any;

/**
 * Load BitmapData
 * @author rzer
 */

class LoadImage extends LoadTask{
	
	public var onLoaded:OneSignal<BitmapData> = new OneSignal<BitmapData>();
	
	
	override public function whenLoaded(data:Bytes):Void {
		
		this.data = data;
		
		var convert:BytesToImage = new BytesToImage(data);
		convert.onFail.add(fail);
		convert.onComplete.add(complete);
		convert.onLoaded.add(onLoaded.fire);
		
	}

	
}