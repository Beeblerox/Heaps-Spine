package spine;

import spine.support.graphics.TextureLoader;
import spine.support.graphics.TextureAtlas;

class HeapsTextureLoader implements TextureLoader 
{
	private var _tile:h2d.Tile;

	private var _ids:Map<AtlasRegion, Int>;

	public function new(tile:h2d.Tile) {
		this._tile = tile;
	}

	public function loadPage(page:AtlasPage, path:String):Void {
		var tile:h2d.Tile = this._tile;
		if (tile == null)
			throw ("Image not found with name: " + path);
		_ids = new Map<AtlasRegion, Int>();
		page.rendererObject = tile;
		page.width = tile.width;
		page.height = tile.height;
	}

	public function loadRegion (region:AtlasRegion):Void 
    {
	}

	public function unloadPage (page:AtlasPage):Void 
    {
		page.rendererObject = null;
	}
}