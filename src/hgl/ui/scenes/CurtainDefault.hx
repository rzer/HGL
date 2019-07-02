package hgl.ui.scenes;

import h2d.Bitmap;
import h2d.Sprite;
import h2d.Tile;
import hgl.common.time.Ticker;
import hgl.ui.utils.UI;

using hgl.common.time.Tween;
using hgl.common.math.Easing;

class CurtainDefault extends Curtain {

	var bmp:Bitmap;
	var tile:Tile;

    public function new(){
        super();

		tile = Tile.fromColor(0xff0000, 4, 4);
		bmp = new Bitmap(tile, this);
		
		UI.colorBg(this, 0);
    }

    override public function show(useAnimation:Bool = true):Void {
		
		Ticker.onFrame.add(updateProgress);
		
        if (!useAnimation) {
			onShowed.fire();
			return;
		}
		
		
		changeAlpha.tween(1, [0, 1]).onComplete.once(onShowed.fire);
    }
	
	private function updateProgress():Void {
		//tile.width = Math.round(task.progress * w);
	}
	
	public function changeAlpha(rate:Float, args:Array<Float>):Void{
		alpha = rate.lerp(args[0], args[1]);	
	}


    override public function hide(useAnimation:Bool = true):Void {
		trace("hide");
		
		Ticker.onFrame.remove(updateProgress);
		
		if (!useAnimation) {
			onHided.fire();
			return;
		}
		
		changeAlpha.tween(1, [1, 0]).onComplete.once(onHided.fire);
		
    }
	


}