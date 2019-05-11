package hgl.ui.utils;

import h2d.Bitmap;
import h2d.Tile;
import hgl.display.text.TextBuilder;
import hgl.ui.core.Component;


/**
 * Utils for debug and arrange ui
 * @author rzer
 */
class UI {
	
	public static var textBuilder:TextBuilder = new TextBuilder();
	public static var debug:Bool = true;
	
	
	public static function colorBg(c:Component, color:UInt = 0xf45ac4):Void {
		
		if (color == 0xf45ac4) color = Std.int(0xffffff * Math.random());
		
		var tile:Tile = Tile.fromColor(color, c.w, c.h);
		var bmp:Bitmap = new Bitmap(tile);
	
		c.addChildAt(bmp, 0);
		c.onResized.add(bmp.tile.setSize);
	}
	
	
}