package hgl.assets.tasks;
import hgl.assets.AssetInfo;
import hgl.assets.FileInfo;
import hgl.common.tasks.Task;
import hgl.net.Loader;

/**
 * Select most relevant files from assets and add them to assets system
 * @author rzer
 */
class LoadAssetsFile extends Task{

	override public function process() {
		Loader.json(Assets.remotePath("assets.json"), whenLoaded, fail);
	}
	
	private function whenLoaded(data:Dynamic):Void{
		
		for (assetName in Reflect.fields(data)){
			
			var assetData:Dynamic = Reflect.field(data, assetName);
			
			var asset:AssetInfo = new AssetInfo();
			asset.name = assetName;
			asset.type = assetData.type;
			Assets.add(asset);
			
			//find most relevant file
			
			var files:Array<Dynamic> = assetData.files;
						
			for (fileData in files){
				
				var candidate:FileInfo = new FileInfo();
				candidate.name = fileData.name;
				candidate.url = fileData.url;
				candidate.prefs = fileData.prefs;
				
				var current:FileInfo = asset.getFile(fileData.name);
				
				if (current == null || countPrefs(current) < countPrefs(candidate)){
					asset.addFile(candidate);
				}
				
					
			}
			
			
		}
		
		trace("complete assets");
		complete();
		
	}
	
	private function countPrefs(file:FileInfo):Int{
		
		var result:Int = 0;
		
		for (pref in file.prefs){
			if (Assets.prefs.indexOf(pref) != -1) result++;
		}
		
		return result;
	}
	
	
	
}