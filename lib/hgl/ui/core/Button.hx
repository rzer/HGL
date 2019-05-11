package hgl.ui.core;

import h2d.Object;
import hgl.common.time.Ticker;
import hgl.ui.utils.UI;

/**
 * ...
 * @author rzer
 */
class Button extends Component {
	
	private var label:Label;
	private var image:Image;
	
	public var text(get, set):String;
	public var icon(get, set):String;
	public var gap:Int = 0;

	public function new(parent:Object = null, w:Int = 100, h:Int = 100, text:String = "", handler:Void->Void = null) {
		super(parent, w, h);
		
		touch.onTap.add(handler);
		this.text = text;
		
	}
	
	function get_text():String {
		if (label == null) return "";
		return label.text;
	}
	
	function set_text(value:String):String {
		
		Ticker.onFrame.once(arrange);
		
		if (value == ""){
			
			if (label != null){
				label.dispose();
				label = null;
			}
			
			return value;
		}
		
		if (label == null){
			label = new Label(this, w, h);
		
		}
		
		label.text = value;
		return value;
	}
	
	private function arrange():Void {
		
		/*if (label == null && image == null) return;
		
		if (label == null){
			image.x = Std.int((w - image.w) / 2);
			image.y = Std.int((h - image.h) / 2);
		}
		
		if (icon == null){
			label.align = Align.Center;
			label.x = 0;
			label.y = 0;
			label.resize(w, h);
			label.update();
			return;
		}
			
		label.align = Align.Left;		
		label.resize(w-image.w, h);
		label.update();
		
		var totalWidth:Int = image.w +label.textWidth+gap;
		
		image.x = Std.int((w - totalWidth) / 2);
		image.y = Std.int((h - image.h) / 2);
		label.x = image.x + image.w + gap;*/
		
	}
	
	function get_icon():String {
		if (image == null) return "";
		return image.path;
	}
	
	function set_icon(value:String):String {
		
		Ticker.onFrame.once(arrange);
		
		if (value == ""){
			
			if (image != null){
				image.dispose();
				image = null;
			}
			return value;
		}
		
		if (image == null){
			image = new Image(value, this);
		}else{
			image.change(value);
		}
		
		return value;
	}
	
	
	
}