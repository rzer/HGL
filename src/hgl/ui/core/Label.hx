package hgl.ui.core;

import h2d.Object;
import hgl.display.text.TextField;
import hgl.ui.utils.UI;



class Label extends Component {
	
	public var tf:TextField;
	
	public var text(get, set):String;


	public function new(parent:Object = null, w:Int = 100, h:Int = 100):Void{
		super(parent, w, h);
		
		tf = UI.textBuilder.createField("default", this);
		
		tf.width = w;
		tf.height = h;
	}
	
	public function get_text():String {
		return tf.text;
	}
	
	public function set_text(value:String):String {
		tf.text = value;
		return value;
	}
	
	override public function resize(w:Int, h:Int):Void {
		tf.width  = w;
		tf.height = h;
		super.resize(w, h);
	}
	
	
	
	

}
