package hgl.common.time;

import hgl.common.signals.VoidSignal;
import hgl.common.time.Ticker;

/*

Твинер
Прообраз shohei909/TweenXCore

@example

using hgl.common.time.Tween;
using hgl.common.math.Easing;

flyBox.tween(2,[x,200,y,100]);

public function flyBox(rate:Float, args:Array<Float>):Void{
    var q = rate.quintIn();
    x = q.lerp(args[0],args[1]);
    y = q.lerp(args[2],args[3]);
}

@author rzer
@version 1.0

*/

class Tween {

    private var func:Float->Array<Float>->Void;
    private var args:Array<Float>;

    private var total:Float = 1;
    private var current:Float = 0;

    public var rate:Float = 0;

    public var onComplete:VoidSignal = new VoidSignal();
    
    public function new(){

    }

    public function animate(func:Float->Array<Float>->Void, time:Float, args:Array<Float> = null):Void{
        
        this.func = func;
        this.total = time;
        this.current = 0;
        this.args = args;

        start();
    }

    public function reset():Void{
        current = 0;
    }

    public function start():Void{
        Ticker.onFrameTick.add(tick);
        tick(0);
    }

    public function stop():Void{
        Ticker.onFrameTick.remove(tick);
    }

    public function tick(dt:Float):Void{

        current += dt;

        rate = current/total;
        if (rate > 1) rate = 1;

        func(rate, args);

        if (rate != 1) return;
        stop();
		onComplete.fire();

    }

   

    public static function tween(func:Float->Array<Float>->Void, time:Float, args:Array<Float> = null):Tween{
        var tween:Tween = new Tween();
        tween.animate(func, time, args);
        return tween;
    }


}