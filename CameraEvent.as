package
{
	import flash.events.Event;
	
	public class CameraEvent extends Event
	{
		public static const DEFAULT:String = "default";
		protected var paramsVector:Vector.<Number> = new <Number>[0,0,0,1];
		public function CameraEvent(type:String = CameraEvent.DEFAULT, bubbles:Boolean=true, cancelable:Boolean=false, xPan:Number=0, yPan:Number=0, tilt:Number=0, zoom:Number=1)
		{
			super(type, bubbles, cancelable);
			paramsVector.fixed = true;
			setPanValues(xPan,yPan);
			setTiltValue(tilt);
			setZoomValue(zoom);
//			trace("dispatched! My values are "+getXPan()+" "+getYPan()+" "+getTilt()+" "+getZoomFactor()+".");
		}
		override public function clone():Event {
			// Return a new instance of this event with the same parameters.
			var newCameraEvent:CameraEvent = new CameraEvent(type, bubbles, cancelable);
			newCameraEvent.transferParamsVector(this);
//			trace("just got cloned!");
			return newCameraEvent;
		}
		protected function setPanValues(xPanIn:Number, yPanIn:Number):void
		{
			paramsVector[0] = xPanIn;
			paramsVector[1] = yPanIn;
		}
		protected function setTiltValue(degreesIn:Number):void
		{
			paramsVector[2] = degreesIn;
		}
		protected function setZoomValue(zoomFactorIn:Number):void
		{
			paramsVector[3] = zoomFactorIn;
		}
		public function transferParamsVector(cameraEventIn:CameraEvent):void
		{
			paramsVector = cameraEventIn.getParamsVector(this);
		}
		public function getParamsVector(cameraEventIn:CameraEvent):Vector.<Number>
		{
			return paramsVector;
		}
		public function getXPan():Number
		{
			return paramsVector[0];
		}
		public function getYPan():Number
		{
			return paramsVector[1];
		}
		public function getTilt():Number
		{
			return paramsVector[2];
		}
		public function getZoomFactor():Number
		{
			return paramsVector[3];
		}
	}
}