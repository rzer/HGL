package hgl.common.tasks;

/**
 * serial task
 * @author rzer
 */
class SerialTask extends MultiTask{

	public function new(tasks:Array<Task> = null) {
		super(false,tasks);
	}
	
}