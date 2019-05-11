package hgl.assets.fonts;

import h2d.Tile;
import hxd.Charset;

class Font {
	
	public var glyphs:Map<Int,FontChar> = new Map();
	public var name:String;
	public var size:Int;
	public var baseLine:Int;
	public var lineHeight:Int;
	public var tile:Tile;
	public var charset:Charset;
	
	public var sdfType:String = "";
	public var sdfRange:Int = 0;
	public var yCorrection:Int = 0;

	public function new() {

		glyphs = new Map();
		charset = Charset.getDefault();
		
	}
	
	public inline function getChar(code:Int):FontChar {
		var c = glyphs.get(code);
		if(c == null) c = charset.resolveChar(code, glyphs);
		return c;
	}
	
	public function clone() {
		var font:Font = new Font();
		font.name = name;
		font.size = size;
		font.baseLine = baseLine;
		font.lineHeight = lineHeight;
		font.tile = tile.clone();
		font.charset = charset;
		
		for( g in glyphs.keys() ) {
			font.glyphs.set(g, glyphs.get(g).clone());
		}

		return font;
	}

	public function hasChar(code:Int):Bool {
		return glyphs.get(code) != null;
	}

	public function dispose():Void {
		tile.dispose();
	}

}