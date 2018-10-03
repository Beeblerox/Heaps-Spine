package spine;

private class SpineContent extends h3d.prim.Primitive
{
    var vertex:hxd.FloatBuffer;
    var index:hxd.IndexBuffer;

    public var vertexCount(default, null):Int = 0;
    public var indexCount(default, null):Int = 0;

    var uploadedVertices:Int = 0;
    var uploadedIndices:Int = 0;

    public function new()
    {

    }

    public inline function addIndex(i:Int):Void
    {
        index[indexCount++] = i;
    }

    public inline function addVertex(x:Float, y:Float, u:Float, v:Float, r:Float, g:Float, b:Float, a:Float)
    {
        vertex[vertexCount++] = x;
		vertex[vertexCount++] = y;
		vertex[vertexCount++] = u;
		vertex[vertexCount++] = v;
		vertex[vertexCount++] = r;
		vertex[vertexCount++] = g;
		vertex[vertexCount++] = b;
		vertex[vertexCount++] = a;
    }

    override function alloc(engine:h3d.Engine) 
    {
        if (index.length <= 0) return;
		buffer = h3d.Buffer.ofFloats(vertex, 8, [RawFormat]);
		indexes = h3d.Indexes.alloc(index);

        uploadedVertices = vertexCount;
        uploadedIndices = indexCount;
    }

    override function render(engine:h3d.Engine) 
    {
		if (index.length <= 0) return;
		flush();
		engine.renderIndexed(buffer, indexes, 0, Std.int(indexCount / 3)); // TODO: pass number of tris...
	}

    public inline function flush() 
    {
		var growVertices:Bool = (vertexCount >= uploadedVertices);
        var growIndices:Bool = (indexCount >= uploadedIndices);
        
        if (growVertices || growIndices || buffer == null || index == null ||
            buffer.isDisposed() || index.isDisposed())
        {
            // dispose old buffers if there was any
            if (buffer != null && !buffer.isDisposed())
            {
                buffer.dispose();
            }

            if (index != null && !index.isDisposed())
            {
                index.dispose();
            }
            
            alloc(h3d.Engine.getCurrent());
        }    
	}

    public inline function reset():Void
    {
        vertexCount = 0;
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

import spine.Skeleton;
import spine.SkeletonData;
import spine.Slot;
import spine.support.graphics.TextureAtlas;
import spine.attachments.MeshAttachment;
import spine.attachments.RegionAttachment;
import spine.support.graphics.Color;

class SpinePlayer extends Drawable 
{
    public var skeleton:Skeleton;
    public var timeScale:Float = 1;

    var content:SpineContent;

    var _isPlay:Bool = true;

    var _tempVerticesArray:Array<Float>;

    public function new(skeletonData:SkeletonData, ?parent) 
    {
		super(parent);

        skeleton = new Skeleton(skeletonData);
        skeleton.updateWorldTransform();

        content = new SpineContent();

        _tempVerticesArray = new Array<Float>();
    }

    public function advanceTime(delta:Float):Void 
    {
		if(!_isPlay) return;

		skeleton.update(delta * timeScale);
	}

    override function onRemove() 
    {
		super.onRemove();
		content.clear();
	}

    override function draw(ctx:RenderContext) 
    {
	//	if (!ctx.beginDrawObject(this, tile.getTexture())) return;
		content.render(ctx.engine);
	}

    override function sync(ctx:RenderContext) 
    {
		super.sync(ctx);

	//	flush();
		content.flush();
	}

    private function renderTriangles():Void
	{
        var drawOrder:Array<Slot> = skeleton.drawOrder;
		var n:Int = drawOrder.length;

        var atlasRegion:AtlasRegion;
		var slot:Slot;
		var r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 0;
		var color:Int;
		var blend:Int;

        var tile:h2d.Tile = null;

        content.reset();
        var vertexLength:Int = 0;
        var indexLength:Int = 0;

        for (i in 0 ... n)
		{
			slot = drawOrder[i];

            if(slot.attachment != null)
			{
				if (Std.is(slot.attachment, RegionAttachment))
				{
					vertexLength += 4 * 8; // 8 values per verter
                    indexLength += 6; // 6 indices per region
				}
				else if(Std.is(slot.attachment, MeshAttachment))
                {
					var region:MeshAttachment = cast slot.attachment;
					
                        vertexCount += region.getWorldVerticesLength() * 8; // 8 values per verter
                        indexCount += region.getTriangles().length;
				}
			}
        }

        content.grow(vertexLength, indexLength);

        for (i in 0 ... n)
		{
			slot = drawOrder[i];

            slot = drawOrder[i];
			atlasRegion = null;
			_tempVerticesArray.splice(0,_tempVerticesArray.length);

            if(slot.attachment != null)
			{
				if (Std.is(slot.attachment, RegionAttachment))
				{
                    var region:RegionAttachment = cast slot.attachment;
					region.computeWorldVertices(slot.bone, _tempVerticesArray, 0, 2);
                    uvs = region.getUVs();

                    atlasRegion = cast region.getRegion();
                    r = region.getColor().r;
					g = region.getColor().g;
					b = region.getColor().b;
					a = region.getColor().a;

                    /*
                    triangles = _quadTriangles;
                    */

				}
				else if(Std.is(slot.attachment, MeshAttachment))
                {
					/*
                    var region:MeshAttachment = cast slot.attachment;
					verticesLength = 8;
					region.computeWorldVertices(slot,0,region.getWorldVerticesLength(), _tempVerticesArray,0,2);
					uvs = region.getUVs();
					triangles = region.getTriangles();
					atlasRegion = cast region.getRegion();
					r = region.getColor().r;
					g = region.getColor().g;
					b = region.getColor().b;
					a = region.getColor().a;
                    */
				}

				if(atlasRegion != null)
				{
					/*
                    if(bitmapData != atlasRegion.page.rendererObject)
					{
						bitmapData = cast atlasRegion.page.rendererObject;
						this.graphics.beginBitmapFill(bitmapData,null,true,true);
					}

					var v:Vector<Int> = ofArrayInt(triangles);
					for(vi in 0...v.length)
					{
						v[vi] += t;
					}
					t += Std.int(_tempVerticesArray.length/2);

					allVerticesArray = allVerticesArray.concat(ofArrayFloat(_tempVerticesArray));
					allTriangles = allTriangles.concat(v);
					allUvs = allUvs.concat(ofArrayFloat(uvs));
                    */
				}
				
			}

        }
	}
}