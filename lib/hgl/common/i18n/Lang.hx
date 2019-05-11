package hgl.common.i18n;

import hgl.common.signals.VoidSignal;

/**
 * Lang manager
 * @author rzer
 */

class Lang {
	
	public static var onChanged:VoidSignal = new VoidSignal();
	
	public static var name:String;
	private static var keys:Dynamic;
	private static var morpher:LangMorpher;
	
	public static function init(name:String, morpher:LangMorpher, keys:Dynamic){
		Lang.morpher = morpher;
		Lang.name = name;
		Lang.keys = keys;
		onChanged.fire();
	}

	public static function translate(key:String, params:Dynamic):String{
		
		var result:String = key;
		if (Reflect.hasField(keys,key)) result = Reflect.field(keys,key);
		result = morpher.morph(result, params);
		
		return result;
		
	}
	
	
}