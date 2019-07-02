package hgl.ui.core;

import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import hgl.assets.Assets;
import hgl.assets.atlases.Atlas;


/**
 * ...
 * @author rzer
 */
class Image extends Component {

	public var bitmap:Bitmap;
	public var path:String;

	public function new(path:String, parent:Object = null) {
		
		this.path = path;
		
		var tile:Tile = getTile(path);
		
		super(parent, Std.int(tile.width), Std.int(tile.height)); 
		bitmap = new Bitmap(tile, this);
	}
	
	public function change(path:String):Void{
		
		this.path = path;
		
		var tile:Tile = getTile(path);
		
		bitmap.tile = tile;
		resize(Std.int(tile.width), Std.int(tile.height));
	}
	
	public function getTile(path:String):Tile{
		
		var list:Array<String> = path.split(":");
		
		if (list.length == 1) return Assets.get(list[0]);
		
		var atlas:Atlas = Assets.get(list[0]);
		return atlas.getTile(list[1]);
	}
	
	
}