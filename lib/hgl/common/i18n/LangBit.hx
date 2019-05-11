package hgl.common.i18n;

import hgl.common.performance.Pool;

/*

Bit of a text to translate
@author rzer
@version 1.0

*/

class LangBit {
	
	public static var pool:Pool<LangBit> = new Pool<LangBit>(()->new LangBit());
	
	public static function get(key:String, params:Dynamic = null):LangBit{
		var bit:LangBit = pool.take();
		bit.init(key, params);
		return bit;
	}
	
	public var key:String;
	public var params:Dynamic;
	
	public var onChanged:Void->Void;
	
	public function new() {
		
	}
	
	public function init(key:String, params:Dynamic):Void{
		this.key = key;
		this.params = params;
		Lang.onChanged.add(change);
	}
	
	public function setParams(params:Dynamic = null):Void{
		this.params = params;
		change();
	}
	
	public function change():Void{
		if (onChanged != null) onChanged();
	}
	
	public function destroy():Void{
		Lang.onChanged.remove(change);
		onChanged = null;
		pool.put(this);
	}
	
	public function getText():String{
		return Lang.translate(key, params);
	}
	
}