package hgl.ui.core;

import hxd.App;

	
/*
Scale content to desire proportions
@author rzer
@version 1.0

class Main extends hxd.App {


  override function init() {
  
    viewport = new Viewport(this);

    //Always 640 height and width/height proprotions from 1/2 to 2/1
    viewport.init(0, 640, 1/2, 2/1); 

    //width/height proprotions from 1/2 to 2/1. Width and height are pixels
    viewport.init(0, 0, 1/2, 2/1); 
    
    //Equal to ScaleMode.SHOW_ALL и StageAlign.CENTER
    viewport.init(640, 320); 
  }
  
}
*/


class Viewport extends Component{

    public static var instance:Viewport;
	
	public var app:App;
	
	private var requiredWidth:Int;
	private var requiredHeight:Int;

	private var minRatio:Float;
	private var maxRatio:Float;
	
	public var stageWidth:Float;
	public var stageHeight:Float;

    public function new(app:App) {
		instance = this;
		this.app = app;
        super(app.s2d);
		app.s2d.renderer.defaultSmooth = true;
    }

	
    public function init(requiredWidth:Int = 0, requiredHeight:Int = 0, minRatio:Float = 0, maxRatio:Float = 0):Void {
		
		this.requiredWidth = requiredWidth;
		this.requiredHeight = requiredHeight;
		this.minRatio = minRatio;
		this.maxRatio = maxRatio;

		whenResize();
	}

    public function whenResize():Void {
		
		var nW:Float = app.s2d.width;
		var nH:Float = app.s2d.height;
		
		trace("resize",nW,nH);

		var stageRatio:Float = nW / nH;

		if (minRatio > 0 && stageRatio < minRatio) setRatio(minRatio);
		else if (maxRatio > 0 && stageRatio > maxRatio) setRatio(maxRatio);
		else setRatio(stageRatio);

		var s:Float = Math.max(w/nW, h/nH);
		
		stageWidth = nW * s;
		stageHeight = nH * s;
		
        setScale(1/s);

		x = (stageWidth - w) / 2 / s;
        y = (stageHeight - h) / 2 / s;

		resize(w, h);
	}

    private function setRatio(ratio:Float):Void{
		
		if (requiredWidth > 0 && requiredHeight > 0){
			w = requiredWidth;
			h = requiredHeight;
		}else if (requiredWidth > 0){
			w = Std.int(requiredWidth);
			h = Std.int(requiredWidth / ratio);
		}else if (requiredHeight > 0){
			h = requiredHeight;
			w = Std.int(h * ratio);
		}else{
			
			var nW:Int = app.s2d.width;
			var nH:Int = app.s2d.height;
		
			var stageRatio:Float = nW / nH;
			
			if (ratio > stageRatio){
				w = nW;
				h = Std.int(w / ratio);
			}else{
				h = nH;
				w = Std.int(h * ratio);
			}
			
		}
		
		
	}

}