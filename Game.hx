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

    var skeletons:Array<spine.SpineAnimation>;

    override function init() 
    {
        var loader:spine.HeapsTextureLoader = new spine.HeapsTextureLoader("spineboy-pro.png");
        
        var atlasData = hxd.Res.load("spineboy-pro.atlas").toText();
        var atlas:TextureAtlas = new TextureAtlas(atlasData, loader);

        var json:SkeletonJson = new SkeletonJson(new AtlasAttachmentLoader(atlas));
        json.setScale(0.6);

        var skeletonData:SkeletonData = json.readSkeletonData(new spine.HeapsSkeletonFileHandle("spineboypro.json"));

        skeletons = [];

        for (i in 0...10)
        {
            var skeleton = new spine.SpineAnimation(skeletonData, s2d);
            skeleton.state.setAnimationByName(0,"walk",true);
            skeleton.x = s2d.width * Math.random();
            skeleton.y = 500;
            skeletons.push(skeleton);
        }
    }

    override function update(dt:Float) 
    {
        for (skeleton in skeletons)
        {
            skeleton.advanceTime(1 / 60);
        }
    }
}