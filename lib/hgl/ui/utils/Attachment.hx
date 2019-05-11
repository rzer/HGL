package hgl.ui.utils;

import hgl.common.time.Ticker;
import hgl.ui.core.Component;

/**
 * Change component size and position arrange to parent component size
 * @author rzer
 */
class Attachment {
	
	public static inline var NONE:Int = -76878;

	private var _left:Float = NONE;
	private var _right:Float = NONE;
	private var _top:Float = NONE;
	private var _bottom:Float = NONE;
	private var _dx:Float = 0;
	private var _dy:Float = 0;
	
	private var target:Component;
	private var parent:Component;

	public function new(target:Component) {
		this.target = target;
		parent = cast(target.parent, Component);
		parent.onResized.add(arrange);
		update();
	}
	
	public function update():Void {
		Ticker.onFrame.once(doUpdate);	
	}
	
	private function doUpdate():Void {
		
		arrange(parent.w, parent.h);
	}
	
	
	public function fill():Attachment { _left = 0; _right = 0; _top = 0; _bottom = 0; return this; }
	public function left(v:Float = 0):Attachment { _left = v; return this; }
	public function right(v:Float = 0):Attachment { _right = v; return this; }
	public function top(v:Float = 0):Attachment { _top = v; return this; }
	public function bottom(v:Float = 0):Attachment { _bottom = v; return this; }
	public function move(dx:Float = 0, dy:Float = 0):Attachment { _dx = dx; _dy = dy; return this; };


	public function arrange(pW:Int, pH:Int):Void {
		
		var stickLeft:Bool = _left != NONE;
		var stickRight:Bool = _right != NONE;
		var stickTop:Bool = _top != NONE;
		var stickBottom:Bool = _bottom != NONE;
		var isResize:Bool = false;
		
		if (stickLeft && stickRight && stickTop && stickBottom) {
			target.x = 0; target.y = 0;
			target.resize(pW, pH);
			return;
		}
		
		if (stickLeft) {
			target.x = measure(_left, pW);
			if (stickRight) {
				target.w = Math.floor(pW - target.x - measure(_right, pW));
				isResize = true;
			}
		}if (stickRight) {
			target.x = pW - target.w - measure(_right, pW);
		}
		
		if (stickTop) {
			target.y = measure(_top, pH);
			if (stickBottom) {
				target.h = Math.floor(pH - target.y - measure(_bottom, pH));
				isResize = true;
			}
		}if (stickBottom) {
			target.y = pH - target.h - measure(_bottom, pH);
		}
		
		//Смещения по осям
		if (stickLeft || stickRight) target.x -= measure(_dx, target.w);
		if (stickTop || stickBottom) target.y -= measure(_dy, target.h);
			
		if (isResize) target.resize(target.w, target.h);
		
	}
	
	private inline function measure(value:Float, size:Float):Float {
		return (value >= -1 && value <= 1) ? size * value : value;
	}
	
	public function dispose():Void {
		parent.onResized.remove(arrange);
		parent = null;
		target = null;
	}
	
}