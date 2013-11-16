package
{
	import fl.transitions.Fade;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Arrow extends MovieClip
	{
		//properties go here
		protected var parentTile:Tile;
		protected var childTile:Tile;
		//constructor
		public function Arrow(parentIn:Tile, childIn:Tile)
		{
			parentTile = parentIn;
			childTile = childIn;
			this.calculatePositionAndRotation(parentIn,childIn);
			parentIn.addChild(this);
			addEventListener(MouseEvent.CLICK,clickHandler);
			//arrows aren't visible by default. they have to be activated by their parent tile
			this.alpha = 0;
			this.visible = false;
		}
		//behaviors go here
		protected function clickHandler(eventIn:MouseEvent):void
		{
			//calculate target pan, tilt, and zoom
			var differenceBetweenChildAndParentX:Number = childTile.x - parentTile.x;
			var differenceBetweenChildAndParentY:Number = childTile.y - parentTile.y;
			//dispatch camera event
			var dispatched:Boolean = dispatchEvent(new CameraEvent(CameraEvent.DEFAULT,true,false,differenceBetweenChildAndParentX,differenceBetweenChildAndParentY,(-1*childTile.rotation),1/((childTile.scaleX+childTile.scaleY)/2)));
//			trace(dispatched);
			parentTile.deactivate();
			childTile.activate();
		}
		protected function calculatePositionAndRotation(parentIn:Tile,childIn:Tile):void
		{
			var differenceY:Number = childIn.y-parentIn.y;
			var differenceX:Number = childIn.x-parentIn.x;
			//first handle your horizontal and vertical cases
			if(differenceY == 0)
			{
				if(differenceX>=0)
				{
					this.rotation = 0;
//					trace("left facing");
				}
				else
				{
					this.rotation = 180;
//					trace("right facing");
				}
			}
			else if(differenceX == 0)
			{
				if(differenceY>=0)
				{
					this.rotation = 90;
//					trace("down facing");
				}
				else
				{
					this.rotation = 270;
//					trace("up facing");
				}
			}
			else
			{
				var slope:Number = differenceY/differenceX;
//				trace(slope+" is slope");
				var deg:Number = Math.atan(slope)*180/Math.PI 
//				trace(deg+" is raw degrees");
				if(differenceX<0)
				{
					deg += 180;
				}
				this.rotation = deg;
			}
			this.rotation -= parentTile.rotation;
			//calculate aspect ratio of tile
			var aspectRatio:Number = parentTile.getYRadius()/parentTile.getXRadius();
			//next, find the threshold angle for vtcl or hzl border
			var thresholdAngle = Math.atan(aspectRatio)*180/Math.PI;
			var negativeY:Boolean = false;
			var ySetMax:Boolean = false;
			var negativeX:Boolean = false;
			var xSetMax:Boolean = false;
			if(Math.abs(this.rotation)>thresholdAngle && Math.abs(this.rotation)<(180-thresholdAngle)){
				//then it's a hzl border
				if(this.rotation<0)
				{
					//top
					this.y = -1*parentTile.getYRadius();
					negativeY = true;
				}
				else
				{
					//bottom
					this.y = parentTile.getYRadius();
				}
				ySetMax = true;
//				trace("y set to max");
			}
			else
			{
				//it's a vtcl border
				if(Math.abs(this.rotation)<90)
				{
					//right
					this.x = parentTile.getXRadius()+50;
				}
				else
				{
					this.x = -1*parentTile.getXRadius()-50;
					negativeX = true;
				}
				xSetMax = true;
//				trace("x set to max");
			}
			if(ySetMax)
			{
				//set x
				this.x = Math.cos(this.rotation*Math.PI/180)*parentTile.getXRadius();
			}
			else
			{
				//set y
				this.y = Math.sin(this.rotation*Math.PI/180)*parentTile.getYRadius();
			}
			var scaleCompensate:Number = ((parentTile.scaleX+parentTile.scaleY)/2);
			this.x /= scaleCompensate;
			this.y /= scaleCompensate;

		}
	}
}