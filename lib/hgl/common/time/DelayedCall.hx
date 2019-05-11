package hgl.common.time;

/*

@author rzer
@version 1.0

 */
class DelayedCall{
	
	public static var calls:Array<DelayedCall> = [];
	
	public var handler:Void->Void;
	public var stamp:Float;
	public var onlyOnce:Bool;
	public var interval:Int;
	public var destroyed:Bool;
	
	public static function once(f:Void->Void, after:Int):Void add(f, after, true);
	public static function every(f:Void->Void, interval:Int):Void add(f, interval, false);
	
	public static var nearStamp:Float = 0;

	private static function add(f:Void->Void, interval:Int, onlyOnce:Bool):Void {
		
		var c:DelayedCall = find(f);
		if (c == null) calls.push(c = new DelayedCall());
		
		c.destroyed = false;
		c.interval = interval;
		c.onlyOnce = onlyOnce;
		c.stamp = Ticker.stamp + interval;
		c.handler = f;
		
		if (nearStamp > c.stamp || nearStamp == 0) nearStamp = c.stamp;
	}
	
	public static function remove(f:Void->Void):Bool {
		
		for (i in 0 ... calls.length) {
			var c:DelayedCall = calls[i];
			if (c.handler == f) {
				calls.splice(i, 1);
				return true;
			}
		}
		
		return false;
	}
	
	private static function find(f:Void->Void):DelayedCall {
		for (c in calls) {
			if (c.handler == f) return c;
		}
		return null;
	}
	
	
	public static function tick():Void {
		
		if (nearStamp > Ticker.stamp) return;
		nearStamp = 0;
		calls = calls.filter(doCalls);
	}
	
	static private function doCalls(c:DelayedCall):Bool {
		
		if (c.destroyed) return false;
		if (c.stamp > Ticker.stamp) return true;
		if (c.onlyOnce) c.destroyed = true;
			
		c.handler();
			
		if (c.destroyed) return false;
			
		c.stamp = Ticker.stamp + c.interval;
		if (nearStamp > c.stamp || nearStamp == 0) nearStamp = c.stamp;
		return true;
	}
	

	public function new() {}	
}