package game.objects;

import core.Sprite;
import core.Types;
import kha.Assets;

enum WeaponState {
    WNone;
    WPreStrike;
    WStrike;
    WPostStrike;
}

typedef WeaponData = {
    var preStrikeTime:Float;
    var strikeTime:Float;
    var preRect:IntRect;
    var strikeRect:IntRect;
    var postRect:IntRect;
}

final weaponData:WeaponData = {
    preStrikeTime: 0.2,
    strikeTime: 0.1,
    preRect: { x: 5, y: 1, height: 15, width: 5 },
    strikeRect: { x: 5, y: 1, height: 15, width: 5 },
    postRect: { x: 5, y: 1, height: 15, width: 5 },
}

class Weapon extends Sprite {
    public var state:WeaponState = WNone;
    var parent:Sprite;

    public function new (parent:Sprite) {
        super(new Vec2(-16, -16), Assets.images.weapons, new IntVec2(16, 16));
        this.parent = parent;
        physicsEnabled = true;
        body.gravityFactor.set(0, 0);
    }

    override function update (delta:Float) {
        switch (state) {
            case WNone:
                body.position.set(-16, -16);
            case WPreStrike:
                body.position.set(parent.body.position.x, parent.body.position.y - weaponData.preRect.height);
                body.size.set(weaponData.preRect.width, weaponData.preRect.height);
                offset.set(weaponData.preRect.x, weaponData.preRect.y);
                tileIndex = 0;
            case WStrike:
                // if (parent.flipX) {
                body.position.set(parent.body.position.x, parent.body.position.y - weaponData.preRect.height);
                body.size.set(weaponData.preRect.width, weaponData.preRect.height);
                offset.set(weaponData.preRect.x, weaponData.preRect.y);
                tileIndex = 1;
                // }
            case WPostStrike:
                body.position.set(parent.body.position.x, parent.body.position.y - weaponData.preRect.height);
                body.size.set(weaponData.preRect.width, weaponData.preRect.height);
                offset.set(weaponData.preRect.x, weaponData.preRect.y);
                tileIndex = 2;
        }

        super.update(delta);
    }
}
