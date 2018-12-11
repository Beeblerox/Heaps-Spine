package;

import haxe.Timer;
import spine.AnimationState.AnimationStateListener;
import spine.AnimationState.TrackEntry;
import spine.Event;

class EventListener implements AnimationStateListener 
{
    /** Invoked when this entry has been set as the current entry. */
    public function start(entry:TrackEntry):Void
    {

    }

    /** Invoked when another entry has replaced this entry as the current entry. This entry may continue being applied for
     * mixing. */
    public function interrupt(entry:TrackEntry):Void
    {

    }

    /** Invoked when this entry is no longer the current entry and will never be applied again. */
    public function end(entry:TrackEntry):Void
    {

    }

    /** Invoked when this entry will be disposed. This may occur without the entry ever being set as the current entry.
     * References to the entry should not be kept after <code>dispose</code> is called, as it may be destroyed or reused. */
    public function dispose(entry:TrackEntry):Void
    {

    }

    /** Invoked every time this entry's animation completes a loop. */
    public function complete(entry:TrackEntry):Void
    {

    }

    /** Invoked when this entry's animation triggers an event. */
    public function event(entry:TrackEntry, event:Event):Void
    {
        // Inspect and respond to the event here.
        if (event.toString() == "footstep")
        {
            trace("footstep event " + Timer.stamp());
        }
    }

    public function new() { }
}