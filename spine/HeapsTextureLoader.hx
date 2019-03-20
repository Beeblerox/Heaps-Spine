package spine;

import spine.support.graphics.TextureLoader;
import spine.support.graphics.TextureAtlas;

class HeapsTextureLoader implements TextureLoader 
{
	private var _tile:h2d.Tile;

	public function new(?path:String, ?tile:h2d.Tile) 
    {
		if (path != null && tile == null)
            tile = hxd.Res.load(path).toImage().toTile();
        
        this._tile = tile;
	}

	public function loadPage(page:AtlasPage, path:String):Void {
		var tile:h2d.Tile = this._tile;
		if (tile == null)
			throw ("Image not found with name: " + path);

		page.rendererObject = tile;
		page.width = Std.int(tile.width);
		page.height = Std.int(tile.height);
	}

	public function loadRegion (region:AtlasRegion):Void 
    {
	}

	public function unloadPage (page:AtlasPage):Void 
    {
		page.rendererObject = null;
	}
}