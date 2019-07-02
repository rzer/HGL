package hgl.display.core;

import h2d.Object;
import h2d.Tile;
import h2d.TileGroup;
import h3d.mat.Texture;


/**
 * 
 * @author rzer
 */
class TileLayers extends Object {
	
	public var layers:Array<TileGroup> = [];

	public function getLayer(name:String, tile:Tile, createCallback:TileGroup->Void = null):TileGroup{
		
		var texture:Texture = tile.getTexture();
		
		for (layer in layers){
			if (layer.name == name && layer.tile.getTexture() == texture){
				return layer;
			}
		}
		
		var layer:TileGroup = new TileGroup(tile, this);
		layer.smooth = true;
		layer.name = name;
		layers.push(layer);
		
		if (createCallback != null) createCallback(layer);
		
		return layer;
	}
	
	public function clear():Void{
		for (layer in layers){
			layer.clear();
		}
	}
	
}

