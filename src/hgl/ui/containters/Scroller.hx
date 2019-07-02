package hgl.ui.containters;

import h2d.Interactive;
import h2d.Object;
import hgl.common.signals.VoidSignal;
import hgl.ui.core.Component;
import hgl.ui.core.Touch.ScrollDirection;
import hgl.ui.core.Touch.TouchPoint;
import hgl.ui.utils.UI;

/**
 * ...
 * @author rzer
 */
class Scroller extends Container {
	
	private var startPos:TouchPoint = { x:0, y:0 };
	public var scrollBoth:Bool = false;
	
	public var onScroll:VoidSignal = new VoidSignal();
	

	public function new(parent:Object = null, target:Component =  null, w:Int = 100, h:Int = 100) {
		super(parent, target, w, h);
		
		
		touch.onTouchStart.add(whenStart);
		touch.onTouchScroll.add(whenScroll);
		
		target.onResized.add(whenTargetResize);
	}
	
	private function whenTargetResize(w:Int, h:Int) {
		updateScroll();
	}
	
	
	private function whenStart():Void {
		startPos.x = target.x;
		startPos.y = target.y;
	}
	
	private function whenScroll():Void {
		
		if (touch.scrollDirection == ScrollDirection.Horizontal || scrollBoth){
			target.x = startPos.x + (touch.touchCurrent.x - touch.touchStart.x);
		}
			
		if (touch.scrollDirection == ScrollDirection.Vertical || scrollBoth){
			target.y = startPos.y + (touch.touchCurrent.y - touch.touchStart.y);
		}
		
		updateScroll();	
	}
	
	override function resize(w:Int, h:Int):Void {
		super.resize(w, h);
		updateScroll();
	}
	
	private function updateScroll():Void {
		
		if (target.w > w) {
			
			if (target.x > 0) {
				target.x = 0;
			}else if (target.x < w - target.w) {
				target.x = w - target.w;
			}
			
		}else {
			target.x = (w - target.w) / 2;
		}

		if (target.h > h) {
			
			if (target.y > 0) {
				target.y = 0;
			}else if (target.y < h - target.h) {
				target.y = h - target.h;
			}
			
		}else{
			target.y = (h - target.h)/2;
		}
		
		onScroll.delayedFire();
	}
	
	public function getVStart():Float {
			var pos:Float = -target.y / target.h;
			if (pos < 0) pos = 0;
			return pos;
		}
		
		public function getVEnd():Float {
			var pos:Float = (h - target.y) / target.h;
			if (pos > 1) pos = 1;
			return pos;
		}
		
		public function getHStart():Float {
			var pos:Float = -target.x / target.w;
			if (pos < 0) pos = 0;
			return pos;
		}
		
		public function getHEnd():Float {
			var pos:Float = (w - target.x) / target.w;
			if (pos > 1) pos = 1;
			return pos;
		}
	
}