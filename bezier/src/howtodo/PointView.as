package howtodo {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	[Event(name="change", type="flash.events.Event")]

	public class PointView extends Sprite {
		
		public static var GRID:uint=10;
		
		private static var __last_selected:PointView;
		
		public const point:Point = new Point();
		private const change:Event = new Event(Event.CHANGE);
		
		private var __radius:Number=4;
		private var __borderColor:Number=0x000000;
		private var __bodyColor:Number=0xFFFFFF;
		private var __dragable:Boolean=false;
		
		private const nameTxt:TextField=new TextField();
		
		
		public function PointView ():void {
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			dragable = false;
			initNameTxt();
			redraw();
		}
		
		public function initNameTxt():void {
			nameTxt.autoSize = TextFieldAutoSize.LEFT;
			nameTxt.x = 8;
			nameTxt.y = -18;
			nameTxt.selectable = false;
			nameTxt.mouseEnabled = false;
		}
		public function onMouseDown(event:MouseEvent):void {
			if (__dragable) {
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				if (__last_selected) {
					__last_selected.onDeselect();
				}
				__last_selected = this;
				__last_selected.onSelect();
			}
		}
		public function onMouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		public function onMouseMove(event:MouseEvent):void {
			var tmpX:Number = point.x;
			var tmpY:Number = point.y;
			var newX:Number = Math.round(event.stageX/GRID)*GRID;
			var newY:Number = Math.round(event.stageY/GRID)*GRID;
			if (tmpX != newX || tmpY != newY) {
				point.x = super.x = newX;
				point.y = super.y = newY;
				dispatchEvent(change);
			}
		}
		
		public function get position():Point {
			return point.clone();
		}
		public function set position(value:Point):void {
			point.x = super.x = value.x;
			point.y = super.y = value.y;
		}
		
		override public function set x(value:Number):void {
			point.x = super.x = value;
		}
		override public function set y(value:Number):void {
			point.y = super.y = value;
		}
		
		public function get dragable():Boolean {
			return __dragable;
		}
		public function set dragable (value:Boolean):void {
			buttonMode = 
			useHandCursor = 
			mouseEnabled =
			__dragable = value;
		}
		
		public function get textColor ():uint {
			return nameTxt.textColor; 
		}
		public function set textColor (value:uint):void {
			nameTxt.textColor = value;
		}
		public function get pointName ():String {
			return nameTxt.text;
		}
		public function set pointName(value:String):void {
			nameTxt.htmlText = value;
			if (value.length) {
				addChild(nameTxt);
			} else if (nameTxt.parent) {
				removeChild(nameTxt);
			}
		}
		
		public function get radius ():Number {
			return __radius;
		}
		public function set radius (value:Number):void {
			__radius = value;
			redraw();
		}
		public function get borderColor ():Number {
			return __borderColor;
		}  
		public function set borderColor (value:Number):void {
			__borderColor = value;
			redraw();
		}
		
		public function get bodyColor ():Number {
			return __bodyColor;
		}  
		public function set bodyColor (value:Number):void {
			__bodyColor = value;
			redraw();
		}
		
		private function onSelect ():void {
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		private function onDeselect ():void {
			removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown (event:KeyboardEvent):void {
			if (event.keyCode >36 && event.keyCode < 41) {
				var step:uint = 1;
				if (event.ctrlKey) {
					step = 10;
				}
				switch (event.keyCode) {
					case 37:
						x-=step;
					break;
					case 38:
						y-=step;
					break;
					case 39:
						x+=step;
					break;
					case 40:
						y+=step;
					break;
				}
				x = int(x/step)*step;
				y = int(y/step)*step;
				dispatchEvent(change);
			}
		}
		
		private function redraw ():void {
			graphics.clear();
			graphics.lineStyle(0, __borderColor, 1);
			graphics.beginFill(__bodyColor, .5);
			graphics.drawCircle(0, 0, __radius);
		}
		
		override public function toString():String {
			return "(x="+Math.round(x*100)/100+",y="+Math.round(y*100)/100+")";
		}
		
	}
}