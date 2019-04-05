package 
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.display.Shape;
	import Math;

	import FadeoutText;
	
	/**
	 * ...
	 * @author Chirimen
	 */
	public class Panel extends Sprite
	{
		private var poolTextField:Array = [];
		private var activeTextField:Array = [];
		private var inactiveTextField:Array = [];
		private var anchorX:int;
		private var anchorY:int;
		private var panelHeight:int;
		private var panelWidth:int;
		
		public var stats:Array;
		
		public function stop() : void
		{
			for each (var textField:FadeoutText in poolTextField) {
				textField.stop();
				textField.removeEventListener("FIN_FADEOUT", onFinFadeout);
				removeChild(textField);
			}
			poolTextField = null;
			activeTextField = null;
			inactiveTextField = null;
		}
		
		private function onFinFadeout(e:Event) : void 
		{
			var textField:FadeoutText = e.target as FadeoutText;
			textField.removeEventListener(Event.ENTER_FRAME, onFinFadeout);
			removeChild(textField);
			freeTextField(textField);
			layout();
		}
		
		private function reposition() : void
		{
			x = anchorX;
			y = anchorY - panelHeight;
		}
		
		public function setPosition(newX:int = 0, newY:int = 0) : void
		{
			anchorX = newX;
			anchorY = newY;
			reposition();
		}
		
		public function setMessage(message:String) : void
		{
			setNewMessage(message);
		}
		
		public function setNewMessage(message:String) : void
		{
			var textField:FadeoutText = allocateTextField();
			textField.init();
			textField.htmlText = message;
			textField.addEventListener("FIN_FADEOUT", onFinFadeout);
			addChild(textField);
			layout();
		}
		
		private function layout() : void
		{
			var y:int = 0;
			var width:int = 0;
			for each (var textField:FadeoutText in activeTextField) {
				textField.x = 0;
				textField.y = y;
				y += 24;
				width = Math.max(textField.width, width);
			}
			panelWidth = width;
			panelHeight = y;
			reposition();
		}
		
		private function allocateTextField() : FadeoutText
		{
			var textField:FadeoutText;

			if (inactiveTextField.length == 0)
			{
				textField = new FadeoutText();
				poolTextField.push(textField);
				inactiveTextField.push(textField);
			}
			textField = inactiveTextField.pop();
			activeTextField.push(textField);
			return textField;
		}
		
		private function freeTextField(textField:FadeoutText) : void
		{
			var index:int = activeTextField.indexOf(textField);
			if (index < 0) {
				return;
			}
			activeTextField.splice(index, 1);
			inactiveTextField.push(textField);
		}
	}
	
}