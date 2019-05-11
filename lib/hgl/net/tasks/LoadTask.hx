package hgl.net.tasks;

import haxe.io.Bytes;
import hgl.common.tasks.Task;

/**
 * Load file task
 * @author rzer
 */

class LoadTask extends Task {
	
	public var url:String;
	public var data:Bytes;
	
	public function new(url:String) {
		this.url = url;
		super();
	}
	
	override public function process() {
		
		trace("loading", url);
		
		#if flash
		var loader = new flash.net.URLLoader();
		loader.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
		loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e:flash.events.IOErrorEvent) fail(e.text));
		loader.addEventListener(flash.events.Event.COMPLETE, function(_) whenLoaded(Bytes.ofData(loader.data)));
		loader.addEventListener(flash.events.ProgressEvent.PROGRESS, function(e:flash.events.ProgressEvent) setProgress(e.bytesLoaded, e.bytesTotal));
		loader.load(new flash.net.URLRequest(url));
		#end
		
		#if js
		var xhr = new js.html.XMLHttpRequest();
		xhr.open('GET', url, true);
		xhr.responseType = js.html.XMLHttpRequestResponseType.ARRAYBUFFER;
		
		xhr.onerror = function(e) fail(xhr.statusText);
	
		xhr.onload = function(e) {
			if (xhr.status != 200) fail(xhr.statusText);
			else whenLoaded(Bytes.ofData(xhr.response));
		}
		
		xhr.onprogress = function(e) {
			setProgress(js.Syntax.code("{0}.loaded || {0}.position", e), js.Syntax.code("{0}.total || {0}.totalSize", e));
		}
		
		xhr.send();
		#end
	}
	
	public function whenLoaded(data:Bytes):Void{
		this.data = data;
		complete();
	}
	
}