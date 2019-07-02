package hgl.assets.fonts;

import h2d.Tile;

/**
 * ...
 * @author rzer
 */
class FontChar {

	public var code:Int;
	public var tile:Tile;
	public var xAdvance:Int = 0;
	public var kernings:Map<Int,Int> = new Map();
	

	public function new() {
	}

	public function addKerning( prevChar : Int, offset : Int ) {
		kernings.set(prevChar, offset);
	}

	public function getKerning(prevChar:FontChar):Int {
		if (prevChar == null) return 0;
		if (!kernings.exists(prevChar.code)) return 0;
		return kernings.get(prevChar.code);
	}
	
	public function clone():FontChar {
		var char:FontChar = new FontChar();
		char.code = code;
		char.tile = tile.clone();
		char.xAdvance = xAdvance;
		char.kernings = kernings;
		return char;
	}

}