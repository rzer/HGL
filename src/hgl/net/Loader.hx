package hgl.net;

import h2d.Tile;
import haxe.io.Bytes;
import hgl.net.tasks.LoadBytes;
import hgl.net.tasks.LoadImage;
import hgl.net.tasks.LoadJson;
import hgl.net.tasks.LoadText;
import hxd.BitmapData;


/**
 * One line loading
 * @author rzer
 */
class Loader {
	
	public static function bytes(url:String, onLoaded:Bytes->Void = null, onFail:String->Void = null):LoadBytes{
		var task:LoadBytes = new LoadBytes(url);
		task.onLoaded.once(onLoaded);
		task.onFail.once(onFail);
		return task;
	}
	
	public static function text(url:String, onLoaded:String->Void = null, onFail:String->Void = null):LoadText{
		var task:LoadText = new LoadText(url);
		task.onLoaded.once(onLoaded);
		task.onFail.once(onFail);
		return task;
	}
	
	public static function json(url:String, onLoaded:Dynamic->Void = null, onFail:String->Void = null):LoadJson{
		var task:LoadJson = new LoadJson(url);
		task.onLoaded.once(onLoaded);
		task.onFail.once(onFail);
		return task;
	}
	
	public static function image(url:String, onLoaded:BitmapData->Void = null, onFail:String->Void = null):LoadImage{
		var task:LoadImage = new LoadImage(url);
		task.onLoaded.once(onLoaded);
		task.onFail.once(onFail);
		return task;
	}
	
	
}