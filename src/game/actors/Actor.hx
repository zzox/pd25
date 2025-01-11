package game.actors;

import core.Types;
import game.objects.Mask;
import kha.Assets;
import kha.input.KeyCode;

enum ActorState {
    Idle;
    Move;
}

class Actor extends MaskedSprite {
    static inline final TEMP_MOVE:Float = 0.2;

    var tileX:Int;
    var tileY:Int;
    var onLeft:Bool;

    var state:ActorState = Idle;
    var moving:Null<Dir>;
    var moveTime:Float = 0;

    public function new (onLeft:Bool) {
        tileX = onLeft ? 1 : 5;
        tileY = onLeft ? 1 : 3;

        super(new Vec2(-16, -16), Assets.images.player, new IntVec2(16, 16));
        flipX = !onLeft;
        this.onLeft = onLeft;
    }

    override function update (delta:Float) {
        super.update(delta);

        handleInput();

        switch (state) {
            case Idle:
                scale.set(1.0, 1.0);
                tileIndex = 0;
            case Move:
                moveTime += delta;
                tileIndex = 1;
                if (moveTime > TEMP_MOVE) {
                    move();
                }
        }

        setPosition(translateTileX(tileX), translateTileY(tileY));
    }

    function handleInput () {
        if (state == Idle) {
            if (scene.game.keys.justPressed(KeyCode.Left) && tileX > 0) {
                startMove(Left);
            } else if (scene.game.keys.justPressed(KeyCode.Right) && tileX < 5) {
                startMove(Right);
            } else if (scene.game.keys.justPressed(KeyCode.Up) && tileY > 0) {
                startMove(Up);
            } else if (scene.game.keys.justPressed(KeyCode.Down) && tileY > 0) {
                startMove(Down);
            }
        }
    }

    function startMove (dir:Dir) {
        moving = dir;
        moveTime = 0;
        state = Move;
    }

    function move () {
        if (moving == Left) tileX--;
        if (moving == Right) tileX++;
        if (moving == Up) tileY--;
        if (moving == Down) tileY++;

        moving = null;
        state = Idle;
    }

    inline function translateTileX (pos:Int) return 10 + pos * 24;
    inline function translateTileY (pos:Int) return 4 + pos * 12;
}
