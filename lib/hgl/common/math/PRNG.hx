package hgl.core.math;

/*

Pseudo random number generator
Based on Michael Baczynski, www.polygonal.de

@example

var prng:PRNG = new PRNG(15);
prng.nextFloat();
prng.nextInt();
prng.nextIntRange(1,6); 


@author rzer
@version 1.0

*/

class PRNG{

    public static inline var MAX_VALUE:Int = 0x7FFFFFFF;

    public var seed:Int = 1;

    public function new(seed:Int = 0) {

        if (seed == 0) seed = randomSeed();
        this.seed = seed;
	}

    public function nextInt():Int{
        return generate();
    }

    public function nextFloat():Float{
        return generate() / MAX_VALUE;
    }

    public function nextIntRange(min:Float, max:Float):Int{
        min -= .4999;
		max += .4999;
		return Math.round(min + ((max - min) * nextFloat()));
    }

    public function nextFloatRange(min:Float, max:Float):Float{
		return min + ((max - min) * nextFloat());
	}

    private function generate():Int{
        seed = next(seed);
        return seed;
    }

    public static function next(seed:Int):Int{
        return (seed * 16807) % MAX_VALUE;
    }

    public static function randomSeed():Int{
        var seed:Int = Math.floor(Math.random() * MAX_VALUE);
        if (seed == 0) return 1;
        return seed;
    }

}