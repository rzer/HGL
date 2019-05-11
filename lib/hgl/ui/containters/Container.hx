package hgl.ui.containters;

import h2d.Mask;
import h2d.Object;
import hgl.ui.core.Component;
import hgl.common.time.Ticker;

/**
 * ...
 * @author rzer
 */
class Container extends Component {
	
	private var mask:Mask;
	
	public var target:Component;
	public var items:Array<Component> = [];

	public function new(parent:Object = null, target:Component =  null, w:Int = 100, h:Int = 100) {
		super(parent, w, h);
		mask = new Mask(w, h, this);
		
		if (target == null) target = new Component();
		mask.addChild(target);
		this.target = target;
	}
	
	override function resize(w:Int, h:Int):Void{

        mask.width = w;
		mask.height = h;
		
        onResized.fire(w,h);
    }
	
	
	
}