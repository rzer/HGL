package hgl.display.text;

import hgl.assets.fonts.Font;

/**
 * Text style
 * @author rzer
 */

class FilterType {
	public static inline var GLOW:Int = 0;
	public static inline var SHADOW:Int = 1;
	public static inline var OUTLINE:Int = 2;
}

enum TextAlign {
	Inherit;
	Left;
	Center;
	Right;
}

typedef TextFilter = {
	type:Int,
	color:Int,
	alpha:Float,
	value:Float,
	offsetX:Float,
	offsetY:Float
}



class TextStyle {
	
	public var font:Font;
	public var color:Int;
	public var align:TextAlign;
	public var size:Float;
	
	
	public var filter:TextFilter;
	

	public function new(font:Font = null, size:Float = -1, color:Int = -1, align:TextAlign = TextAlign.Inherit) {
		this.font = font;
		this.color = color;
		this.size = size;
		this.align = align;
	}
	
	public function glow(blur:Float = 0.2, color:Int = 0xffff00, alpha:Float = 0.5):Void{
		filter = {
			type: FilterType.GLOW,
			offsetX: 0,
			offsetY: 0,
			value: blur,
			color: color,
			alpha: alpha
		};
	}
	
	public function outline(width:Float = 0.25, color:Int = 0x0, alpha:Float = 1.0):Void{
		filter = {
			type: FilterType.OUTLINE,
			offsetX: 0,
			offsetY: 0,
			value: width,
			color: color,
			alpha: alpha
		};
	}
	
	public function dropShadow(blur:Float = 0.2, offsetX:Float = 2, offsetY:Float = 2, color:Int = 0x0, alpha:Float = 0.5):Void{
		
		filter = {
			type: FilterType.SHADOW,
			offsetX: offsetX,
			offsetY: offsetY,
			value: blur,
			color: color,
			alpha: alpha
		};
		
	}
	
	public function getLayerName():String{
		if (filter == null) return Std.string(color);
		return color + "_" + filter.type + "_" + filter.color + "_" + filter.alpha + "_" + filter.value + "_" + filter.offsetX + "_" + filter.offsetY;
	}
	
	
	public function charScale():Float{
		return size / font.size;
	}
	
}