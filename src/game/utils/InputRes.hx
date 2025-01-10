package game.utils;

import core.Input.GamepadButton;
import core.Input.Gamepads;
import core.Input.KeysInput;
import kha.input.Gamepad;
import kha.input.KeyCode;

// TODO: revisit?
final jumpKeys = [KeyCode.Space, KeyCode.Z];
final skateJumpKeys = [KeyCode.Space, KeyCode.Z];
final selectKeys = [KeyCode.Space, KeyCode.Z, KeyCode.Return];
final actionKeys = [KeyCode.Tab, KeyCode.X];

final leftKeys = [KeyCode.Left, KeyCode.A];
final rightKeys = [KeyCode.Right, KeyCode.D];
final upKeys = [KeyCode.Up, KeyCode.W];
final downKeys = [KeyCode.Down, KeyCode.S];
final startKeys = [KeyCode.P];

final leftPads = [GamepadButton.PadLeft, GamepadButton.LeftStickLeft];
final rightPads = [GamepadButton.PadRight, GamepadButton.LeftStickRight];
final upPads = [GamepadButton.PadUp, GamepadButton.LeftStickUp];
final downPads = [GamepadButton.PadDown, GamepadButton.LeftStickDown];

final selectPads = [GamepadButton.ButtonBottom, GamepadButton.ButtonLeft];

// final leftDrumPads = [GamepadButton.PadLeft, GamepadButton.LeftStickLeft, GamepadButton.ButtonLeft];
// final rightDrumPads = [GamepadButton.PadRight, GamepadButton.LeftStickRight, GamepadButton.ButtonRight];
// final upDrumPads = [GamepadButton.PadUp, GamepadButton.LeftStickUp, GamepadButton.ButtonTop];
// final downDrumPads = [GamepadButton.PadDown, GamepadButton.LeftStickDown, GamepadButton.ButtonBottom];

// final leftDrumKeys = [KeyCode.Left, KeyCode.A, KeyCode.C];
// final rightDrumKeys = [KeyCode.Right, KeyCode.D, KeyCode.N];
// final upDrumKeys = [KeyCode.Up, KeyCode.W, KeyCode.B];
// final downDrumKeys = [KeyCode.Down, KeyCode.S, KeyCode.V];

class InputRes {
    public var jumpJustPressed:Bool = false;
    // public var skateJumpJustPressed:Bool = false;
    public var actionJustPressed:Bool = false;
    public var upJustPressed:Bool = false;
    public var downJustPressed:Bool = false;
    public var startJustPressed:Bool = false;
    public var jumpPressed:Bool = false;
    // public var skateJumpPressed:Bool = false;
    public var actionPressed:Bool = false;
    public var jumpJustReleased:Bool = false;
    public var actionJustReleased:Bool = false;

    public var selectJustPressed:Bool = false;
    public var escapeJustPressed:Bool = false;

    public var upPressed:Bool = false;
    public var downPressed:Bool = false;
    public var leftPressed:Bool = false;
    public var rightPressed:Bool = false;

    public var jumpBuffer:Float = 0.0;
    public var skateJumpBuffer:Float = 0.0;
    public var actionBuffer:Float = 0.0;
    public var upBuffer:Float = 0.0;
    public var downBuffer:Float = 0.0;

    // public var leftDrumsJustPressed:Bool = false;
    // public var rightDrumsJustPressed:Bool = false;
    // public var upDrumsJustPressed:Bool = false;
    // public var downDrumsJustPressed:Bool = false;

    // public var leftDrumsJustReleased:Bool = false;
    // public var rightDrumsJustReleased:Bool = false;
    // public var upDrumsJustReleased:Bool = false;
    // public var downDrumsJustReleased:Bool = false;

    public var confirmJustPressed:Bool = false;

    public function new () {}

