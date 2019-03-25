package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.filters.DropShadowFilter;
	
	/**
	 * ...
	 * @author Chirimen
	 */
	public class Main extends Sprite 
	{
		private var textField:TextField;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var dropShadow:DropShadowFilter = new DropShadowFilter(0, 45, 0, 0.8, 8, 8, 3);
			
			var format:TextFormat = new TextFormat();
			format.font = "$FieldFont";
			format.size = 18;
			format.align = TextFormatAlign.CENTER;
			format.color = 0xffff00;
			
			textField = new TextField();
			textField.defaultTextFormat = format;
			textField.autoSize = TextFieldAutoSize.CENTER;
			
			textField.filters = [ dropShadow ];
			stage.addChild(textField);
			
			as_setText("日本語");
			as_setPosition(0, 0);
		}
		
		public function as_setText(text:String):void
		{
			textField.htmlText = text;
		}

		public function as_setPosition(x:int = 0, y:int = 0):void
		{
			textField.x = x;
			textField.y = y;
		}
		
	}
	
}