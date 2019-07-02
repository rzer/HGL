package hgl.common.math;

/*

Easing functions
Taked from shohei909/TweenXCore

@author rzer
@version 1.0

*/

using hgl.common.math.Easing;

class Easing {

    static inline var PI       = 3.1415926535897932384626433832795;
    static inline var PI_H     = PI / 2;
    static inline var LN_2     = 0.6931471805599453;
    static inline var LN_2_10  = 6.931471805599453;
    
    //LINEAR

    public static inline function linear(t:Float):Float{
        return t;
    }

    //SINE

    public static inline function sineIn(t:Float):Float {
        return if (t == 0) {
            0;
        } else if (t == 1) {
            1;
        } else {
            1 - Math.cos(t * PI_H);
        }
    }

    public static inline function sineOut(t:Float):Float {
        return if (t == 0) {
            0;
        } else if (t == 1) {
            1;
        } else {
            Math.sin(t * PI_H);
        }
    }

    public static inline function sineInOut(t:Float):Float {
        return if (t == 0) {
            0;
        } else if (t == 1) {
            1;
        } else {
            -0.5 * (Math.cos(PI * t) - 1);
        }
    }

    public static inline function sineOutIn(t:Float):Float {
        return  if (t == 0) {
            0;
        } else if (t == 1) {
            1;
        } else if (t < 0.5) {
            0.5 * Math.sin((t * 2) * PI_H);
        } else {
            -0.5 * Math.cos((t * 2 - 1) * PI_H) + 1;
        }
    }


    //QUAD EASING 2-order

    public static inline function quadIn(t:Float):Float {
        return t * t;
    }

    public static inline function quadOut(t:Float):Float {
        return -t * (t - 2);
    }

    public static inline function quadInOut(t:Float):Float {
        return (t < 0.5) ? 2 * t * t : -2 * ((t -= 1) * t) + 1;
    }

    public static inline function quadOutIn(t:Float):Float {
        return (t < 0.5) ? -0.5 * (t = (t * 2)) * (t - 2) : 0.5 * (t = (t * 2 - 1)) * t + 0.5;
    }


    //CUBIC EASING 3-order

    public static inline function cubicIn(t:Float):Float {
        return t * t * t;
    }

    public static inline function cubicOut(t:Float):Float {
        return (t = t - 1) * t * t + 1;
    }

    public static inline function cubicInOut(t:Float):Float {
        return ((t *= 2) < 1) ?
            0.5 * t * t * t :
            0.5 * ((t -= 2) * t * t + 2);
    }

    public static inline function cubicOutIn(t:Float):Float {
        return 0.5 * ((t = t * 2 - 1) * t * t + 1);
    }


    //QUART EASING 4-order

    public static inline function quartIn(t:Float):Float {
        return (t *= t) * t;
    }
    
    public static inline function quartOut(t:Float):Float {
        return 1 - (t = (t = t - 1) * t) * t;
    }
    
    public static inline function quartInOut(t:Float):Float {
        return ((t *= 2) < 1) ? 0.5 * (t *= t) * t : -0.5 * ((t = (t -= 2) * t) * t - 2);
    }
    
    public static inline function quartOutIn(t:Float):Float {
        return (t < 0.5) ? -0.5 * (t = (t = t * 2 - 1) * t) * t + 0.5 : 0.5 * (t = (t = t * 2 - 1) * t) * t + 0.5;
    }


    //QUINT EASING 5-order

    public static inline function quintIn(t:Float):Float {
        return t * (t *= t) * t;
    }

    public static inline function quintOut(t:Float):Float {
        return (t = t - 1) * (t *= t) * t + 1;
    }
 
    public static inline function quintInOut(t:Float):Float {
        return ((t *= 2) < 1) ? 0.5 * t * (t *= t) * t : 0.5 * (t -= 2) * (t *= t) * t + 1;
    }

    public static inline function quintOutIn(t:Float):Float {
        return 0.5 * ((t = t * 2 - 1) * (t *= t) * t + 1);
    }


    //EXPO EASING

    public static inline function expoIn(t:Float):Float {
        return t == 0 ? 0 : Math.exp(LN_2_10 * (t - 1));
    }

    public static inline function expoOut(t:Float):Float {
        return t == 1 ? 1 : (1 - Math.exp(-LN_2_10 * t));
    }

    public static inline function expoInOut(t:Float):Float {
        return if (t == 0) {
            0;
        } else if (t == 1) {
            1;
        } else if ((t *= 2) < 1) {
            0.5 * Math.exp(LN_2_10 * (t - 1));
        } else {
            0.5 * (2 - Math.exp(-LN_2_10 * (t - 1)));
        }
    }

