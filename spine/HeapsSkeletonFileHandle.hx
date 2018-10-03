package spine;

class HeapsSkeletonFileHandle implements spine.support.files.FileHandle 
{
	public var path:String = ""; // TODO: actually use it...
	
	private var data:String;

	public function new(path:String, data:String)
	{
		this.path = path;
		this.data = data;
	}

	public function getContent():String{
		return data;
	}
}