    public function update (delta:Float, keys:KeysInput, pads:Gamepads) {
        jumpPressed = keys.anyPressed(jumpKeys) || pads.checkAllPressed(GamepadButton.ButtonBottom);
        // skateJumpPressed = keys.anyPressed(jumpKeys) || pads.checkAllAnyPressed();
        actionPressed = keys.anyPressed(actionKeys) || pads.checkAllPressed(GamepadButton.ButtonLeft);
        leftPressed = keys.anyPressed(leftKeys) || pads.checkAllAnyPressed(leftPads);
        rightPressed = keys.anyPressed(rightKeys) || pads.checkAllAnyPressed(rightPads);
        upPressed = keys.anyPressed(upKeys) || pads.checkAllAnyPressed(upPads);
        downPressed = keys.anyPressed(downKeys) || pads.checkAllAnyPressed(downPads);
        // final leftJustPressed = keys.anyJustPressed([KeyCode.Left, KeyCode.A]);
        // final rightJustPressed = keys.anyJustPressed([KeyCode.Right, KeyCode.D]);
        upJustPressed = keys.anyJustPressed(upKeys) || pads.checkAllAnyJustPressed(upPads);
        downJustPressed = keys.anyJustPressed(downKeys) || pads.checkAllAnyJustPressed(downPads);

        startJustPressed = keys.anyJustPressed(startKeys) || pads.checkAllJustPressed(GamepadButton.Start);
        selectJustPressed = keys.anyJustPressed(selectKeys) || pads.checkAllAnyJustPressed(selectPads);
        escapeJustPressed = keys.justPressed(KeyCode.Escape);

        jumpBuffer += delta;
        actionBuffer += delta;
        skateJumpBuffer += delta;
        upBuffer += delta;
        downBuffer += delta;

        if (keys.anyJustPressed(jumpKeys) || pads.checkAllJustPressed(GamepadButton.ButtonBottom)) {
            jumpJustPressed = true;
            jumpBuffer = 0.0;
        } else {
            jumpJustPressed = false;
        }
        jumpJustReleased = keys.anyJustReleased(jumpKeys) || pads.checkAllJustReleased(GamepadButton.ButtonBottom);

        if (keys.anyJustPressed(skateJumpKeys) || pads.checkAllJustPressed(GamepadButton.ButtonBottom)) {
            // skateJumpJustPressed = true;
            skateJumpBuffer = 0.0;
        } else {
            // skateJumpJustPressed = false;
        }

        if (upJustPressed) {
            upBuffer = 0.0;
        }

        if (downJustPressed) {
            downBuffer = 0.0;
        }

        if (keys.anyJustPressed(actionKeys) || pads.checkAllJustPressed(GamepadButton.ButtonLeft)) {
            actionJustPressed = true;
            actionBuffer = 0.0;
        } else {
            actionJustPressed = false;
        }
        actionJustReleased = keys.anyJustReleased(actionKeys) || pads.checkAllJustReleased(GamepadButton.ButtonLeft);

        // leftDrumsJustPressed = keys.anyJustPressed(leftDrumKeys) || pads.checkAllAnyJustPressed(leftDrumPads);
        // rightDrumsJustPressed = keys.anyJustPressed(rightDrumKeys) || pads.checkAllAnyJustPressed(rightDrumPads);
        // upDrumsJustPressed = keys.anyJustPressed(upDrumKeys) || pads.checkAllAnyJustPressed(upDrumPads);
        // downDrumsJustPressed = keys.anyJustPressed(downDrumKeys) || pads.checkAllAnyJustPressed(downDrumPads);

        // leftDrumsJustReleased = keys.anyJustReleased(leftDrumKeys) || pads.checkAllAnyJustReleased(leftDrumPads);
        // rightDrumsJustReleased = keys.anyJustReleased(rightDrumKeys) || pads.checkAllAnyJustReleased(rightDrumPads);
        // upDrumsJustReleased = keys.anyJustReleased(upDrumKeys) || pads.checkAllAnyJustReleased(upDrumPads);
        // downDrumsJustReleased = keys.anyJustReleased(downDrumKeys) || pads.checkAllAnyJustReleased(downDrumPads);

        confirmJustPressed = actionJustPressed || jumpJustPressed || selectJustPressed;
    }
}