    public static inline function expoOutIn(t:Float):Float {
        return if (t < 0.5) {
            0.5 * (1 - Math.exp(-20 * LN_2 * t));
        } else if (t == 0.5) {
            0.5;
        } else {
            0.5 * (Math.exp(20 * LN_2 * (t - 1)) + 1);
        }
    }

    
    //CIRC EASING

    public static inline function circIn(t:Float):Float {
        return if (t < -1 || 1 < t) 0 else 1 - Math.sqrt(1 - t * t);
    }
    public static inline function circOut(t:Float):Float {
        return if (t < 0 || 2 < t) 0 else Math.sqrt(t * (2 - t));
    }
    public static inline function circInOut(t:Float):Float {
        return if (t < -0.5 || 1.5 < t) 0.5 else if ((t *= 2) < 1)- 0.5 * (Math.sqrt(1 - t * t) - 1) else 0.5 * (Math.sqrt(1 - (t -= 2) * t) + 1);
    }
    public static inline function circOutIn(t:Float):Float {
        return if (t < 0) 0 else if (1 < t) 1 else if (t < 0.5) 0.5 * Math.sqrt(1 - (t = t * 2 - 1) * t) else -0.5 * ((Math.sqrt(1 - (t = t * 2 - 1) * t) - 1) - 1);
    }


    //BOUNCE EASING

    public static inline function bounceIn(t:Float):Float {
        return if ((t = 1 - t) < (1 / 2.75)) {
            1 - ((7.5625 * t * t));
        } else if (t < (2 / 2.75)) {
            1 - ((7.5625 * (t -= (1.5 / 2.75)) * t + 0.75));
        } else if (t < (2.5 / 2.75)) {
            1 - ((7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375));
        } else {
            1 - ((7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375));
        }
    }

    public static inline function bounceOut(t:Float):Float {
        return if (t < (1 / 2.75)) {
            (7.5625 * t * t);
        } else if (t < (2 / 2.75)) {
            (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75);
        } else if (t < (2.5 / 2.75)) {
            (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375);
        } else {
            (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375);
        }
    }

    public static inline function bounceInOut(t:Float):Float {
        return if (t < 0.5) {
            if ((t = (1 - t * 2)) < (1 / 2.75)) {
                (1 - ((7.5625 * t * t))) * 0.5;
            } else if (t < (2 / 2.75)) {
                (1 - ((7.5625 * (t -= (1.5 / 2.75)) * t + 0.75))) * 0.5;
            } else if (t < (2.5 / 2.75)) {
                (1 - ((7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375))) * 0.5;
            } else {
                (1 - ((7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375))) * 0.5;
            }
        } else {
            if ((t = (t * 2 - 1)) < (1 / 2.75)) {
                ((7.5625 * t * t)) * 0.5 + 0.5;
            } else if (t < (2 / 2.75))    {
                ((7.5625 * (t -= (1.5 / 2.75)) * t + 0.75)) * 0.5 + 0.5;
            } else if (t < (2.5 / 2.75))    {
                ((7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375)) * 0.5 + 0.5;
            } else {
                ((7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375)) * 0.5 + 0.5;
            }
        }
    }

