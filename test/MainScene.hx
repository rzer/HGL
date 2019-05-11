package;

import h2d.Bitmap;
import hgl.assets.Assets;
import hgl.assets.atlases.Atlas;
import hgl.common.tasks.Task;
import hgl.display.text.TextBuilder;
import hgl.display.text.TextField;
import hgl.display.text.TextStyle;
import hgl.ui.scenes.Scene;
import hgl.ui.utils.UI;

/**
 * ...
 * @author rzer
 */
class MainScene extends Scene {

	
	override public function load():Task {
		return Assets.load("main", [
			"cow",
			"world/tiles",
			"fonts/font"
		]);
	}
	
	override public function init():Void {
		

		var atlas:Atlas = Assets.get("world/tiles");
		var bmp:Bitmap = new Bitmap(Assets.get("cow"), this);
		bmp.x = 100;
		bmp.y = 100;
		
		var defaultStyle:TextStyle = new TextStyle(Assets.get("fonts/font"), 96, 0xffffff, TextAlign.Center);
		defaultStyle.outline();
		
		var builder:TextBuilder = new TextBuilder();
		builder.addStyle("default", defaultStyle);
		
		var tf:TextField = builder.createField("default", this);
		tf.height = 100;
		tf.text = "Hello, Porlds!";
		
		tf.x = 300;
		tf.y = 300;
	}
	
}