package;

import h2d.Bitmap;
import h2d.Scene;
import h2d.Tile;
import hgl.assets.Assets;
import hgl.assets.atlases.Atlas;
import hgl.display.text.TextBuilder;
import hgl.display.text.TextField;
import hgl.display.text.TextStyle;
import hgl.ui.core.Viewport;
import hgl.ui.scenes.SceneManager;
import hgl.ui.utils.UI;

import hgl.common.tasks.Task;
import hgl.common.time.Ticker;
import hgl.net.Loader;
import hxd.BitmapData;


/**
 * 
 * @author rzer
 */
class Main extends hxd.App {
	
	public static var viewport:Viewport;
	public static var scenes:SceneManager;
	
	override function init() {
		
		Ticker.init(30);
		UI.debug = true;
		
		Assets.addType("tile", hgl.assets.tasks.LoadTile.task);
		Assets.addType("hga", hgl.assets.atlases.tasks.LoadHGA.task);
		Assets.addType("hgf", hgl.assets.fonts.tasks.LoadHGF.task);
		
  
		viewport = new Viewport(this);
		viewport.init(0, 1280);
		
	
		scenes = new SceneManager(viewport);
		scenes.change(new PrepareScene());
	
    }
	
	override function onResize() {
		
		viewport.whenResize();
	}
	
    static function main() {
        new Main();
    }
}