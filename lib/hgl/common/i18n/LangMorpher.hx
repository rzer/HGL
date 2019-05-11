package hgl.common.i18n;

/**
 * Default morpher. Just replaces param keys to them values
 * @author rzer
 */
class LangMorpher {

	public function new() {
		
	}
	
	public function morph(str:String, params:Dynamic):String{
		
		for (p in Reflect.fields(params)){
			str = str.split("[" + p + "]").join(Reflect.field(params, p));
		}
		
		return str;
	}
	
}