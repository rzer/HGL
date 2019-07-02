package hgl.ui.scenes;


import hgl.common.signals.VoidSignal;
import hgl.common.tasks.Task;
import hgl.ui.core.Component;
import hgl.ui.core.Viewport;

class Curtain extends Component{

    public var task:Task;
    public var manager:SceneManager;

    public var onShowed:VoidSignal = new VoidSignal();
    public var onHided:VoidSignal = new VoidSignal();
    
    public function new(){
        super();
    }

    public function init(manager:SceneManager):Void{
        this.manager = manager;
        manager.onResized.add(resize);
    }

    public function show(useAnimation:Bool = true):Void{
        onShowed.fire();
    }

    public function hide(useAnimation:Bool = true):Void{
        onHided.fire();
    }

    public function setTask(task:Task):Void{
        this.task = task;
    }
	
	public function updateSize():Void {
		
		var v:Viewport = Viewport.instance;
		
		x = Math.floor((v.w - v.stageWidth) / 2);
		y = Math.floor((v.h - v.stageHeight) / 2);
		
		
		resize(Math.ceil(v.stageWidth), Math.ceil(v.stageHeight));
	}
	
	



}