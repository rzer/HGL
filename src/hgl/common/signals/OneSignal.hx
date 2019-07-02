package hgl.common.signals;

import hgl.common.time.Ticker;

/*

Signal with one param

@author rzer
@vesrion 1.0

*/

class OneSignal<T>{
	
	private var handlers:Array<T->Void>;
    private var onceHandlers:Array<T->Void>;

    private var fireList:Array<T->Void>;
    private var fireIndex:Int;
		
	public var _isDisposed:Bool = false;
	
	private var p1:T;
	
	public function new() {
	
	}
	
	public function add(handler:T->Void, callFirst:Bool = false):Void{
		if (handlers == null) handlers = [];
        _add(handlers, handler, callFirst);
    }

    public function once(handler:T->Void, callFirst:Bool = false):Void{
		if (onceHandlers == null) onceHandlers = [];
        _add(onceHandlers, handler, callFirst);
    }
	
	private function _add(list:Array<T->Void>, handler:T->Void, callFirst:Bool):Void{
		
        if (_isDisposed) return;
		if (handler == null) return;
        if (list.indexOf(handler) != -1) return;
		
        if (callFirst) list.unshift(handler);
        else list.push(handler);
    }
	
	public function remove(handler:T->Void):Void{
        if (handlers != null) _remove(handlers, handler);
        if (onceHandlers != null) _remove(onceHandlers, handler);
    }
	
	private function _remove(list:Array<T->Void>, handler:T->Void):Void{
        var anIndex:Int = list.indexOf(handler);
        if (anIndex == -1) return;
        if (list == fireList && anIndex <= fireIndex) fireIndex--;
        list.splice(anIndex,1);
    }
	
	public function fire(p1:T):Void{
		
        if (handlers != null && handlers.length != 0){
			_fire(handlers, p1);
		}

        if (onceHandlers != null && onceHandlers.length != 0){
			var tempHandlers:Array<T->Void> = onceHandlers;
			onceHandlers = [];
			_fire(tempHandlers, p1);
		}
    }
	
	public function delayedFire(p1:T):Void {
		this.p1 = p1;
		Ticker.onFrame.once(whenDelay);
	}
	
	private function whenDelay():Void {
		fire(p1);
	}
	
	private function _fire(list:Array<T->Void>, p1:T):Void{

        fireIndex = 0;
        fireList = list;

        while(fireIndex < fireList.length){
            var handler:T->Void = fireList[fireIndex];
			handler(p1);
            fireIndex++;
        }
    }
	
	public function removeAll():Void{
        if (_isDisposed) return;
        handlers = null;
        onceHandlers = null;
    }
	
	
	public function dispose():Void {
		removeAll();
        _isDisposed = true;
	}
	
}