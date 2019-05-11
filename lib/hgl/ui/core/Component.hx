package hgl.ui.core;

import h2d.Object;
import hgl.common.signals.TwoSignal;
import hgl.ui.utils.Attachment;
import hgl.ui.utils.UI;


class Component extends Object {

    public var w:Int;
    public var h:Int;

    public var onResized:TwoSignal<Int,Int> = new TwoSignal<Int,Int>();
	public var isDisposed:Bool = false;
	
	public var touch(get, never):Touch;
	private var _touch:Touch = null;
	private var attachment:Attachment;

    public function new(parent:Object = null, w:Int = 100, h:Int = 100){
        super(parent);
        this.w = w;
        this.h = h;
		
		if (UI.debug) UI.colorBg(this);
    }
	
	public function attach():Attachment {
		if (attachment == null) attachment = new Attachment(this);
		attachment.update();
		return attachment;
	}
	
	public function detach():Void {
		if (attachment == null) return;
		attachment.dispose();
		attachment = null;
	}
	
	public function get_touch():Touch {
		if (_touch == null) _touch = new Touch(w, h, this);
		return _touch;
	}
	
    public function resize(w:Int, h:Int):Void{

        this.w = w;
        this.h = h;
		
		if (_touch != null) {
			_touch.width = w;
			_touch.height = h;
		}
		
        onResized.fire(w,h);
    }
	
	
	public function dispose():Void {
		
		isDisposed = true;
		
		detach();
		
		if (_touch != null) {
			_touch.dispose();
			_touch = null;
		}
		
		onResized.dispose();
	}


}