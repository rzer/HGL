package hgl.core.math;


import haxe.io.BytesInput;
import haxe.io.BytesOutput;


/*

2D vector and some operation with them
@author rzer
@version 1.0

*/

class Vec2 {
	
	public static var ZERO_DIR:Vec2 = new Vec2(1, 0);
	
	public var x:Float;
	public var y:Float;
	
	
	public static function fromPoints(end:Vec2, start:Vec2):Vec2{
		return new Vec2().equal(end).substract(start);
	}
	
	static public function from(obj:Dynamic):Vec2 {
		return new Vec2(obj.x, obj.y);
	}
	
	public var length(get, never):Float;

	public function new(x:Float = 0, y:Float = 0) {
		this.x = x;
		this.y = y;
	}
	
	public function set(x:Float, y:Float):Void{
		this.x = x;
		this.y = y;
	}
	
	public function toString():String{
		return "[" + x + "," + y + "]";
	}
	
	
	public function get_length():Float{
		return Math.sqrt(dot(this));
	}
	
	public function dot(v:Vec2):Float{
		return x*v.x + y*v.y;
	}
	
	public function normalize():Vec2{
		if (x == 0 && y == 0) return this;
		return multiply(1/length);
	}
	
	public function add(v:Vec2):Vec2{
		x += v.x;
		y += v.y;
		return this;
	}
	
	public function substract(v:Vec2):Vec2{	
		x -= v.x;
		y -= v.y;
		return this;
	}
	
	public function multiply(k:Float):Vec2{
		x *= k;
		y *= k;
		return this;
	}
	
	public function equal(v:Vec2):Vec2{
		x = v.x;
		y = v.y;
		return this;
	}
	
	public function roundEqual(v:Vec2):Vec2{
		x = Math.round(v.x);
		y = Math.round(v.y);
		return this;
	}
	
	public function quadratic(){
		return x * x + y * y; 
	}
	
	
	//Вращение вектора относительно центра координат, или другой точки заданной вектором
	public function rotate(a:Float, v:Vec2 = null):Vec2{
		
		var cos:Float = Math.cos(a);
		var sin:Float = Math.sin(a);
		
		
		if (v != null){
			x-=v.x;
			y-=v.y;
		}
		
		var rx:Float = x*cos - y*sin;
		var ry:Float = x*sin + y*cos;
		
		if (v != null){
			rx+=v.x;
			ry+=v.y;
		}
		
		x = rx;
		y = ry;
		
		return this;
	}
	
	public function isEqual(v:Vec2):Bool{
		return x == v.x && y == v.y;
	}
	
	public function clone():Vec2{
		return new Vec2(x, y);
	}
	
	public function distanceTo(v:Vec2):Float{
		var nx:Float = x - v.x;
		var ny:Float = y - v.y;
		return Math.sqrt(nx * nx + ny * ny);
	}
	
	public function distanceToPoint(vx:Float, vy:Float):Float{
		var nx:Float = x - vx;
		var ny:Float = y - vy;
		return Math.sqrt(nx * nx + ny * ny);
	}
	
	
	public function angleBetween(v:Vec2):Float{
		
		var dotSin:Float = x * v.y - y * v.x;
		var dotCos:Float = x * v.x + y * v.y;
		
		var mod1:Float = quadratic();
		var mod2:Float = v.quadratic();
		
		if (mod1 * mod2 == 0) return 0;
		mod1 = Math.sqrt(mod1 * mod2);
		
		dotSin = dotSin / (mod1);
        dotCos = dotCos / (mod1);
		
		if (dotCos >= 0) return Math.asin(dotSin);
		
		return dotSin >= 0 ? Math.PI - Math.asin(dotSin) : -Math.PI - Math.asin(dotSin);
	}
	
	public function directionAngle():Float {
		return angleBetween(ZERO_DIR);
	}
	
	public function toBytes(output:BytesOutput):Void{
		output.writeFloat(x);
		output.writeFloat(y);
	}
	
	public function fromBytes(input:BytesInput):Void{
		x = input.readFloat();
		y = input.readFloat();
	}
	
}