package hgl.common.time;

import hgl.common.signals.VoidSignal;
import hgl.common.signals.OneSignal;
import haxe.Timer;
import hxd.System;

/*

Диспатчит события каждый кадр и каждую секунду

@author rzer
@version 1.0

*/

class Ticker {
	
	public static var stamp:Float;

    public static var onFrameTick:OneSignal<Float> = new OneSignal<Float>();
    public static var onFrame:VoidSignal = new VoidSignal();
    public static var onSecond:VoidSignal = new VoidSignal();
    
    private static var lastSecond:Float = 0;
    private static var lastFrame:Float =  Timer.stamp();
	
	#if nodejs
	
	public static function init(fps:Int):Void{
		js.Node.setInterval(Ticker.tick, 1000 / fps);
	}
	
	#elseif js
	
	public static function init(fps:Int):Void{
		js.Browser.window.setInterval(whenInterval, 1000 / fps);
	}
	
	private static function whenInterval():Void{
		js.Browser.window.requestAnimationFrame(function(t:Float){ Ticker.tick(); });
	}
	
	#elseif flash
	
	public static function init(fps:Int):Void{
		var stage = flash.Lib.current.stage;
		stage.frameRate = fps;
		stage.addEventListener(flash.events.Event.ENTER_FRAME, whenEnterFrame);
	}
	
	private static function whenEnterFrame(e:flash.events.Event):Void{
		Ticker.tick();
	}	
	#end
	
	public static function systemTime():Float{
		return Date.now().getTime();
	}

    public static function tick():Void{
		
        onFrame.fire(); 

        stamp = Timer.stamp();
        onFrameTick.fire(stamp - lastFrame);
        lastFrame = stamp;

        if (stamp - lastSecond > 1){
            lastSecond = stamp;
            onSecond.fire();
        }
		
		
		DelayedCall.tick();
		
    }
	

}