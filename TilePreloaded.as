package
{
	public class TilePreloaded extends Tile
	{
		override public function TilePreloaded()
		{
			//TilePreloaded uses an x and y position pre-set in the game
			super(this.x,this.y,this.rotation);
		}
	}
}