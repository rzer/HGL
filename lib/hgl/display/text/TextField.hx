package hgl.display.text;

import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import hgl.display.core.TileLayers;
import hgl.display.text.TextBuilder.TextElement;
import hgl.display.text.TextBuilder.TextLine;
import hgl.display.text.TextStyle.TextAlign;

/**
 * Default text view
 * @author rzer
 */
class TextField extends Object{
	
	public var builder:TextBuilder;
	public var style:TextStyle;
	public var layers:TileLayers;
	
	public function new(builder:TextBuilder, style:TextStyle, ?parent:Object):Void{
		super(parent);
		
		trace("set textfield style", style);
		
		this.builder = builder;
		this.style = style;
		
		this.layers = new TileLayers(this);
	}
	
	
	public var bg:Bitmap = new Bitmap(Tile.fromColor(0xffff00, 1, 1));
	
	public var text(default, set):String = "";
	public var width(default, set):Int = 200;
	public var height(default, set):Int = 20;

	public function set_text(value:String):String{
		text = value;
		builder.update(this);
		return value;
	}
	
	public function set_width(value:Int):Int{
		width = value;
		builder.update(this);
		return value;
	}
	
	public function set_height(value:Int):Int{
		height = value;
		builder.update(this);
		return value;
	}
	
	public function render(blocks:Array<TextElement>):Void{
		layers.clear();
		
	}
	
	
}