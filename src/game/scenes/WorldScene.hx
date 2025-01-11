package game.scenes;

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

class WorldScene extends Scene {
    var image:Image;
    var mask:Image;
    var noise:Image;
    var maskId:TextureUnit;
    var noiseId:TextureUnit;
    var timeId:ConstantLocation;
    var pipeline:PipelineState;

    var time:Float = 0;
    var maskedSprites:Array<MaskedSprite> = [];
    var screenMask:Sprite;
    var noiseItems:Array<Sprite> = [];

    var collisionItems:Array<CollisionItem> = [];
    var player:Player;

    override function create () {
        // GFX stuff
        image = kha.Image.createRenderTarget(160, 90);
        final shader = new ImageShader(Shaders.pipeline_vert, Shaders.pipeline_frag);
        mask = kha.Image.createRenderTarget(160, 90);
        noise = kha.Image.createRenderTarget(160, 90);
        timeId = shader.pipeline.getConstantLocation('uTime');
        // WARN: 'noise' needs to be before 'mask' for some reason?
        noiseId = shader.pipeline.getTextureUnit('noise');
        maskId = shader.pipeline.getTextureUnit('mask');

        pipeline = shader.pipeline;

        // noise
        for (item in [new IntVec2(0, 0), new IntVec2(-256, 0), new IntVec2(0, -256), new IntVec2(-256, -256)]) {
            final noise = new Sprite(item.toVec2(), Assets.images.noise1);
            noise.alpha = 0.5;
            noiseItems.push(noise);
            // addSprite(noise);
        }

        // game sprites
        addSprite(new Sprite(new Vec2(0, 0), Assets.images.bg1));

        screenMask = new Sprite(new Vec2(0, 0));
        screenMask.makeRect(0xff000000, new IntVec2(game.size.x, game.size.y));
        screenMask.scrollFactor.set(0, 0);

        camera.bgColor = 0xff3f3f74;

        game.physics.gravity.y = 200;

        collisionItems.push(new CollisionItem(23, 86, 104, 3, 'tile', All));
        addSprite(player = new Player());
        maskedSprites.push(player);

        timerForRelease();
    }

    override function update (delta:Float) {
        time += delta;
        super.update(delta);
        for (s in maskedSprites) {
            for (m in s.masks) m.update(delta);
        }

        for (n in noiseItems) {
            n.x++;
            n.y++;

            if (n.x == 256) n.x -= 512;
            if (n.y == 256) n.y -= 512;
        }

        for (c in collisionItems) {
            game.physics.collide(player.body, c.body);
            // final did = game.physics.collide(player.body, c.body);
            // if (did) {
            //     trace(player.body.position.x, player.body.position.y,
            //         c.body.position.x, c.body.position.y);
            // }
        }

        if (game.keys.pressed(KeyCode.Up)) {
            screenMask.alpha = clamp(screenMask.alpha -= 0.03, 0.0, 1.0);
        }

        if (game.keys.pressed(KeyCode.Down)) {
            screenMask.alpha = clamp(screenMask.alpha += 0.03, 0.0, 1.0);
        }

        if (game.keys.justPressed(KeyCode.R)) {
            game.switchScene(new WorldScene());
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

        if (screenMask.alpha > 0) {
            screenMask.render(mask.g2, camera);
        }
        mask.g2.end();

        // draw noise items to the noise target
        noise.g2.begin();
        for (n in noiseItems) {
            n.render(noise.g2, camera);
        }
        noise.g2.end();

        // set the mask texture
        g4.begin();
        g4.setPipeline(pipeline);
        g4.setTexture(maskId, mask);
        g4.setTexture(noiseId, noise);
        g4.setFloat(timeId, time);
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

class Flicker extends MaskedSprite {
    public function new () {
        super(new Vec2(4, 4), Assets.images.flicker, new IntVec2(16, 16));

        animation.add('play', [0, 1], 0.25 + Math.random() * 0.75);
        animation.play('play');

        body.velocity.set(Math.random() < 0.5 ? 7.5 : 15, Math.random() < 0.5 ? 7.5 : 15);
        body.drag.set(2.5, 2.5);
        physicsEnabled = true;

        depth = 2;

        masks.push(new Mask(this, 0, 0.5));
        masks.push(new Mask(this, 2, 1.0));
    }
}
