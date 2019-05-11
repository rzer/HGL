package hgl.ui.scenes;

import hgl.common.tasks.Task;
import hgl.common.time.Ticker;
import hgl.ui.core.Component;

/*
Scene manager with curtains (await runtime resource loading and scene preparations)
@author rzer
@version 1.0
*/
class SceneManager extends Component{

    private var curtains:Map<String,Curtain> = new Map<String,Curtain>();

    public var curtain:Curtain;
    public var current:Scene;
    public var next:Scene;

    public function new(parent:Component) {
        super(parent);
		w = parent.w;
		h = parent.h;
		parent.onResized.add(resize);
        addCurtain("default", new CurtainDefault());
    }

    public function addCurtain(name:String, curtain:Curtain):Void{
        curtains.set(name,curtain);
        curtain.init(this);
    }

    //Меняем сцены. Сначала скрываем текущую под занавской
    public function change(scene:Scene, curtainName:String = "default"):Curtain {
		
		scene.manager = this;
        next = scene;
		
        if (current != null) current.hide();

        curtain = curtains.get(curtainName);
		curtain.updateSize();
        addChild(curtain);
		
        curtain.onShowed.once(unload);
        curtain.show(current != null);

        return curtain;
    }

    //Выгружаем текущую - выполняем все таски
    public function unload():Void{

        if (current == null){
            load();
            return;
        }

        var task:Task = current.unload();
        
        if (task == null){
            load();
            return;
        }

        curtain.setTask(task);
        task.onComplete.once(load);
    }

    public function load():Void{

        if (current != null) {
			removeChild(current);
			current.dispose();
		}

        current = next;
        var task:Task = current.load();

        if (task == null){
            init();
            return;
        }

        curtain.setTask(task);
        task.onComplete.once(init);
    }

    public function init():Void{
        addChildAt(current, numChildren-1);
        current.initOnce();
		current.resize(w, h);
        Ticker.onFrame.once(hideCurtain);
    }

    public function hideCurtain():Void{
		if (curtain == null) return;
        curtain.onHided.once(show);
        curtain.hide();
    }

    private function show():Void {
        removeChild(curtain);
		curtain = null;
        current.show();
    }
	
	override public function resize(w:Int, h:Int):Void {
		super.resize(w, h);
		if (current != null) current.resize(w, h);
		if (curtain != null) curtain.updateSize();
	}


}