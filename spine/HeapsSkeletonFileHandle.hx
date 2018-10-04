package spine;

class HeapsSkeletonFileHandle implements spine.support.files.FileHandle 
{
	public var path:String = ""; // TODO: actually use it...
	
	private var data:String;

	public function new(path:String, data:String = null)
	{
		if (path == null)
			path = "";
		
		this.path = path;

		if (data == null)
			data = hxd.Res.load(path).toText();
		
		this.data = data;
	}

	public function getContent():String
	{
		return data;
	}
}