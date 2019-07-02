package hgl.net.tasks;

import h2d.Tile;
import haxe.io.Bytes;

import hgl.common.signals.OneSignal;
import hgl.common.tasks.Task;
import hxd.BitmapData;
import hxd.res.Any;

/**
 * Load BitmapData from bytes
 * @author rzer
 */

class BytesToImage extends Task{
	
	public var onLoaded:OneSignal<BitmapData> = new OneSignal<BitmapData>();
	private var data:Bytes;
	
	public function new(data:Bytes) {
		this.data = data;
		super();
	}
	
	override public function process() {
	
		#if flash
		
		var loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(e:flash.events.Event) {
			whenImage(hxd.BitmapData.fromNative(cast(loader.content, flash.display.Bitmap).bitmapData));
		});
		loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e:flash.events.IOErrorEvent) fail(e.text));
		loader.loadBytes(data.getData());
	
		#end
		
			
		#if js
		
		var blob = new js.html.Blob([data.getData()]);
		
		var native = new js.html.Image();
		
		native.onload = function(e){
			var canvas = js.Browser.document.createCanvasElement();
			canvas.width = native.width; canvas.height = native.height;
			
			var image = canvas.getContext2d();
			image.drawImage(native, 0, 0);
			whenImage(hxd.BitmapData.fromNative(image));
		}
		
		native.onerror = function() fail("bad image");
		
		native.src = js.html.URL.createObjectURL(blob);
		#end
		
	}
	
	public function whenImage(bitmap:BitmapData):Void{
		onLoaded.fire(bitmap);
		complete();
	}

	
}