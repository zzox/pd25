package game.scenes;

import core.ImageShader;
import core.Scene;
import core.Sprite;
import core.Timers;
import core.Types;
import kha.Assets;
import kha.Color;
import kha.Image;
import kha.Shaders;
import kha.graphics2.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureUnit;

class TestScene extends Scene {
    var image:Image;
    var mask:Image;
    var pipeline:PipelineState;
    var maskId:TextureUnit;

    override function create () {
        image = kha.Image.createRenderTarget(160, 90);

        final shader = new ImageShader(Shaders.painter_image_vert, Shaders.w_masks_frag);
        mask = kha.Image.createRenderTarget(160, 90);
        maskId = shader.pipeline.getTextureUnit('mask');
        // timeId = shader.pipeline.getConstantLocation('uTime');
        // mask = Assets.images.spotlight_32;

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

    override function render (g2:Graphics, g4:kha.graphics4.Graphics, clears:Bool) {
        // g4.begin();
        // g4.setTexture(maskId, mask);
        // g4.end();

        image.g2.begin(clears, camera.bgColor);
        // if (clears) {
        //     // WARN: is this extra call necessary?
        //     image.g2.clear(camera.bgColor);
        // }

        for (sprite in sprites) {
            sprite.render(image.g2, camera);
        }

#if debug_physics
        for (sprite in sprites) {
            sprite.renderDebug(image.g2, camera);
        }
#end

        image.g2.end();

        // make transparent
        mask.g2.begin(true, 0x00000000);
        for (sprite in sprites) {
            if (sprite.depth == 2) {
                // TODO: use render method
                mask.g2.drawImage(Assets.images.mask_8, sprite.x - 2, sprite.y - 2);
            }
        }
        mask.g2.end();

        g4.begin();
        g4.setTexture(maskId, mask);
        g4.end();

        g2.begin();
        // g4.setFloat(timeId, time);
        g2.pipeline = pipeline;
        g2.drawImage(image, 0, 0);
        // g2.drawImage(mask, 0, 0);

        g2.end();
    }

    function timerForRelease () {
        addSprite(new Flicker());
        timers.addTimer(new Timer(3.0, timerForRelease));
    }
}

class Flicker extends Sprite {
    public function new () {
        super(new Vec2(4, 4), Assets.images.flicker, new IntVec2(8, 8));

        animation.add('play', [0, 1], 0.25 + Math.random() * 0.75);
        animation.play('play');

        body.velocity.set(Math.random() < 0.5 ? 7.5 : 15, Math.random() < 0.5 ? 7.5 : 15);
        physicsEnabled = true;

        depth = 2;
    }
}
