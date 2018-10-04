package spine;

import spine.SkeletonData;
import spine.AnimationState;
import spine.AnimationStateData;

class SpineAnimation extends SpineSprite
{
    public var state:AnimationState;

    public function new(skeletonData:SkeletonData, stateData:AnimationStateData = null, ?parent) 
    {
		state = new AnimationState((stateData == null) ? new AnimationStateData(skeletonData) : stateData);
		super(skeletonData, parent);
        advanceTime(0);
	}

	override public function advanceTime(time:Float):Void 
    {
		state.update(time * timeScale);
		state.apply(skeleton);
		skeleton.updateWorldTransform();
		super.advanceTime(time);
	}
}