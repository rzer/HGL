package hgl.common.tasks;

import hgl.common.signals.VoidSignal;
import hgl.common.signals.OneSignal;
import hgl.common.signals.TwoSignal;
import hgl.common.time.Ticker;

/*

Base class for any task

@author rzer
@version 1.0

*/
class Task {

    private static var list:Array<Task> = [];

    public var onComplete:VoidSignal = new VoidSignal();
	public var onProgress:TwoSignal<Float,Float> = new TwoSignal<Float,Float>();
    public var onFail:OneSignal<String> = new OneSignal<String>();
	
	public var status:String;
	
	public var current(get, set):Float;
	public var total(get, set):Float;
	public var progress(get, never):Float;
	
	private var _current:Float = 1;
	private var _total:Float = 1;
	
	public var autoStart:Bool = true;
	public var isStarted:Bool = false;
	
    public function new(){
		Ticker.onFrame.once(checkStart);
    }
	

    public function start():Void{
		Ticker.onFrame.once(immidiateStart);
    }
	
	function immidiateStart():Void {
		if (isStarted) return;
		isStarted = true;
        list.push(this);
		process();
	}
	
	private function checkStart():Void{
		if (autoStart) immidiateStart();
	}
	
	public function process(){
		
	}

    public function complete():Void{
		isStarted = false;
        list.remove(this);
        onComplete.fire();
    }

    public function fail(msg:String){
		trace("fail", msg);
		isStarted = false;
        onFail.fire(msg);
    }

    public function get_current():Float return _current;
    public function set_current(current:Float):Float return _current = current;
	
    public function get_total():Float return _total;
	public function set_total(total:Float):Float  return _total = total;
	
	public function setProgress(current:Float, total:Float):Void{
		this.current = current;
		this.total = total;
		onProgress.fire(current, total);
	}

    public function get_progress():Float {
		return _current / _total;
	}


}