package hgl.assets.fonts.tasks;

import h2d.Tile;
import hgl.assets.atlases.Atlas;
import hgl.assets.atlases.AtlasItem;
import hgl.assets.fonts.Font;
import hgl.common.tasks.Task;
import hgl.net.tasks.BytesToImage;
import hxd.BitmapData;

/**
 * Load HGF font
 * @author rzer
 */
class LoadHGF extends Task {
	
	public static function task(info:AssetInfo):Task{
		return new LoadHGF(info);
	}
	
	public var info:AssetInfo;
	public var file:FileInfo;

	public function new(info:AssetInfo) {
		this.info = info;
		super();
	}
	
	override public function process() {
		
		trace("load hgf");
		
		file = info.getFile("image");
		
		var task:BytesToImage = new BytesToImage(file.data);
		
		task.onFail.add(fail);
		task.onLoaded.add(whenLoaded);
		
	}
	
	private function whenLoaded(img:BitmapData):Void{
		
		var tile:Tile = Tile.fromBitmap(img);
		
		var font:Font = new Font();
		
		var data:String = info.getFile("data").data.toString();
		data = data.split("\r").join("");
		
		var lines:Array<String> = data.split("\n");
		
		while ( lines.length > 0 ) {
			
			var line = StringTools.trim(lines.shift());
			if (line == "") continue;
			
			var blocks:Array<String> = line.split(",");
			var name:String = blocks.shift();
			
			switch (name) {
			
				case "info": 
					font = new Font();
					font.name = blocks.shift();
					font.size = Std.parseInt(blocks.shift());
					font.tile = tile;
				case "common":
					
					font.lineHeight = Std.parseInt(blocks.shift());
					font.baseLine = Std.parseInt(blocks.shift());
					font.yCorrection = Std.parseInt(blocks.shift());
					
				case "distanceField":
					
					font.sdfType = blocks.shift() ;
					font.sdfRange = Std.parseInt(blocks.shift());
					
				case "c": //char
					
					var id:Int = Std.parseInt(blocks.shift());
					var chr:String = blocks.shift();
					var w:Int = Std.parseInt(blocks.shift());
					var h:Int = Std.parseInt(blocks.shift());
					var xOffset:Int = Std.parseInt(blocks.shift());
					var yOffset:Int = Std.parseInt(blocks.shift());
					var xAdvance:Int = Std.parseInt(blocks.shift());
					var x:Int = Std.parseInt(blocks.shift());
					var y:Int = Std.parseInt(blocks.shift());
					
					var char:FontChar = new FontChar();
					char.code = id;
					char.tile = tile.sub(x, y, w, h, xOffset, yOffset);
					char.xAdvance = xAdvance;
					font.glyphs.set(id, char);
					
					
				case "k": //kerning
					var firstId:Int = Std.parseInt(blocks.shift());
					var secondId:Int = Std.parseInt(blocks.shift());
					var amount:Int = Std.parseInt(blocks.shift());
					
					var second:FontChar = font.glyphs.get(secondId);
					second.addKerning(firstId, amount);
			}
			
		}
		
		trace("hgf loaded");
		info.asset = font;
		complete();
	}
}