package game.scenes;

import core.ImageShader;
import core.Scene;
import core.Sprite;
import core.Timers;
import core.Types;
import core.Util;
import kha.Assets;
import kha.Color;
import kha.Image;
import kha.Shaders;
import kha.graphics2.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureUnit;

class WorldScene extends Scene {
    var image:Image;
    var mask:Image;
    var pipeline:PipelineState;
    var maskId:TextureUnit;

    var maskedSprites:Array<MaskedSprite> = [];

    override function create () {
        image = kha.Image.createRenderTarget(160, 90);

        final shader = new ImageShader(Shaders.painter_image_vert, Shaders.pipeline_frag);
        mask = kha.Image.createRenderTarget(160, 90);
        maskId = shader.pipeline.getTextureUnit('mask');

        pipeline = shader.pipeline;

        final rect = new Sprite(new Vec2(10, 20));
        rect.makeRect(Color.Red, new IntVec2(30, 40));
        addSprite(rect);

        final text = new Sprite(new Vec2(50, 50));
        text.makeText('We made it!', Assets.fonts.nope_6p, 16);
        addSprite(text);

        camera.bgColor = 0xff3f3f74;

        timerForRelease();
    }

    override function update (delta:Float) {
        super.update(delta);
        for (s in maskedSprites) {
            for (m in s.masks) m.update(delta);
        }
    }

    function timerForRelease () {
        final flicker = new Flicker();
        addSprite(flicker);
        maskedSprites.push(flicker);
        timers.addTimer(new Timer(3.0, timerForRelease));
    }

    override function render (g2:Graphics, g4:kha.graphics4.Graphics, clears:Bool) {
        // draw to the scene's render target
        image.g2.begin(clears, camera.bgColor);
        for (sprite in sprites) {
            sprite.render(image.g2, camera);
        }

#if debug_physics
        for (sprite in sprites) {
            sprite.renderDebug(image.g2, camera);
        }
#end
        image.g2.end();

        // make transparent, draw masks to the mask target
        mask.g2.begin(true, 0x00000000);
        for (s in maskedSprites) {
            for (m in s.masks) m.render(mask.g2, camera);
        }
        mask.g2.end();

        // set the mask texture
        g4.begin();
        g4.setTexture(maskId, mask);
        g4.end();

        // draw the texture with the pipeline to be drawn to the render target
        // which will be scaled
        g2.begin();
        g2.pipeline = pipeline;
        g2.drawImage(image, 0, 0);
        // g2.drawImage(mask, 0, 0);
        g2.end();
    }
}

class MaskedSprite extends Sprite {
    public var masks:Array<Mask> = [];
}

class Flicker extends MaskedSprite {
    public function new () {
        super(new Vec2(4, 4), Assets.images.flicker, new IntVec2(16, 16));

        animation.add('play', [0, 1], 0.25 + Math.random() * 0.75);
        animation.play('play');

        body.velocity.set(Math.random() < 0.5 ? 7.5 : 15, Math.random() < 0.5 ? 7.5 : 15);
        body.drag.set(2.5, 2.5);
        physicsEnabled = true;

        depth = 2;

        masks.push(new Mask(this, 2, 0.5));
        masks.push(new Mask(this, 4, 1.0));
    }
}

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
            lerp(parent.x, x, 0.2 - ((8 - mSize) * 0.02)),
            lerp(parent.y, y, 0.2 - ((8 - mSize) * 0.02))
        );
    }
}
