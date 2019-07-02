package hgl.common.tasks;

/*

Task that process other tasks simultaneously or one by one

@author rzer
@version 1.0

*/
class MultiTask extends Task{

    private var tasks:Array<Task> = [];

    public var isParallel:Bool = true;
    public var tasksCompleted:Int = 0;

    public function new(isParallel:Bool, tasks:Array<Task> = null){
        super();
		this.isParallel = isParallel;
        if (tasks == null) return;
        for(task in tasks) add(task);
    }

    public function add(task:Task):Void{
		if (task == null) return;
		task.autoStart = false;
        tasks.push(task);
    }
	

    override public function process():Void {
		
        super.process();

        tasksCompleted = 0;

        if (tasksCompleted == tasks.length) {
			complete();
			return;
		}

        if (!isParallel) {
			startTask(tasks[0]);
			return;
		}

        for(task in tasks) startTask(task);
    }

    public function startTask(task:Task):Void{
		trace("startTask", Type.getClassName(Type.getClass(task)));
        task.onComplete.once(taskComplete);
        task.onFail.once(fail);
		task.start();
    }

    public function taskComplete():Void{
        tasksCompleted++;

        if (tasksCompleted == tasks.length) {
			complete();
			return;
		}

        if (!isParallel) startTask(tasks[tasksCompleted]);

    }

    override public function get_current():Float{
        var result:Float = 0;
        for (task in tasks) result += task.current;
        return result;
    }

    override public function get_total():Float{
        var result:Float = 0;
        for (task in tasks) result += task.total;
        return result;
    }


}