package hgl.assets.atlases;

import h2d.Tile;

/**
 * ...
 * @author rzer
 */
class Atlas {
	
	public var tile:Tile;
	public var scale:Float = 1;
	
	private var content:Map<String, Array<AtlasItem>> = [];
	
	

	public function new() {
		
	}
	
	public function getTile(name:String):Tile{
		
		var c = content.get(name);
		if (c == null) return null;
		return createTile(c[0]);
		
	}
	
	public function getAnim(name:String):Array<Tile>{
		
		var c = content.get(name);
		if (c == null) return null;
		return [for ( t in c ) createTile(t)];
		
	}
	
	public function createTile(item:AtlasItem):Tile{
		
		var t:Tile = tile.sub(
			item.rX / scale,
			item.rY / scale,
			item.rW / scale,
			item.rH / scale,
			item.tX - item.pX,
			item.tY - item.pY
		);
		
		t.scaleToSize(t.width * scale, t.height * scale);
		
		return t;
	}
	
	public function addItem(item:AtlasItem):Void{
		
		if (item == null) return;
		
		var list:Array<AtlasItem> = content.get(item.name);
		
		if(list == null) {
			list = [];
			content.set(item.name, list);
		}
		
		list[item.index] = item;
	}
	
	
}