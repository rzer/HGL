package hgl.assets.tasks;

import h2d.Tile;
import hgl.assets.AssetInfo;
import hgl.assets.FileInfo;
import hgl.common.tasks.Task;
import hgl.net.tasks.BytesToImage;
import hxd.BitmapData;

/**
 * Create tile by asset
 * @author rzer
 */
class LoadTile extends Task {
	
	public static function task(info:AssetInfo):Task{
		return new LoadTile(info);
	}
	
	public var info:AssetInfo;
	public var file:FileInfo;

	public function new(info:AssetInfo) {
		this.info = info;
		super();
	}
	
	override public function process() {
		
		file = info.getFile("image");
		var task:BytesToImage = new BytesToImage(file.data);
		
		task.onFail.add(fail);
		task.onLoaded.add(whenLoaded);
	}
	
	private function whenLoaded(img:BitmapData):Void{
		
		var tile:Tile = Tile.fromBitmap(img);
		
		if (file.hasPref("sd")){
			tile.scaleToSize(tile.width * 2, tile.height * 2);
		}
		
		info.asset = tile;
		complete();
	}
	
}