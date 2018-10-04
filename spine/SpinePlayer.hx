package spine;

import h2d.RenderContext;

import spine.Skeleton;
import spine.SkeletonData;
import spine.AnimationState;
import spine.AnimationStateData;
import spine.Slot;
import spine.support.graphics.TextureAtlas;
import spine.attachments.MeshAttachment;
import spine.attachments.RegionAttachment;
import spine.support.graphics.Color;

private class SpineContent extends h3d.prim.Primitive
{
    var vertex:hxd.FloatBuffer;
    var index:hxd.IndexBuffer;

    public var verticesCount(default, null):Int = 0;
    public var indexCount(default, null):Int = 0;

    var uploadedVertices:Int = 0;
    var uploadedIndices:Int = 0;

    public function new()
    {
        vertex = new hxd.FloatBuffer();
        index = new hxd.IndexBuffer();
    }

    public inline function addIndex(i:Int):Void
    {
        index[indexCount] = i;
        indexCount++;
    }

    public inline function addVertex(x:Float, y:Float, u:Float, v:Float, r:Float, g:Float, b:Float, a:Float)
    {
        vertex[verticesCount++] = x;
		vertex[verticesCount++] = y;
		vertex[verticesCount++] = u;
		vertex[verticesCount++] = v;
		vertex[verticesCount++] = r;
		vertex[verticesCount++] = g;
		vertex[verticesCount++] = b;
		vertex[verticesCount++] = a;
    }

    override function alloc(engine:h3d.Engine) 
    {
        if (indexCount <= 0) return;
		buffer = h3d.Buffer.ofFloats(vertex, 8, [RawFormat]);
		indexes = h3d.Indexes.alloc(index);

        uploadedVertices = verticesCount;
        uploadedIndices = indexCount;
    }

    override function render(engine:h3d.Engine) 
    {
		if (indexCount <= 0) return;
		flush();
		engine.renderIndexed(buffer, indexes, 0, Std.int(indexCount / 3));
	}

    public inline function flush() 
    {
		var growVertices:Bool = (verticesCount > uploadedVertices);
        var growIndices:Bool = (indexCount > uploadedIndices);
        
        if (growVertices || growIndices || buffer == null || indexes == null ||
            buffer.isDisposed() || indexes.isDisposed())
        {
            // dispose old buffers if there was any
            if (buffer != null && !buffer.isDisposed())
            {
                buffer.dispose();
            }

            if (indexes != null && !indexes.isDisposed())
            {
                indexes.dispose();
            }
            
            alloc(h3d.Engine.getCurrent());
        }
        else
        {
            buffer.uploadVector(vertex, 0, Std.int(verticesCount / 8));
            indexes.upload(index, 0, indexCount);
        }
	}

    public inline function reset():Void
    {
        verticesCount = 0;
        indexCount = 0;
    }

    public inline function grow(vertices:Int, indices:Int)
    {
        vertex.grow(vertices);
        index.grow(indices);
    }

    public function clear()
    {
        // TODO: implement it...
    }
}

class SpinePlayer extends h2d.Drawable 
{
    public var skeleton:Skeleton;
    public var timeScale:Float = 1;

    public var state:AnimationState;

    var content:SpineContent;

    var _isPlay:Bool = true;

    var _tempVerticesArray:Array<Float>;
    var _quadTriangles:Array<Int>;

    var tile:h2d.Tile;

    public function new(skeletonData:SkeletonData, stateData:AnimationStateData = null, ?parent) 
    {
		super(parent);

        skeleton = new Skeleton(skeletonData);
        skeleton.updateWorldTransform();
        skeleton.setToSetupPose();

        content = new SpineContent();

        _quadTriangles = new Array<Int>();
		_quadTriangles[0] = 0;
		_quadTriangles[1] = 1;
		_quadTriangles[2] = 2;
		_quadTriangles[3] = 2;
		_quadTriangles[4] = 3;
		_quadTriangles[5] = 0;

        _tempVerticesArray = new Array<Float>();

        state = new AnimationState(stateData == null ? new AnimationStateData(skeletonData):stateData);
        advanceTime(0);
    }

