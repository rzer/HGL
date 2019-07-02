package hgl.assets.atlases.tasks;

import h2d.Tile;
import hgl.assets.atlases.Atlas;
import hgl.assets.atlases.AtlasItem;
import hgl.common.tasks.Task;
import hgl.net.tasks.BytesToImage;
import hxd.BitmapData;

/**
 * Load HGA atlas with animation support and pivot points for tiles
 * @author rzer
 */
class LoadHGA extends Task {
	
	public static function task(info:AssetInfo):Task{
		return new LoadHGA(info);
	}
	
	public var info:AssetInfo;
	public var file:FileInfo;

	public function new(info:AssetInfo) {
		this.info = info;
		super();
	}
	
	override public function process() {
		
		trace("load hga");
		
		file = info.getFile("image");
		
		var task:BytesToImage = new BytesToImage(file.data);
		
		task.onFail.add(fail);
		task.onLoaded.add(whenLoaded);
		
	}
	
	private function whenLoaded(img:BitmapData):Void{
		
		var tile:Tile = Tile.fromBitmap(img);
		
		var atlas:Atlas = new Atlas();
		atlas.tile = tile;
		
		if (file.hasPref("sd")) atlas.scale = 2;
		
		
		var data:String = info.getFile("data").data.toString();
		
		data = data.split("\r").join("");
	
		var lines:Array<String> = data.split("\n");
		var item:AtlasItem = null;
		
		while ( lines.length > 0 ) {
			
			var line = StringTools.trim(lines.shift());
			if (line == "") continue;
			
			var blocks:Array<String> = line.split(",");
			var name:String = blocks.shift();
			
			switch (name) {
				
				case "src": 
					//process from assets
				case "item": 
					
					atlas.addItem(item);
					item = new AtlasItem();
					
					var p:Array<String> = blocks.shift().split("@");
					item.name = p.shift();
					if (p.length > 0) item.index = Std.parseInt(p.shift());
					
				case "rect":
					item.rX = Std.parseInt(blocks.shift());
					item.rY = Std.parseInt(blocks.shift());
					item.rW = Std.parseInt(blocks.shift());
					item.rH = Std.parseInt(blocks.shift());
				case "size":
					item.w = Std.parseInt(blocks.shift());
					item.h = Std.parseInt(blocks.shift());
				case "trim":
					item.tX = Std.parseInt(blocks.shift());
					item.tY = Std.parseInt(blocks.shift());
				case "pivot":
					item.pX = Std.parseInt(blocks.shift());
					item.pY = Std.parseInt(blocks.shift());
			}
			
		}
		
		trace("hga loaded");
		
		atlas.addItem(item);
		info.asset = atlas;
		complete();
	}
}