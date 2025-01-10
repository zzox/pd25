package core;

import core.Tweens;
import kha.graphics2.Graphics;

// parent scene
class Scene {
    // store a reference to the parent game
    public var game:Game;

    // Main and only camera.
    public var camera:Camera;

    // Is this scene paused.
    public var isPaused:Bool = false;

    // this scene's sprites
    public var sprites:Array<Sprite> = [];

    // this scene's timers
    public var timers:Timers;

    // this scene's tweens
    public var tweens:Tweens;

    // Initialize objects belonging to the Scene.
    public function new () {
        timers = new Timers();
        tweens = new Tweens();
    }

    // True if the scene has been destroyed and is to be filtered out.
    public var _destroyed:Bool = false;

    // base create, called right before scene starts
    public function create () {}

    // update the state, pass in elapsed time.
    public function update (delta:Float) {
        timers.update(delta);
        tweens.update(delta);

        for (sprite in sprites) {
            if (sprite.active) {
                sprite.update(delta);
            }
        }

        // physics.update(delta); // not used
        camera.update(delta);

        // filter out destroyed sprites.
        sprites = sprites.filter((sprite) -> !sprite.destroyed);
    }

    // sends a number between 0 and 1 as a percentage of the assets being loaded.
    public function updateProgress (progress:Float) {}

    // called when drawing, passes in graphics instance
    // overriding render will require you to call begin, clear and end
    public function render (graphics:Graphics, g4:kha.graphics4.Graphics, clears:Bool) {
        graphics.begin(clears, camera.bgColor);
        // if (clears) {
        //     // WARN: is this extra call necessary?
        //     graphics.clear(camera.bgColor);
        // }

        for (sprite in sprites) {
            sprite.render(graphics, camera);
        }

#if debug_physics
        for (sprite in sprites) {
            sprite.renderDebug(graphics, camera);
        }
#end

        graphics.end();
    }

    // add a sprite to the scene
    public function addSprite (sprite:Sprite) {
        sprites.push(sprite);
        sprite.scene = this;
        // ATTN: only one layer, needs to be recursive if we want to be nested
        for (child in sprite._children) {
            child.scene = this;
        }
    }

    // remove a sprite from the scene
    public function removeSprite (sprite:Sprite) {
        sprites.remove(sprite);
    }

    // Destroy everything, called right before the scene switches.
    public function destroy () {
        _destroyed = true;
        timers.destroy();
        tweens.destroy();

        for (sprite in sprites) {
            sprite.destroy();
            sprite = null;
        }
    }
}
