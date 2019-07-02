package hgl.common.tasks;

/**
 * parallel task
 * @author rzer
 */
class ParallelTask extends MultiTask{

	public function new(tasks:Array<Task> = null) {
		super(true, tasks);
	}
	
}