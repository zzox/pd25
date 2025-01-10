package game.objects;

import core.Sprite;
import core.Types;

enum abstract ColType(String) to String {
    var LeftRight = 'leftright';
    var Down = 'down';
    var All = 'all';
}

class CollisionItem extends Sprite {
    var material:String;

    public function new (x:Float, y:Float, width:Int, height:Int, material:String, type:ColType) {
        super(new Vec2(x, y));
        body.size.set(width, height);
        physicsEnabled = true;
        body.immovable = true;
        body.gravityFactor.set(0, 0);

        // body.collides.left = false;
        // body.collides.right = false;
        // body.collides.down = false;
        // if (type == LeftRight) {
        //     body.collides.down = false;
        //     body.collides.up = false;
        // } else if (type == Down) {
        //     body.collides.left = false;
        //     body.collides.right = false;
        //     body.collides.down = false;
        // }

        this.material = material;

        // makeRect(0xffff00ff, new IntVec2(width, height));
    }
}