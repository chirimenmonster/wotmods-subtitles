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
		private var textFormat:TextFormat;
		private var dropShadowFilter:DropShadowFilter;
		
		private var poolTextField:Array = [];
		private var activeIds:Array = [];
		private var freeIds:Array = [];
		
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
			
			dropShadowFilter = new DropShadowFilter(0, 45, 0, 0.8, 8, 8, 3);
			
			textFormat = new TextFormat();
			textFormat.font = "$FieldFont";
			textFormat.size = 18;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.color = 0xffff00;
			
			textField = new TextField();
			textField.defaultTextFormat = textFormat;
			textField.autoSize = TextFieldAutoSize.CENTER;
			
			textField.filters = [ dropShadowFilter ];
			stage.addChild(textField);
			
			as_setText("日本語");
			as_setPosition(0, 0);
			
			//test();
		}
		
		private function test():void
		{
			var id:int = as_allocToken();
			as_setMessageToken(id, "message");
			as_setPositionToken(id, 100, 100);
			as_activeToken(id);
			as_disposeToken(id);
			as_freeToken(id);
		}
		
		private function createNewToken():TextField
		{
			var token:TextField = new TextField();
			token.defaultTextFormat = textFormat;
			token.autoSize = TextFieldAutoSize.CENTER;
			token.filters = [ dropShadowFilter ];
			stage.addChild(token);
			return token;
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
		
		public function as_allocToken():int
		{
			var id:int;
			
			if (freeIds.length == 0)
			{
				var textField2:TextField = createNewToken();
				id = poolTextField.push(textField2) - 1;
				freeIds.push(id);
			}
			id = freeIds.pop();
			activeIds.push(id);
			return id;
		}
		
		public function as_freeToken(id:int):void
		{
			var index:int = activeIds.indexOf(id);
			if (index < 0) {
				return;
			}
			activeIds.splice(index, 1);
			freeIds.push(id);
		}
		
		public function as_getListToken():Array
		{
			return activeIds;
		}
		
		public function as_setPositionToken(id:int, x:int, y:int):void
		{
			var textField:TextField = poolTextField[id];
			textField.x = x;
			textField.y = y;
		}
		
		public function as_rmovetoToken(id:int, x:int = 0, y:int = 0):void
		{
			var textField:TextField = poolTextField[id];
			textField.x += x;
			textField.y += y;
		}
		
		public function as_setMessageToken(id:int, text:String):void
		{
			var textField:TextField = poolTextField[id];
			textField.htmlText = text;
		}
		
		public function as_activeToken(id:int):void
		{
			var textField:TextField = poolTextField[id];
			textField.visible = true;
		}
		
		public function as_disposeToken(id:int):void
		{
			var textField:TextField = poolTextField[id];
			textField.visible = false;
		}

	}
	
}