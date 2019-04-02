package 
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.filters.DropShadowFilter;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Chirimen
	 */
	public class FadeoutText extends TextField 
	{
		public var lifeTime:Number = 5.0;
		public var fadeTime:Number = 2.0;
		
		private var fadeCount:Number;
		private var alphaRate:Number;
		
		public function init():void
		{
			trace("init");
			alpha = 1.0;
			
			var dropShadowFilter:DropShadowFilter = new DropShadowFilter(0, 45, 0, 0.8, 8, 8, 3);
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "$FieldFont";
			textFormat.size = 16;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.color = 0xffff00;

			defaultTextFormat = textFormat;
			autoSize = TextFieldAutoSize.LEFT;
			filters = [ dropShadowFilter ];

			addEventListener(Event.ADDED, onAdded);
		}
		
		private function startFade(evt:Event):void
		{
			trace("startFade");
			fadeCount = fadeTime * stage.frameRate;
			alphaRate = 1.0 / fadeCount;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onAdded(evt:Event):void
		{
			trace("onAdded: " + "(" + x + ", " + y + ")" + ", width=" + width + ", height=" + height);
			removeEventListener(Event.ADDED, onAdded);
			var timer:Timer = new Timer(lifeTime * 1000, 1);
			timer.addEventListener(TimerEvent.TIMER, startFade);
			timer.start()
		}
		
		private function onEnterFrame(evt:Event):void
		{
			fadeCount -= 1;
			alpha = fadeCount * alphaRate;
			if (fadeCount <= 0) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				dispatchEvent(new Event("FIN_FADEOUT"));
			}
		}
	}

}