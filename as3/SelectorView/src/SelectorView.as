package
{
	//App.instance.loaderMgr.loadLibraries(Vector.<String>([
    //    "guiControlsLobbyBattle.swf"
    //]));
	
	import net.wg.gui.interfaces.ISoundButton;
	import net.wg.infrastructure.base.AbstractWindowView;
	import net.wg.infrastructure.base.AbstractView;
	import net.wg.infrastructure.base.SmartPopOverView
	import net.wg.infrastructure.events.ListDataProviderEvent;

	import net.wg.gui.components.controls.ScrollBar;
	import net.wg.gui.components.controls.SoundButton;;
	import net.wg.gui.components.controls.SoundButtonEx;
	import net.wg.gui.components.advanced.ButtonBarEx;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import scaleform.clik.controls.Button;
	import scaleform.clik.controls.ListItemRenderer;
	import scaleform.clik.controls.ScrollingList;
	import scaleform.clik.data.ListData;
	import scaleform.clik.data.DataProvider;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Chirimen
	 */
	public class SelectorView extends AbstractWindowView 
	{
		public var className:String = null;
		private var listItem:ListItemRenderer = null;
		private var textFormat:TextFormat = new TextFormat();
		
		public var scrollBar:ScrollBar = null;
		public var scrollingList:ScrollingList = null;
		
		public var tabs:ButtonBarEx = null;
		public var button:SoundButton = null;
		public var buttonList:Array = [];
		
		private var wwsoundData:Array = null;
		
		public var onButtonClickS:Function = null;
		
		public function SelectorView() : void
		{
			super();
			className = getQualifiedClassName(this);
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "constructor");

			textFormat.font = "$FieldFont";
			textFormat.size = 14;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.color = 0xFFFF00;
		}
		
		private function createButtons(data:Array) : void
		{
			var button:SoundButton;
			var label:String = "";
			var posY:int = 0;
			var bWidth:int = 480;
			var bHeight:int = 25;
			
			for each (var name:String in data) {
				DebugUtils.LOG_DEBUG_FORMAT("%s: %s: %s", className, "createButton", name);
				label = name;
				button = App.utils.classFactory.getComponent("ButtonNormal", SoundButton, {
					width: bWidth,
					height: bHeight,
					x: 0,
					y: posY,
					label: label
				}) as SoundButton;
				if (button) {
					button.addEventListener(MouseEvent.CLICK, onButtonClick);
					addChild(button);
					buttonList.push(button);
				}
				posY += bHeight;
			}
			width = bWidth;
			height = posY;
			DebugUtils.LOG_DEBUG_FORMAT("%s: (%r, %r), width=%r, height=%r", className, x, y, width, height);
		}
		
		override protected function onPopulate() : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "onPopulate");
			createButtons(wwsoundData);
			window.title = "Sound Test";
			
			super.onPopulate();
			DebugUtils.LOG_DEBUG_FORMAT("%s: (%r, %r), width=%r, height=%r", className, x, y, width, height);
			
			//tabs = new ButtonBarEx();
			//var data:Array = new Array();
			//data.push({"label":"Item 1"});
			//data.push({"label":"Item 2"});
			//tabs.dataProvider = new DataProvider(data);
			//tabs.autoSize = "right";
			//tabs.buttonWidth = 50.0;
			//tabs.direction = "horizontal";
			//tabs.enabled = true;
			//tabs.enableInitCallback = false;
			//tabs.focusable = true;
			//tabs.itemRendererName = "TabButton";
			//tabs.paddingHorizontal = 15;
			//tabs.spacing = 5;
			//tabs.visible = true;
			//addChild(tabs);
			
			//listItem = new ListItemRenderer();
			//listItem.textField.defaultTextFormat = textFormat;
			//listItem.setData("data0");
			//listItem.setListData(new ListData(0, "item 0"));
			//listItem.x = 4;
			//listItem.y = 4;
			//addChild(listItem);

			onTryClosing = tryClosing;
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "onPopulate: done");
		}
		
		override protected function configUI() : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "configUI");
			super.configUI();
		}
		
		override protected function draw() :void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "draw");
			DebugUtils.LOG_DEBUG_FORMAT("%s: (%r, %r), width=%r, height=%r", className, x, y, width, height);
			super.draw();
			//scrollBar.visible = true;
			//scrollingList.validateNow();
		}
		
		override protected function onBeforeDispose() : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "onBeforeDispose");
			super.onBeforeDispose();
		}

		override protected function onDispose() : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "onDispose");
			super.onDispose();
		}
		
		public function tryClosing() : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "TryClosing");
			dispose();
		}
		
		public function onButtonClick(event:Event) : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "onButtonClick");
			var button:ISoundButton = event.target as SoundButton;
			DebugUtils.LOG_DEBUG_FORMAT("%s: button=%s", className, button.label);
			onButtonClickS(button.label);
			DebugUtils.LOG_DEBUG_FORMAT("%s: button=%s", className, button.label);
		}
		
		public function as_setConfig(data:Array) : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s: %r", className, "as_setConfig", data.length);
			wwsoundData = data;
		}
		
	}
	
}