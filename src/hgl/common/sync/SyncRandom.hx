package hgl.common.sync;

class SyncRandom extends SyncItem{

	public static inline var MAX_VALUE:Int = 0x7FFFFFFF;

	@:sync public var seed:Int = 0;

	@:sync public function setSeed(seed:Int):Void{
		trace(box.isMain, "setSeed", seed);
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