package hgl.common.signals;

import hgl.common.time.Ticker;

/*

Signal without params

@author rzer
@version 1.0

*/
class VoidSignal{
	
	private var handlers:Array<Void->Void>;
    private var onceHandlers:Array<Void->Void>;

    private var fireList:Array<Void->Void>;
    private var fireIndex:Int;
		
	public var _isDisposed:Bool = false;
	
	public function new() {
	
	}
	
	public function add(handler:Void->Void, callFirst:Bool = false):Void{
		if (handlers == null) handlers = [];
        _add(handlers, handler, callFirst);
    }

    public function once(handler:Void->Void, callFirst:Bool = false):Void{
		if (onceHandlers == null) onceHandlers = [];
        _add(onceHandlers, handler, callFirst);
    }
	
	private function _add(list:Array<Void->Void>, handler:Void->Void, callFirst:Bool):Void{
        if (_isDisposed) return;
		if (handler == null) return;
        if (list.indexOf(handler) != -1) return;
		
        if (callFirst) list.unshift(handler);
        else list.push(handler);
    }
	
	public function remove(handler:Void->Void):Void{
        if (handlers != null) _remove(handlers, handler);
        if (onceHandlers != null) _remove(onceHandlers, handler);
    }
	
	private function _remove(list:Array<Void->Void>, handler:Void->Void):Void{
        var anIndex:Int = list.indexOf(handler);
        if (anIndex == -1) return;
        if (list == fireList && anIndex <= fireIndex) fireIndex--;
        list.splice(anIndex,1);
    }
	
	public function fire():Void{
		
        if (handlers != null && handlers.length != 0){
			_fire(handlers);
		}

        if (onceHandlers != null && onceHandlers.length != 0){
			var tempHandlers:Array<Void->Void> = onceHandlers;
			onceHandlers = [];
			_fire(tempHandlers);
		}
    }
	
	public function delayedFire():Void {
		Ticker.onFrame.once(fire);
	}
	
	
	private function _fire(list:Array<Void->Void>):Void{

        fireIndex = 0;
        fireList = list;

        while(fireIndex < fireList.length){
            var handler:Void->Void = fireList[fireIndex];
			handler();
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