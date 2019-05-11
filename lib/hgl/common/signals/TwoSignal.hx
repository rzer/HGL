package hgl.common.signals;

import hgl.common.time.Ticker;

/*

Signal with two params

@author rzer
@version 1.0

*/
class TwoSignal<T1,T2>{
	
	private var handlers:Array<T1->T2->Void>;
    private var onceHandlers:Array<T1->T2->Void>;

    private var fireList:Array<T1->T2->Void>;
    private var fireIndex:Int;
		
	public var _isDisposed:Bool = false;
	
	private var p1:T1;
	private var p2:T2;
	
	public function new() {
	
	}
	
	public function add(handler:T1->T2->Void, callFirst:Bool = false):Void{
		if (handlers == null) handlers = [];
        _add(handlers, handler, callFirst);
    }

    public function once(handler:T1->T2->Void, callFirst:Bool = false):Void{
		if (onceHandlers == null) onceHandlers = [];
        _add(onceHandlers, handler, callFirst);
    }
	
	private function _add(list:Array<T1->T2->Void>, handler:T1->T2->Void, callFirst:Bool):Void{
        if (_isDisposed) return;
		if (handler == null) return;
        if (list.indexOf(handler) != -1) return;
		
        if (callFirst) list.unshift(handler);
        else list.push(handler);
    }
	
	public function remove(handler:T1->T2->Void):Void{
        if (handlers != null) _remove(handlers, handler);
        if (onceHandlers != null) _remove(onceHandlers, handler);
    }
	
	private function _remove(list:Array<T1->T2->Void>, handler:T1->T2->Void):Void{
        var anIndex:Int = list.indexOf(handler);
        if (anIndex == -1) return;
        if (list == fireList && anIndex <= fireIndex) fireIndex--;
        list.splice(anIndex,1);
    }
	
	public function fire(p1:T1, p2:T2):Void{
		
        if (handlers != null && handlers.length != 0){
			_fire(handlers, p1, p2);
		}

        if (onceHandlers != null && onceHandlers.length != 0){
			var tempHandlers:Array<T1->T2->Void> = onceHandlers;
			onceHandlers = [];
			_fire(tempHandlers, p1, p2);
		}
    }
	
	public function delayedFire(p1:T1, p2:T2):Void {
		this.p1 = p1;
		this.p2 = p2;
		Ticker.onFrame.once(whenDelay);
	}
	
	private function whenDelay():Void {
		fire(p1, p2);
	}
	
	
	private function _fire(list:Array<T1->T2->Void>, p1:T1, p2:T2):Void{

        fireIndex = 0;
        fireList = list;

        while(fireIndex < fireList.length){
            var handler:T1->T2->Void = fireList[fireIndex];
			handler(p1, p2);
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