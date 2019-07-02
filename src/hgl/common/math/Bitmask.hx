package hgl.core.math;

import haxe.io.Bytes;

/*

Read and write bits from haxe.io.Bytes

@author rzer
@version 1.0

*/
class Bitmask {

    public var bytes:Bytes;
    public var length:Int;
    public var offset:Int;

    public function new(bytes:Bytes = null, offset:Int = 0){
        if (bytes != null) loadBytes(bytes, offset);
    }

    public function loadBytes(bytes:Bytes, offset:Int = 0):Void{
        this.offset = offset;
        this.bytes = bytes;
        length = bytes.length;
    }

    public function get(index:Int):Bool{
        var bitIndex:Int = index % 8;
        var byte:Int = bytes.get(offset + Math.floor(index / 8));
        return ((byte >> bitIndex) & 1) == 1;
    }

    public function set(index:Int, value:Bool):Void{
        if (value) add(index);
        else clear(index);
    }

    public function add(index:Int):Void{
        var pos:Int = offset + Math.floor(index / 8);
        var byte:Int = bytes.get(pos);
        var bitIndex:Int = index % 8;
        byte = byte | 1 << bitIndex;
        bytes.set(pos, byte);
    }

    public function clear(index:Int):Void{
        var pos:Int = offset + Math.floor(index / 8);
        var byte:Int = bytes.get(pos);
        var bitIndex:Int = index % 8;
        byte = byte & ~(1 << bitIndex);
        bytes.set(pos, byte);
    }

    public function toggle(index:Int):Void{
        get(index) ? clear(index) : add(index);
    }
}