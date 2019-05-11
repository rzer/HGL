package;

import hgl.assets.Assets;
import hgl.common.tasks.Task;
import hgl.ui.scenes.Scene;

/**
 * ...
 * @author rzer
 */
class PrepareScene extends Scene{
	
	
	override public function load():Task {
		return Assets.init();
	}
	
	override public function init():Void {
		
	}
	
	override public function show():Void {
		Main.scenes.change(new MainMenuScene());
	}
	
}