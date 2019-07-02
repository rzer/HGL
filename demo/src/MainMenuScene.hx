package;


import hgl.assets.Assets;
import hgl.common.tasks.Task;
import hgl.display.text.TextStyle;
import hgl.ui.containters.Scroller;
import hgl.ui.core.Button;
import hgl.ui.core.Image;
import hgl.ui.scenes.Scene;
import hgl.ui.utils.UI;
import hgl.ui.collections.List;

class MainMenuScene extends Scene {
	
	private var list:List;
	private var scroller:Scroller;

	public function new() {
		super();
	}
	
	override public function load():Task {
		return Assets.load("test", [
			"fonts/font"
		]);
	}
	
	override public function init():Void {
		
		UI.textBuilder.addStyle("default", new TextStyle(Assets.get("fonts/font"), 48, 0xffffff, TextAlign.Center));
		
		list = new List(true,1,20,20);
		scroller = new Scroller(this, list, 540, 1280);
		scroller.attach().right(0);
		

		var online:Button = createButton("Play online", whenOnline);
		var hotseat:Button = createButton("Hotseat", whenHotseat);
		var settings:Button = createButton("Settings", whenSettings);
	}
	
	override public function unload():Task {
		Assets.unload("test");
		return null;
	}
	
	private function whenSettings():Void {
		manager.change(new MainScene());
	}
	
	private function whenHotseat():Void {
		//manager.change(new PlayScene());
	}
	
	private function whenOnline():Void {
		//manager.change(new PlayScene());
	}
	
	function createButton(text:String, handler:Void->Void):Button {
		var btn:Button = new Button(null, 500, 100, text, handler);
		list.addItem(btn);
		return btn;
	}
	
}