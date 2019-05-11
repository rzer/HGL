package hgl.assets.atlases;

/**
 * ...
 * @author rzer
 */

class AtlasItem{
	
	public function new(){ }
	
	public var name:String;
	
	//Animation frame index
	public var index:Int = 0;
	
	//Region at texture
	public var rX:Int = 0;
	public var rY:Int = 0;
	public var rW:Int = 0;
	public var rH:Int = 0;
	
	//Size of image before trim, and left & top trim 
	public var w:Int = 0;
	public var h:Int = 0;
	public var tX:Int = 0;
	public var tY:Int = 0;
	
	//Pivot
	public var pX:Int = 0;
	public var pY:Int = 0;
	
}