package hgl.assets;
import hgl.common.tasks.SerialTask;
import hgl.common.tasks.Task;
import hxd.fs.FileInput;

/**
 * ...
 * @author rzer
 */
class AssetInfo {
	
	public var asset:Dynamic;
	
	public var name:String;
	public var type:String;
	
	public var files:Map<String, FileInfo> = [];

	public function new() {
		
	}
	
	public function load():Task{
		
		var task:SerialTask = new SerialTask();
		
		for (file in files){
			task.add(file.load());
		}
		
		//factory that converts files to asset
		var factory:AssetInfo->Task = Assets.types.get(type);
		task.add(factory(this));
		
		return task;
	}
	
	public function unload():Void{
		
		for (file in files){
			file.unload();
		}
		
		asset = null;
	}
	
	public inline function getFile(fileName:String):FileInfo{
		return files.get(fileName);
	}
	
	public inline function addFile(file:FileInfo):Void{
		return files.set(file.name, file);
	}
	
}