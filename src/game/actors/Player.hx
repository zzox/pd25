package game.actors;

import core.Camera;
import core.Sprite;
import core.Types;
import core.Util;
import game.objects.Mask;
import game.utils.InputRes;
import kha.Assets;
import kha.graphics2.Graphics;

enum MoveState {
    Running;
    Falling;
    Jumping;
}

// typedef Gun = {
//     var type:BulletType;
//     var reloadTime:Float;
//     var projAngles:Array<Float>;
//     var knockback:Float;
//     var velocity:Float;
// }

class Player extends MaskedSprite {
    static inline final AIRTIME_BUFFER:Float = 0.1;
    // static inline final SHOOT_BUFFER:Float = 0.05;
    static inline final JUMP_BUFFER_TIME:Float = 0.1;

    static inline final maxXVel:Int = 90;
    static inline final maxYVel:Int = 120;
    static inline final jumpVel:Int = 90;
    static inline final jumpHoldTime:Float = 0.2;

    var moveState:MoveState = Running;
    // var facingRight:Bool;
    var airTime:Float = 0.0;
    var jumpTime:Float = 0.0;
    var hangTime:Float = 0.0;

    // var shootTime:Float = 0.0;
    // var gun:Gun;

    var input:InputRes;

    // var gameScene:GameScene;
    // public function new (gameScene:GameScene, pos:Vec2) {
    public function new () {
        super(new Vec2(80, 0), Assets.images.guy, new IntVec2(16, 16));

        animation.add('idle', [0]);
        animation.add('run', [1, 1, 0, 2, 2], 0.06);
        animation.add('in-air', [1, 1, 2, 2, 2], 0.1);
        animation.play('idle');

        physicsEnabled = true;
        offset.set(6, 7);
        body.size.set(4, 8);
        body.maxVelocity.set(maxXVel, maxYVel);
        highXDrag();

        // gun = {
        //     type: Simple,
        //     reloadTime: 0.25,
        //     projAngles: [0],
        //     knockback: 0.0,
        //     velocity: 360.0
        // }

        input = new InputRes();
        // this.gameScene = gameScene;

        masks.push(new Mask(this, 0, 1.0));
        masks.push(new Mask(this, 1, 0.5));
    }

    override function update (delta:Float) {
        input.update(delta, scene.game.keys, scene.game.gamepads);

        handleMoveState(delta);
        // handleShoot(delta);

        handleMaxVel();
        handleAnimation();

        super.update(delta);
    }

    function handleMoveState (delta:Float) {
        var xAccel = accelFromInput();

        switch (moveState) {
            case Running:
                body.drag.set(600, 0);
                if (body.touching.down) {
                    airTime = 0;
                } else {
                    airTime += delta;
                    if (airTime > AIRTIME_BUFFER) {
                        fall();
                    }
                }

                if (input.jumpBuffer < JUMP_BUFFER_TIME) {
                    jump(false);
                }

                // REMOVE: ? quick turn around
                // if ((body.velocity.x < 0.0 && body.acceleration.x > 0.0)
                //     || (body.velocity.x > 0.0 && body.acceleration.x < 0.0)) {
                //     xAccel *= 3;
                // }
            case Falling:
                lowXDrag();
                xAccel /= 2.0;
                if (body.touching.down) {
                    land();
                }

                // // disallow letting go and re-pressing for hang
                // if (!input.jumpPressed) {
                //     canHang = false;
                // }

                // if (!body.touching.down && body.velocity.y > 0 && input.jumpPressed && canHang) {
                //     hang();
                // }
            case Jumping:
                body.velocity.y = -jumpVel;
                // body.velocity.y = isSuperJumping ? -SUPER_JUMP_VEL : -jumpVel;
                jumpTime += delta;
                if (body.touching.down || jumpTime > jumpHoldTime || !input.jumpPressed) {
                    fall();
                }
        }

        body.acceleration.set(xAccel * 1200, 0);

        // facingRight = scene.game.mouse.position.x > getMidpoint().x;
    }

    // function handleShoot (delta:Float) {
    //     shootTime -= delta;
    //     if (shootTime <= 0.0 && (input.shootPressed || input.shootBuffer < SHOOT_BUFFER)) {
    //         shoot();
    //     }
    // }

    // function shoot () {
    //     final xPos = x + (facingRight ? 16 : 0);
    //     final yPos = y + 9;

    //     final angle = angleFromPoints2(
    //         scene.game.mouse.position.x,
    //         scene.game.mouse.position.y,
    //         xPos,
    //         yPos,
    //     );

    //     final knockback = velocityFromAngle(angle + 180, gun.knockback);
    //     addVel(knockback.x, knockback.y);

    //     gameScene.generateBullet(
    //         this,
    //         gun,
    //         xPos,
    //         yPos,
    //         angle
    //     );

    //     shootTime = gun.reloadTime;
    // }

    // add velocity to current velocity.
    // for now, max velocity can only be set to maxvel + vel, otherwise we
    // keep adding to the velocity for infinity.
    // another option would be to increase maxvel lerp percent the further we get away from max vel
    function addVel (x:Float, y:Float) {
        body.velocity.x = clamp(body.velocity.x + x, -maxXVel - Math.abs(x), maxXVel + Math.abs(x));
        body.velocity.y = clamp(body.velocity.y + y, -maxYVel - Math.abs(y), maxYVel + Math.abs(y));

        if (Math.abs(body.velocity.x) > body.maxVelocity.x) body.maxVelocity.x = Math.abs(body.velocity.x);
        if (Math.abs(body.velocity.y) > body.maxVelocity.y) body.maxVelocity.y = Math.abs(body.velocity.y);
    }

    function jump (superJump:Bool) {
        jumpTime = 0.0;
        moveState = Jumping;
        // isSuperJumping = superJump;
        // canHang = true;

        // HACK: get us off the ground on the first frame and not fail
        // the body.touching.down check
        body.velocity.y = -jumpVel;
    }

    function fall () {
        moveState = Falling;
    }

    function land () {
        highXDrag();
        moveState = Running;
        // canHang = false;
    }

    function handleMaxVel () {
        body.maxVelocity.set(
            lerp(maxXVel, body.maxVelocity.x, 0.1),
            lerp(maxYVel, body.maxVelocity.y, 0.1)
        );
    }

    function accelFromInput ():Float {
        var vel = 0;

        if (input.leftPressed) {
            vel -= 1;
        }

        if (input.rightPressed) {
            vel += 1;
        }

        return vel;
    }

    function lowXDrag () body.drag.set(200, 0);
    function highXDrag () body.drag.set(600, 0);

    function handleAnimation () {
        if (body.velocity.y != 0) {
            animation.play('in-air');
        } else if (body.velocity.x == 0) {
            animation.play('idle');
        } else {
            animation.play('run');
        }

        // TEMP:
        if (body.acceleration.x > 0 && !flipX) {
            flipX = true;
        }

        if (body.acceleration.x < 0 && flipX) {
            flipX = false;
        }
    }

    // override function render (g2:Graphics, cam:Camera) {
    //     super.render(g2, cam);
    // }
}