    public static inline function bounceOutIn(t:Float):Float {
        return if (t < 0.5) {
            if ((t = (t * 2)) < (1 / 2.75)) {
                0.5 * (7.5625 * t * t);
            } else if (t < (2 / 2.75)) {
                0.5 * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75);
            } else if (t < (2.5 / 2.75)) {
                0.5 * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375);
            } else {
                0.5 * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375);
            }
        } else {
            if ((t = (1 - (t * 2 - 1))) < (1 / 2.75)) {
                0.5 - (0.5 * (7.5625 * t * t)) + 0.5;
            } else if (t < (2 / 2.75)) {
                0.5 - (0.5 * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75)) + 0.5;
            } else if (t < (2.5 / 2.75)) {
                0.5 - (0.5 * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375)) + 0.5;
            } else {
                0.5 - (0.5 * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375)) + 0.5;
            }
        }
    }

    private static inline var overshoot:Float = 1.70158;

    //BACK EASING

    public static inline function backIn(t:Float):Float {
        return if (t == 0) {
            0;
        } else if (t == 1) {
            1;
        } else {
            t * t * ((overshoot + 1) * t - overshoot);
        }
    }

    public static inline function backOut(t:Float):Float {
        return if (t == 0) {
            0;
        } else if (t == 1) {
            1;
        } else {
            ((t = t - 1) * t * ((overshoot + 1) * t + overshoot) + 1);
        }
    }

    public static inline function backInOut(t:Float):Float {
        return if (t == 0) {
            0;
        } else if (t == 1) {
            1;
        } else if ((t *= 2) < 1) {
            0.5 * (t * t * (((overshoot * 1.525) + 1) * t - overshoot * 1.525));
        } else {
            0.5 * ((t -= 2) * t * (((overshoot * 1.525) + 1) * t + overshoot * 1.525) + 2);
        }
    }

    public static inline function backOutIn(t:Float):Float {
        return if (t == 0) {
            0;
        } else if (t == 1) {
            1;
        } else if (t < 0.5) {
            0.5 * ((t = t * 2 - 1) * t * ((overshoot + 1) * t + overshoot) + 1);
        } else {
            0.5 * (t = t * 2 - 1) * t * ((overshoot + 1) * t - overshoot) + 0.5;
        }
    }


    //ELASTIC EASING 

    static inline var amplitude:Float = 1;
    static inline var period:Float = 0.0003;

    public static inline function elasticIn(t:Float):Float {
        return if (t == 0) {
            0;
        } else if (t == 1) {
            1;
        } else {
            var s:Float = period / 4;
            -(amplitude * Math.exp(LN_2_10 * (t -= 1)) * Math.sin((t * 0.001 - s) * (2 * PI) / period));
        }
    }

    public static inline function elasticOut(t:Float):Float {
        return if (t == 0) {
            0;
        } else if (t == 1) {
            1;
        } else {
            var s:Float = period / 4;
            Math.exp(-LN_2_10 * t) * Math.sin((t * 0.001 - s) * (2 * PI) / period) + 1;
        }
    }

    public static inline function elasticInOut(t:Float):Float {
        return if (t == 0) {
            0;
        } else if (t == 1) {
            1;
        } else {
            var s:Float = period / 4;

            if ((t *= 2) < 1) {
                -0.5 * (amplitude * Math.exp(LN_2_10 * (t -= 1)) * Math.sin((t * 0.001 - s) * (2 * PI) / period));
            } else {
                amplitude * Math.exp(-LN_2_10 * (t -= 1)) * Math.sin((t * 0.001 - s) * (2 * PI) / period) * 0.5 + 1;
            }
        }
    }

    public static inline function elasticOutIn(t:Float):Float {
        return if (t < 0.5) {
            if ((t *= 2) == 0) {
                0;
            } else {
                var s = period / 4;
                (amplitude / 2) * Math.exp(-LN_2_10 * t) * Math.sin((t * 0.001 - s) * (2 * PI) / period) + 0.5;
            }
        } else {
            if (t == 0.5) {
                0.5;
            } else if (t == 1) {
                1;
            } else {
                t = t * 2 - 1;
                var s = period / 4;
                -((amplitude / 2) * Math.exp(LN_2_10 * (t -= 1)) * Math.sin((t * 0.001 - s) * (2 * PI) / period)) + 0.5;
            }
        }
    }

    //WARP EASING

    public static inline function warpOut(t:Float):Float {
        return t <= 0 ? 0 : 1;
    }
    
    public static inline function warpIn(t:Float):Float {
        return t < 1 ? 0 : 1;
    }

    public static inline function warpInOut(t:Float):Float {
        return t < 0.5 ? 0 : 1;
    }

    public static inline function warpOutIn(t:Float):Float {
        return if (t <= 0) 0 else if (t < 1) 0.5 else 1;
    }
	
	//EASING TOOLS
	
	//Same as `1 - rate`
    public static inline function revert(rate:Float):Float {
        return 1 - rate;
    }

    //Clamps a `value` between `min` and `max`.
    public static inline function clamp(value:Float, min:Float = 0.0, max:Float = 1.0):Float {
        return if (value <= min) min else if (max <= value) max else value;
    }

    //Linear interpolation between `from` and `to` by `rate`
    public static inline function lerp(rate:Float, from:Float, to:Float):Float {
        return from * (1 - rate) + to * rate;
    }

    //Normalizes a `value` within the range between `from` and `to` into a value between 0 and 1
    public static inline function inverseLerp(value:Float, from:Float, to:Float):Float {
        return (value - from) / (to - from);
    }

    public static inline function repeat(value:Float, from:Float = 0.0, to:Float = 1.0):Float {
        var p = inverseLerp(value, from, to);
        return p - Math.floor(p);
    }
    
    public static inline function shake(rate:Float, center:Float = 0.0, ?randomFunc:Void->Float):Float {
        if (randomFunc == null) randomFunc = Math.random;
        return center + spread(randomFunc(), rate);
    }

    //Same as `FloatTools.lerp(rate, -scale, scale)` */
    public static inline function spread(rate:Float, scale:Float):Float {
        return lerp(rate, -scale, scale);
    }

    public static inline function sinByRate(rate:Float) {
        return Math.sin(rate * 2 * Math.PI);
    }

    public static inline function cosByRate(rate:Float) {
        return Math.cos(rate * 2 * Math.PI);
    }


    // =================================================
    // Round Trip
    // =================================================

    //Round trip motion that goes from 0.0 to 1.0 and returns to 0.0 in the reverse playback movement. 
    public static inline function yoyo(rate:Float, easing:Float->Float):Float {
        return easing((if (rate < 0.5) rate else (1 - rate)) * 2);
    }
    //Round trip motion that goes from 0.0 to 1.0 and returns to 0.0 with the movement in which the moving direction is reversed.
    public static inline function zigzag(rate:Float, easing:Float->Float):Float {
        return if (rate < 0.5) easing(rate * 2) else 1 - easing((rate - 0.5) * 2);
    }


    // =================================================
    // Complex Easing
    // =================================================

    //Intermediate easing between the two easings
    public static inline function mixEasing(
        rate:Float,
        easing1:Float->Float,
        easing2:Float->Float,
        easing2Strength:Float = 0.5):Float
    {
        return easing2Strength.lerp(
            easing1(rate),
            easing2(rate)
        );
    }

    //Gradually changes to another easing at the beginning and at the end
    public static inline function crossfadeEasing(
        rate:Float,
        easing1:Float->Float,
        easing2:Float->Float,
        easing2StrengthEasing:Float->Float,
        easing2StrengthStart:Float = 0,
        easing2StrengthEnd:Float = 1):Float
    {
        return easing2StrengthEasing(rate).lerp(
            easing2StrengthStart,
            easing2StrengthEnd
        ).lerp(
            easing1(rate),
            easing2(rate)
        );
    }

    public static inline function connectEasing(
        time:Float,
        easing1:Float->Float,
        easing2:Float->Float,
        switchTime:Float = 0.5,
        switchValue:Float = 0.5
        ):Float
    {
        return if (time < switchTime) {
            easing1(time.inverseLerp(0, switchTime)).lerp(0, switchValue);
        } else {
            easing2(time.inverseLerp(switchTime, 1)).lerp(switchValue, 1);
        }
    }

    public static inline function oneTwoEasing(
        time:Float,
        easingOne:Float->Float,
        easingTwo:Float->Float,
        switchTime:Float = 0.5):Float
    {
        return if (time < switchTime) {
            easingOne(time.inverseLerp(0, switchTime));
        } else {
            easingTwo(time.inverseLerp(switchTime, 1));
        }
    }


    // =================================================
    // Bernstein Polynomial
    // =================================================

    //Quadratic Bernstein polynomial
    public static inline function bezier2(rate:Float, from:Float, control:Float, to:Float):Float {
        return lerp(rate, lerp(rate, from, control), lerp(rate, control, to));
    }

    //Cubic Bernstein polynomial
    public static inline function bezier3(rate:Float, from:Float, control1:Float, control2:Float, to:Float):Float {
        return bezier2(rate, lerp(rate, from, control1), lerp(rate, control1, control2), lerp(rate, control2, to));
    }

    //Bernstein polynomial, which is the mathematical basis for Bézier curve
    public static inline function bezier(rate:Float, values:Array<Float>):Float {
        return if (values.length < 2) {
            throw "points length must be more than 2";
        } else if (values.length == 2) {
            lerp(rate, values[0], values[1]);
        } else if (values.length == 3) {
            bezier2(rate, values[0], values[1], values[2]);
        } else {
            _bezier(rate, values);
        }
    }

    static function _bezier(rate:Float, values:Array<Float>):Float {
        if (values.length == 4) {
            return bezier3(rate, values[0], values[1], values[2], values[3]);
        }

        return _bezier(rate, [for (i in 0...values.length - 1) lerp(rate, values[i], values[i + 1])]);
    }

    //Uniform Quadratic B-spline
    public static inline function uniformQuadraticBSpline(rate:Float, values:Array<Float>):Float {
        return if (values.length < 2) {
            throw "points length must be more than 2";
        } else if (values.length == 2) {
            lerp(rate, values[0], values[1]);
        } else {
            var max = values.length - 2;
            var scaledRate = rate * max;
            var index = Math.floor(clamp(scaledRate, 0, max - 1)); 
            var innerRate = scaledRate - index;
            var p0 = values[index];
            var p1 = values[index + 1];
            var p2 = values[index + 2];
            innerRate * innerRate * (p0 / 2 - p1 + p2 / 2) + innerRate * (-p0 + p1) + p0 / 2 + p1 / 2;
        }
    }
}