import spine.support.graphics.TextureAtlas;
import spine.SkeletonData;
import spine.SkeletonJson;
import spine.SkeletonBinary;
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
        skeletons = [];
        
        var spineboyLoader:spine.HeapsTextureLoader = new spine.HeapsTextureLoader("spineboy-pro.png");
        var spineboyAtlasData = hxd.Res.load("spineboy-pro.atlas").toText();
        var alienAtlas:TextureAtlas = new TextureAtlas(spineboyAtlasData, spineboyLoader);
        
        // You can load animations from json files:
        var json:SkeletonJson = new SkeletonJson(new AtlasAttachmentLoader(alienAtlas));
        json.setScale(0.6);
        var spineboySkeletonData:SkeletonData = json.readSkeletonData(new spine.HeapsSkeletonFileHandle("spineboy-pro.json"));

        var spineboySkeleton = new spine.SpineAnimation(spineboySkeletonData, s2d);
        spineboySkeleton.state.setAnimationByName(0, "walk", true);
        spineboySkeleton.x = 200;
        spineboySkeleton.y = 500;
        spineboySkeleton.smooth = true;
        skeletons.push(spineboySkeleton);
        
        var alienLoader:spine.HeapsTextureLoader = new spine.HeapsTextureLoader("alien.png");
        var alienAtlasData = hxd.Res.load("alien.atlas").toText();
        var alienAtlas:TextureAtlas = new TextureAtlas(alienAtlasData, alienLoader);

        // Or you can load animations from binary files:
        var binary:SkeletonBinary = new SkeletonBinary(new AtlasAttachmentLoader(alienAtlas));
        binary.setScale(0.6);
        var bytes = hxd.Res.load("alien-pro.skel").entry.getBytes();
        var alienSkeletonData:SkeletonData = binary.readSkeletonDataFromBytes(bytes, "alien-pro.skel");

        var alienSkeleton = new spine.SpineAnimation(alienSkeletonData, s2d);
        alienSkeleton.state.setAnimationByName(0, "run", true);
        alienSkeleton.x = s2d.width - 200;
        alienSkeleton.y = 500;
        alienSkeleton.scaleX = -1;
        alienSkeleton.smooth = true;
        skeletons.push(alienSkeleton);
    }

    override function update(dt:Float) 
    {
        for (skeleton in skeletons)
        {
            skeleton.advanceTime(1 / 60);
        }
    }
}