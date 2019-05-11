package hgl.display.text;

import h2d.Object;
import h2d.Tile;
import h2d.TileGroup;
import h3d.shader.SignedDistanceField;
import hgl.assets.fonts.FontChar;
import hgl.display.core.TileLayers;
import hgl.display.text.TextStyle.TextAlign;


class TextElement {
	public var char:String = "";
	public var next:TextElement;
	public var x:Float;
	public var y:Float;
	public var scale:Float = 1;
	public var tile:Tile;
	public var group:TileGroup;
	public function new(){}
}

class TextLine extends TextElement {
	public var align:TextAlign = TextAlign.Left;
	public var height:Float = 0;
	public var width:Float = 0;
}



/**
 * Prepare char tiles acording to style
 * You need: <s:bold><i:gold:0.5> 10</s>
 * @author rzer
 */


class TextBuilder {
	
	private var styles:Map<String,TextStyle> = [];
	private var images:Map<String,Tile> = [];
	
	private var line:TextLine;
	private var element:TextElement;
	
	private var style:TextStyle;
	private var styleStack:Array<TextStyle>;
	private var lines:Array<TextLine>;
	
	private var breakWidth:Float = 0;
	private var breakElement:TextElement;
	private var breakSize:Float = 0;
	
	private var previousChar:FontChar;
	

	public function new() {
		
	}
	
	public function createField(styleName:String, ?parent:Object):TextField{
		
		var style:TextStyle = styles.get(styleName);
		
		var tf = new TextField(this,style, parent);
		return tf;
	}
	
	public function addStyle(name:String, style:TextStyle):Void{
		styles.set(name, style);
	}
	
	public function addImage(name:String, tile:Tile):Void{
		images.set(name, tile);
	}
	
	
	public function update(tf:TextField):Void{
		
		
		tf.addChildAt(tf.bg, 0);
		tf.bg.tile.setSize(tf.width, tf.height);
		
		style = new TextStyle();
		
		styleStack = [];
		styleStack.push(tf.style);
		
		computeStyle();
		
		//Parse lines
		lines = [];
		var commandMode:Bool = false;
		var command:String = "";
		var text:String = "";
		
		newLine();
		
		for (i in 0 ... tf.text.length){
			
			var chr:String = tf.text.charAt(i);
			var code:Int = tf.text.charCodeAt(i);
			
			if (code == "<".code){
				commandMode = true;
				continue;
			}
			
			if (code == ">".code){
				
				if (command == "/s"){
					styleStack.pop();
					computeStyle();
					line.align = style.align;
				}else{
					var commandStack:Array<String> = command.split(":");
					
					var commandName:String = commandStack.shift();
					
					if (commandName == "s"){
						var s:TextStyle = styles.get(commandStack.shift());
						styleStack.push(s);
						computeStyle();
					}else if (commandName == "i"){
						
						var imageElement:TextElement = new TextElement();
						imageElement.tile = images.get(commandStack.pop());
						imageElement.scale = commandStack.length > 0 ? Std.parseFloat(commandStack.pop()) : 1;
						imageElement.group = tf.layers.getLayer("image", imageElement.tile);
						
						var imageWidth:Float = imageElement.tile.width * imageElement.scale;
						
						if (tf.width <= line.width + imageWidth){
							newLine();
						}
						
						imageElement.x = line.width;
						imageElement.y = (line.height - imageElement.tile.height * imageElement.scale) / 2;
						
						line.width += imageWidth;
						element.next = imageElement;
						element = imageElement;
						
						previousChar = null;
						
					}
					
				}
				
				command = "";
				commandMode = false;
				continue;
			}
			
			if (commandMode){
				command += chr;
				continue;
			}
			
			if (code == "\n".code){
				newLine();
				previousChar = null;
				continue;
			}
			
			//add char
			
			var char:FontChar = style.font.getChar(code);
			if (char == null) continue;
			
			
			if (style.font.charset.isBreakChar(code) ){
				
				//Идеальная ситуация - символ сразу переполнил длину строки
				if (tf.width < line.width + char.xAdvance * style.charScale()){
					newLine();	
					previousChar = null;
				//Запоминаем ширину при последнем возможном разрыве	
				}else{
					breakWidth = line.width;
					breakElement = element;
					breakSize = 0;
				}
				
				//Пробелы не отрисовываем и скипаем в начале строки
				if (style.font.charset.isSpace(code)){
					breakSize = char.xAdvance * style.charScale();
					if (line.width > 0) line.width += breakSize;
					continue;
				}
				
			}
			
			var kerning:Float = char.getKerning(previousChar) * style.charScale();
			
			if (previousChar != null) trace("kerning", chr, String.fromCharCode(previousChar.code));
			
			var charElement:TextElement = new TextElement();
			
			line.height = Math.max(line.height, style.font.lineHeight* style.charScale());
	
			charElement.tile = char.tile;
			charElement.x = line.width + kerning ;
			charElement.y = style.font.yCorrection * style.charScale();
			charElement.scale = style.charScale();
			charElement.group = tf.layers.getLayer(style.getLayerName(), charElement.tile, addTextShader);
			charElement.char = chr;
			
			line.width += kerning + char.xAdvance * style.charScale();
			
			element.next = charElement;
			element = charElement;
			
			previousChar = char;
			
			
			//Случилось переполнение строки - переносим все символы после разрыва на новую строку
			
			if (tf.width < line.width && breakElement != null){
				
				var newWidth:Float = line.width - breakWidth - breakSize;
				var startElement:TextElement = breakElement;
				
				line.width = breakWidth;
				newLine();
				line.width = newWidth;
				
				if (startElement.next != null){
					
					var e:TextElement = startElement.next;
					startElement.next = null;
					line.next = e;
					
					var dx:Float = e.x;
					
					while (e != null){
						
						element = e;
						e.x -= dx;
						e = e.next;
					}
				}
				
			}
			
		}
		
		//calculate result list
		
		var totalHeight:Float = 0;
		for (line in lines) totalHeight += line.height;
		
		var posY:Float = (tf.height - totalHeight) / 2;
		
		for (line in lines){
			
			var posX:Float = 0;
			if (line.align == TextAlign.Right) posX = tf.width - line.width;
			else if (line.align == TextAlign.Center) posX = (tf.width - line.width) / 2;
			
			var element:TextElement = line.next;
			
			while (element != null){
				
				element.group.addTransform(posX + element.x, posY + element.y,element.scale,element.scale,0, element.tile);
				element = element.next;
			}
			
			posY += line.height;
		}
	}
		
	private function addTextShader(layer:TileGroup):Void{
		var shader:MSDFShader = new MSDFShader();
		//var shader:SignedDistanceField = new SignedDistanceField();
		layer.addShader(shader);
	}
	
	
	private function newLine():Void{
		breakWidth = 0;
		breakSize = 0;
		breakElement = null;
		
		line = new TextLine();
		line.align = style.align;
		element = line;
		
		lines.push(line);
	}
	
	private function computeStyle():Void{
		for (s in styleStack){
			if (s.align != TextAlign.Inherit) style.align = s.align;
			if (s.color != -1) style.color = s.color;
			if (s.size != -1) style.size = s.size;
			if (s.font != null) style.font = s.font;
			if (s.filter != null) style.filter = s.filter;
		}
	}
	
}