package hgl.display.text;

import h3d.shader.Texture;
import hxsl.Shader;

/**
 * ...
 * @author rzer
 */
class MSDFShader extends Shader {
	
static var SRC = {
		
		@:import h3d.shader.Base2d;
		
		
		@param var fontColor : Vec4;
		@param var effectColor : Vec4;

		@param var blur: Float;
		@param var smoothing: Float;
		@param var outlineWidth: Float;
		@param var outerEdgeCenter:Float;

		function median(r : Float, g : Float, b : Float) : Float {
			return max(min(r, g), min(max(r, g), b));
		}
		
		//smoothstep
		function smoothstep(a:Float, b:Float, x:Float):Float{
			var t:Float = saturate((x - a)/(b - a));
			return t*t*(3.0 - (2.0*t));
		}

		function fragment() {
			
			var distance : Float = median(textureColor.r, textureColor.g, textureColor.b);
			
			var fontAlpha:Float = smoothstep(0.5 - smoothing, 0.5 + smoothing, distance);
			var borderAlpha:Float = smoothstep(outerEdgeCenter - blur, outerEdgeCenter + blur, distance);
			
			textureColor = vec4(mix(effectColor.rgb, fontColor.rgb, fontAlpha), borderAlpha);
		}
	}
	
	public function new() {
		super();
		
		effectColor.set(1, 0, 0, 0);
		fontColor.set(1, 1, 1, 1);
		
		smoothing = 1 / 16;
		blur = 8 / 16;
		
		outlineWidth = 5 / 16;
		outerEdgeCenter = 0.5 - outlineWidth;
	}

	

	
}