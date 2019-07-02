package hgl.ui.scenes;

import hgl.common.tasks.Task;
import hgl.ui.core.Component;

class Scene extends Component{

    public var preventDestroy:Bool = false;
	public var isInited:Bool = false;
	public var manager:SceneManager;

    public function new(){
        super();
    }

    public function initOnce():Void {
		if (isInited) return;
		isInited = true;
		init();
	}
	
	public function init():Void {
		
	}

    public function hide():Void{

    }

	
	public function show():Void {
		
	}

    //Какие задачи нужно выполнить прежде чем инициализировать сцену
	public function load():Task {
		return null;
	}
	
	//Какие задачи нужно выполнить при уничтожении сцены
	public function unload():Task {
		return null;
	}
	

}