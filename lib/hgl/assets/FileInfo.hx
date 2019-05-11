package hgl.assets;
import haxe.io.Bytes;
import hgl.common.tasks.Task;
import hgl.net.Loader;

/**
 * ...
 * @author rzer
 */
class FileInfo {
	
	public var name:String;
	public var url:String;
	
	public var data:Bytes;
	
	public var prefs:Array<String> = [];

	public function new() {
		
	}
	
	public function load():Task{
		return Loader.bytes(Assets.localPath(url), whenLoaded);
	}
	
	private function whenLoaded(data:Bytes):Void{
		this.data = data;
	}
	
	public function unload():Void{
		this.data = null;
	}
	
	public inline function hasPref(pref:String):Bool{
		return prefs.indexOf(pref) != -1;
	}
	
}