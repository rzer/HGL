package hgl.common.performance;

/*

Pool of objects
@author rzer
@example

var pool:Pool<LangKey> = new Pool<LangKey>(()->new LangKey());
var key:LangKey = pool.take();
key.destroy();

 */

class Pool<T>{
	
	private var list:Array<T> = [];
	private var instance:Void->T;
	
	public function new(instance:Void->T) {
		this.instance = instance;
	}
	
	public function take():T{
		if (list.length > 0) return list.pop();
		return instance();
	}
	
	public function put(item:T){
		list.push(item);
	}
	
}