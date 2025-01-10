package game.objects;

import core.ImageShader;
import core.Scene;
import core.Sprite;
import core.Timers;
import core.Types;
import core.Util;
import game.actors.Player;
import game.objects.CollisionItem;
import game.objects.Mask;
import kha.Assets;
import kha.Color;
import kha.Image;
import kha.Shaders;
import kha.graphics2.Graphics;
import kha.graphics4.ConstantLocation;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureUnit;
import kha.input.KeyCode;

class Mask extends Sprite {
    var mSize:Int;
    var parent:MaskedSprite;
    public function new (parent:MaskedSprite, size:Int, alpha:Float) {
        super(new Vec2(parent.x, parent.y), Assets.images.masks, new IntVec2(16, 16));
        tileIndex = size;
        this.alpha = alpha;
        this.mSize = size;
        this.parent = parent;
    }

    override function update (delta:Float) {
        super.update(delta);
        setPosition(
            lerp(parent.x, x, 0.5 - ((8 - mSize) * 0.04)),
            lerp(parent.y, y, 0.5 - ((8 - mSize) * 0.04))
        );
    }
}

class MaskedSprite extends Sprite {
    public var masks:Array<Mask> = [];
}
