package hgl.assets;
import hgl.assets.atlases.tasks.LoadHGA;
import hgl.assets.tasks.CleanupOldFiles;
import hgl.assets.tasks.DownloadNewFiles;
import hgl.assets.tasks.LoadAssetsFile;
import hgl.assets.tasks.LoadTile;
import hgl.common.tasks.SerialTask;
import hgl.common.tasks.Task;
import hgl.net.Loader;

/**
 * Asset system with preferences and file caching
 * @author rzer
 */

class Assets {
	
	public static var remoteFolder:String;
	public static var localFolder:String;
	
	public static var prefs:Array<String> = [];
	public static var assets:Map<String, AssetInfo> = [];
	public static var types:Map<String, AssetInfo->Task> = [];
	
	private static var groups:Map<String, Array<String>> = [];
	
	public static function init(remoteFolder:String = "assets/", localFolder = "assets/"):Task{
		
		Assets.remoteFolder = remoteFolder;
		Assets.localFolder = localFolder;
		
		
		#if js
		prefer("js");
		#end
		
		#if flash
		prefer("fl");
		#end
		
		return new SerialTask([
			new LoadAssetsFile(),
			new DownloadNewFiles(),
			new CleanupOldFiles()
		]);
		
	}
	
	public static function load(groupName:String, assetList:Array<String>):Task{
	
		
		groups.set(groupName, assetList);
		
		var task:SerialTask = new SerialTask();
		
		for (name in assetList){
			
			var info:AssetInfo = assets.get(name);
			if (info == null) continue;
			
			task.add(info.load());
		}
		
		
		
		return task;
	}
	
	public static function unload(groupName:String):Void{
		
		var assetList = groups.get(groupName);
		if (assetList == null) return;
		
		for (name in assetList){
			var info:AssetInfo = assets.get(name);
			if (info == null) continue;
			info.unload();
		}
	}
	
	public static inline function getInfo(name:String):AssetInfo{
		return assets.get(name);
	}
	
	public static function get(name:String):Dynamic{
		var info:AssetInfo = assets.get(name);
		return info == null ? null : info.asset;
	}
	
	public static inline function localPath(url:String):String{
		return localFolder + url;
	}
	
	public static inline function remotePath(url:String):String{
		return remoteFolder + url;
	}
	
	public static inline function add(asset:AssetInfo):Void{
		assets.set(asset.name, asset);
	}
	
	public static inline function prefer(preference:String):Void{
		prefs.push(preference);
	}
	
	public static inline function addType(name:String, taskFactory:AssetInfo->Task):Void{
		types.set(name, taskFactory);
	}
	

}