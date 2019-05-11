package hgl.ui.core;

import h2d.Interactive;
import hgl.common.signals.VoidSignal;
import hgl.common.time.Ticker;
import hxd.Event;

enum TouchState {
	Up;
	Down;
	LongDown;
	Scroll;
}

enum ScrollDirection {
	None;
	Horizontal;
	Vertical;
}

typedef TouchPoint = {
	var x:Float;
	var y:Float;
}



/**
 * Additional events for easy handling
 * @author rzer
 */
class Touch extends Interactive {

	public static var longTapDelay:Float = 1000;
	public static var scrollSensivity:Float = 50;
	
	public var scrollDirection:ScrollDirection = ScrollDirection.None;
	public var touchState:TouchState = TouchState.Up;
	
	public var touchStart:TouchPoint = { x:0, y:0 };
	public var touchCurrent:TouchPoint = { x:0, y:0 };
	public var touchStartTime:Float = 0;
	
	public var onTouchScroll:VoidSignal = new VoidSignal();
	public var onTouchStart:VoidSignal = new VoidSignal();
	public var onTouchEnd:VoidSignal = new VoidSignal();
	public var onTap:VoidSignal = new VoidSignal();
	public var onLongTap:VoidSignal = new VoidSignal();

	public function new(width, height, ?parent) {
		super(width, height, parent);
		propagateEvents = true;
	}
	
	override public function onPush(e:Event):Void {
		if (touchState != TouchState.Up) return;
		touchState = TouchState.Down;
		
		touchStart.x = e.relX;
		touchStart.y = e.relY;
		
		onTouchStart.fire();
		
		touchStartTime = 0;
		Ticker.onFrameTick.add(downTick);
	}
	
	override public function onRelease(e:Event):Void {
		
		if (touchState == TouchState.Scroll) {
			
			scrollDirection = ScrollDirection.None;
			
		}else if (touchState == TouchState.Down) {
			
			Ticker.onFrameTick.remove(downTick);
			onTap.fire();
		}
		
		touchState = TouchState.Up;
		onTouchEnd.fire();
	}
	
	override public function onMove(e:Event):Void {
		
		if (touchState == TouchState.Down) {
			
			touchCurrent.x = e.relX;
			touchCurrent.y = e.relY;
			
			if (Math.abs(touchCurrent.x - touchStart.x) > scrollSensivity) scrollDirection = ScrollDirection.Horizontal;
			if (Math.abs(touchCurrent.y - touchStart.y) > scrollSensivity) scrollDirection = ScrollDirection.Vertical;
			
			if (scrollDirection != ScrollDirection.None) {
				if (touchState == TouchState.Down) Ticker.onFrameTick.remove(downTick);
				touchState = TouchState.Scroll;
				onTouchScroll.fire();
			}
		}
		
		else if (touchState == TouchState.Scroll) {
			touchCurrent.x = e.relX;
			touchCurrent.y = e.relY;
			onTouchScroll.fire();
		}
		
	}
	
	//Переход в longtap
	private function downTick(dt:Float):Void {
		
		touchStartTime += dt;
		if (touchStartTime < longTapDelay) return;
		
		Ticker.onFrameTick.remove(downTick);
		touchState = TouchState.LongDown;
		
		onLongTap.fire();
	}
	
	public function dispose():Void {
		
		Ticker.onFrameTick.remove(downTick);
			
		onTouchScroll.dispose();
		onTouchStart.dispose();
		onTouchEnd.dispose();
		onTap.dispose();
		onLongTap.dispose();
	}
	

	
}