import spine.support.graphics.TextureAtlas;
import spine.SkeletonData;
import spine.SkeletonJson;
import spine.attachments.AtlasAttachmentLoader;

class Game extends hxd.App
{
    static function main()
    {
        hxd.Res.initEmbed();
        
        new Game();
    }

    var b:h2d.Bitmap;

    var skeleton:spine.SpinePlayer;

    override function init() 
    {
        var tile = hxd.Res.load("spineboy-pro.png").toImage().toTile();
        var loader:spine.HeapsTextureLoader = new spine.HeapsTextureLoader(tile);
        
        var atlasData = hxd.Res.load("spineboy-pro.atlas").toText();
        var atlas:TextureAtlas = new TextureAtlas(atlasData, loader);

        var json:SkeletonJson = new SkeletonJson(new AtlasAttachmentLoader(atlas));
        json.setScale(0.6);

        var sData = hxd.Res.load("spineboypro.json").toText();
        var skeletonData:SkeletonData = json.readSkeletonData(new spine.HeapsSkeletonFileHandle("spineboypro.json", sData));

        skeleton = new spine.SpinePlayer(skeletonData, s2d);
        skeleton.x = 300;
        skeleton.y = 500;

        var atlas:hxd.res.Atlas = hxd.Res.load("spineboy-pro.atlas").to(hxd.res.Atlas);
        var tile = atlas.get("crosshair");
        
        b = new h2d.Bitmap(tile, s2d);
        b.tile = b.tile.center();
    }

    override function update(dt:Float) 
    {
        b.x = s2d.mouseX;
        b.y = s2d.mouseY;

        skeleton.advanceTime(1 / 60);
    }
}