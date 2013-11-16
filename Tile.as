package
{
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	
	import flash.display.MovieClip;

	public class Tile extends MovieClip
	{
		/*what does this class do?
			1) linked list structure that allows tiles to be dynamically created and put together
			2) arrow UI that allows users to jump between tiles
			3) container for tile images or even child swfs
		*/
		//properties go here
		protected var linkedTiles:Vector.<Tile> = new Vector.<Tile>();
		protected var arrowsToLinked:Vector.<Arrow> = new Vector.<Arrow>();
		protected var activated:Boolean = false;
		protected var xRadius:Number = 0;
		protected var yRadius:Number = 0;
		//constructor
		public function Tile(xIn:Number, yIn:Number, rotationIn:Number)
		{
			this.x = xIn;
			this.y = yIn;
			this.rotation = rotationIn;
//			xRadius = this.width/2;
//			yRadius = this.height/2;
			xRadius = this.getRect(this).width/2;
			yRadius = this.getRect(this).height/2;
			trace(xRadius*2+","+yRadius*2);
		}
		//behaviors go here
		public function getXRadius():Number
		{
			return xRadius;
		}
		public function getYRadius():Number
		{
			return yRadius;
		}
		public function link(...rest:*):void
		{
			for each (var childTile:Tile in rest)
			{
				if(linkedTiles.indexOf(childTile) == -1)
				{
					childTile.linkBackToParent(this);
					var arrowToChildTile:Arrow = new Arrow(this, childTile); //instantiate a new arrow
					linkedTiles.push(childTile);
					arrowsToLinked.push(arrowToChildTile);
				}
				
			}
		}
		public function linkBackToParent(parentIn:Tile)
		{
			var arrowToParentTile:Arrow = new Arrow(this, parentIn);
			linkedTiles.push(parentIn);
			arrowsToLinked.push(arrowToParentTile);
		}
		public function activate():void
		{
			//make arrows to activate visible
			//tween arrows to activate opaque
			function activateArrow(arrowIn:Arrow):void
			{
				arrowIn.visible = true;
				var tweenFadeIn = new Tween(arrowIn,"alpha",Regular.easeInOut,0,1,.25,true);
			}
			for(var i:int = 0; i<arrowsToLinked.length; i++)
			{
				activateArrow(arrowsToLinked[i]);
			}
		}
		public function deactivate():void
		{
			function deactivateArrow(arrowIn:Arrow):void
			{
				var tweenFadeOut = new Tween(arrowIn,"alpha",Regular.easeInOut,0,1,.25,true);
				//if you want the smooth fade out you will have to add a timer here, and only turn off visibility after the timer
				arrowIn.visible = false;
			}
			for(var i:int = 0; i<arrowsToLinked.length; i++)
			{
				deactivateArrow(arrowsToLinked[i]);
			}
		}
	}
}