    public function advanceTime(delta:Float):Void 
    {
		if (!_isPlay) return;

        state.update(delta * timeScale);
		state.apply(skeleton);
		skeleton.updateWorldTransform();
		skeleton.update(delta * timeScale);
	}

    override function onRemove() 
    {
		super.onRemove();
		content.clear();
	}

    override function draw(ctx:RenderContext) 
    {
		if (tile == null)   return;
        
        if (!ctx.beginDrawObject(this, tile.getTexture())) return;
		content.render(ctx.engine);
	}

    override function sync(ctx:RenderContext) 
    {
		super.sync(ctx);

	//	flush();
        renderTriangles();
		content.flush();
	}

    private function renderTriangles():Void
	{
        var drawOrder:Array<Slot> = skeleton.drawOrder;
		var n:Int = drawOrder.length;

        var atlasRegion:AtlasRegion;
		var slot:Slot;
    //    var color:Color;
		var r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 0;
		var color:Int;
		var blend:Int;

        tile = null;

        var triangles:Array<Int> = null;
		var uvs:Array<Float> = null;

        content.reset();
        var vertexLength:Int = 0;
        var indexLength:Int = 0;

        for (i in 0...n)
		{
			slot = drawOrder[i];

            if (slot.attachment != null)
			{
				if (Std.is(slot.attachment, RegionAttachment))
				{
					var region:RegionAttachment = cast slot.attachment;
                    if (region.getRegion() != null)
                    {
                        vertexLength += 4 * 8; // 8 values per verter
                        indexLength += 6; // 6 indices per region
                    } 
                    
				}
				else if(Std.is(slot.attachment, MeshAttachment))
                {
					var region:MeshAttachment = cast slot.attachment;
                    if (region.getRegion() != null)
                    {
                        vertexLength += region.getWorldVerticesLength() * 4; // 8 values per verter * 2
                        indexLength += region.getTriangles().length;
                    }
				}
			}
        }

        content.grow(vertexLength, indexLength);

        var verticesLength:Int = 0;
        var indicesLength:Int = 0;

        var startIndex:Int = 0;

        for (i in 0...n)
		{
			slot = drawOrder[i];

            verticesLength = 0;
            indicesLength = 0;

            slot = drawOrder[i];
			atlasRegion = null;
			_tempVerticesArray.splice(0, _tempVerticesArray.length);

            if (slot.attachment != null)
			{
				if (Std.is(slot.attachment, RegionAttachment))
				{
                    var region:RegionAttachment = cast slot.attachment;
					region.computeWorldVertices(slot.bone, _tempVerticesArray, 0, 2);

                    verticesLength = 4;
                    indicesLength = 6;
                    
                    atlasRegion = cast region.getRegion();
                    r = region.getColor().r;
					g = region.getColor().g;
					b = region.getColor().b;
					a = region.getColor().a;

                    uvs = region.getUVs();
                    triangles = _quadTriangles;
				}
				else if (Std.is(slot.attachment, MeshAttachment))
                {
                    var region:MeshAttachment = cast slot.attachment;
                    
                    region.computeWorldVertices(slot, 0, region.getWorldVerticesLength(), _tempVerticesArray, 0, 2);
                    uvs = region.getUVs();
					triangles = region.getTriangles();

                    verticesLength = region.getWorldVerticesLength() >> 1;
                    indicesLength = triangles.length;

                    atlasRegion = cast region.getRegion();
                    r = region.getColor().r;
					g = region.getColor().g;
					b = region.getColor().b;
					a = region.getColor().a;
				}
                
				if (atlasRegion != null)
				{
					if (atlasRegion.page.rendererObject != tile)
                    {
                        tile = cast atlasRegion.page.rendererObject;
                    }

                    for (v in 0...verticesLength)
                    {
                        var v1 = v * 2;
                        var v2 = v1 + 1;
                        content.addVertex(_tempVerticesArray[v1], _tempVerticesArray[v2], uvs[v1], uvs[v2], r, g, b, a);
                    }

                    for (ind in 0...indicesLength)
                    {
                        content.addIndex(triangles[ind] + startIndex);
                    }
                    
                    startIndex += verticesLength;
				}
				
			}

        }
	}
}