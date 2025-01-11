package game.objects;

import core.Sprite;
import core.Types;
import kha.Assets;

class Tile extends Sprite {
    public function new (x:Int, y:Int) {
        super(new Vec2(translateTileX(x), translateTileY(y)), Assets.images.tiles, new IntVec2(24, 12));
        tileIndex = x > 2 ? 1 : 0;
    }

    inline function translateTileX (pos:Int) return 8 + pos * 24;
    inline function translateTileY (pos:Int) return 12 + pos * 12;
}
