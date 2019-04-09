package
{
	import flash.display.Scene;
	import net.wg.gui.interfaces.ISoundButton;
	import net.wg.infrastructure.base.AbstractWindowView;
	import net.wg.infrastructure.base.AbstractView;
	import net.wg.infrastructure.base.SmartPopOverView
	import net.wg.infrastructure.events.ListDataProviderEvent;

	import net.wg.gui.components.controls.ScrollBar;
	import net.wg.gui.components.controls.SoundButton;
	import net.wg.gui.components.controls.SoundListItemRenderer;
	import net.wg.gui.components.controls.SoundButtonEx;
	import net.wg.gui.components.advanced.ButtonBarEx;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.wg.infrastructure.events.LibraryLoaderEvent;
	
	import flash.utils.getQualifiedClassName;
	
	import scaleform.clik.controls.Button;
	import scaleform.clik.controls.ListItemRenderer;
	import scaleform.clik.controls.ScrollingList;
	import scaleform.clik.controls.DropdownMenu;
	import scaleform.clik.data.ListData;
	import scaleform.clik.data.DataProvider;
	import scaleform.clik.events.ListEvent;
	
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
		
		public var dropdownMenu:DropdownMenu = null;
		private var wwsoundData:Array = null;
		
		public var onButtonClickS:Function = null;
		
		private var _isLibrariesLoaded:Boolean = false;
		private var _currentSelectedData:String = null;

		public function SelectorView() : void
		{
			App.instance.loaderMgr.addEventListener(LibraryLoaderEvent.LOADED_COMPLETED, onLoadedCompleted);
			App.instance.loaderMgr.loadLibraries(Vector.<String>([
				"guiControlsLobby.swf", 
				"guiControlsLobbyBattle.swf", 
				"guiControlsLobbyBattleDynamic.swf", 
				"guiControlsLobbyDynamic.swf", 
				"guiControlsLogin.swf", 
				"guiControlsLoginBattle.swf", 
				"guiControlsLoginBattleDynamic.swf"
			]));			
			super();
			className = getQualifiedClassName(this);
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "constructor");
		}

		private function onLoadedCompleted(event:LibraryLoaderEvent) : void
		{
			App.instance.loaderMgr.removeEventListener(LibraryLoaderEvent.LOADED, onLoadedCompleted);
			_isLibrariesLoaded = true;
			initControls();
		}

		public function initControls() : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "initControls");
			textFormat.font = "$FieldFont";
			textFormat.size = 14;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.color = 0xFFFF00;

			createDropdownMenu(wwsoundData);
			createPlayButton();
		}
		
		private function createButtons(data:Array) : void
		{
			var button:SoundButton;
			var label:String = "";
			var posY:int = 0;
			var bWidth:int = 480;
			var bHeight:int = 25;
			
			for each (var name:String in data) {
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
		
		private function createButtonItems(data:Array) : Array
		{
			var button:ListItemRenderer;
			var label:String = "";
			var posY:int = 0;
			var bWidth:int = 480;
			var bHeight:int = 25;
			
			var i:uint = 0;
			var buttonList:Array = new Array();
			for each (var name:String in data) {
				DebugUtils.LOG_DEBUG_FORMAT("%s: %s: %s", className, "createButtonItems", name);
				label = name;
				button = App.utils.classFactory.getComponent("DropDownListItemRendererSound", SoundListItemRenderer, {
					width: bWidth,
					height: bHeight,
					label: name					
				});
				//button.width = bWidth;
				//button.height = bHeight;
				//button.label = label;
				//button.setListData(new ListData(i, label));
				buttonList.push(button);
				i++;
			}
			return buttonList;
		}

		private function onPlayButtonClick() : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "onButtonClick");
			onButtonClickS(_currentSelectedData);
		}
		
		private function createPlayButton() : void
		{
			var setting:Object = {
				label: "Play",
				width: 80,
				height: 24,
				x: 0,
				y: 0
			}
			var button:SoundButton;
			button = App.utils.classFactory.getComponent("ButtonNormal", SoundButton, setting);
			if (button) {
				button.addEventListener(MouseEvent.CLICK, onPlayButtonClick);
				addChild(button);
			}
		}
		
		private function onDropdownListIndexChange(event:Event) : void
		{
			var target:DropdownMenu = event.target as DropdownMenu;
			_currentSelectedData = target.dataProvider[dropdownMenu.selectedIndex];
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s: %s", className, "onDropdownListIndexChange", _currentSelectedData);
		}
		
		private function createDropdownMenu(data:Array) : void
        {
            var dataProvider:DataProvider = new DataProvider(data);
            var setting:Object = {
				x:				0,
				y:				24,
                width:          480,
                itemRenderer:   "DropDownListItemRendererSound",
                dropdown:       "DropdownMenu_ScrollingList",
                dataProvider:   dataProvider,
                menuRowCount:   dataProvider.length,
                scrollBar:      "ScrollBar",
				thumbOffsetBottom:	0,
				thumbOffsetTop:		0
			};
            dropdownMenu = App.utils.classFactory.getComponent("DropdownMenuUI", DropdownMenu, setting);
            dropdownMenu.addEventListener(ListEvent.INDEX_CHANGE, onDropdownListIndexChange);
			dropdownMenu.scrollBar
            addChild(dropdownMenu);
		}

		private function createScrollingList() : void
		{
			var data:Array = null;
			
			data = createButtonItems([ "data0", "data1" ]);
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "create scrollingList");
			scrollingList = App.utils.classFactory.getComponent("ScrollingList", ScrollingList, {
				scrollBar: "ScrollBar",
				itemRenderer: "DropDownListItemRendererSound",
				rowHeight: 25,
				rowCount: 10,
				width: 200,
				height: 300
			});
			scrollingList.x = 0;
			scrollingList.y = 0;
			//scrollingList.dataProvider = new DataProvider([
			//	{ index: 0, label: "label0", data: "data0" },
			//	{ index: 1, label: "label1", data: "data1" }
			//]);
			scrollingList.dataProvider = new DataProvider(data);
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "create scrollingList");
			addChild(scrollingList);
			width = 200;
			height = 300;
		}
		
		
		override protected function onPopulate() : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "onPopulate");
			//createButtons(wwsoundData);
			//createScrollingList();
			//createDropdownMenu(wwsoundData);
			width = 480;
			height = 200;
			window.title = "Sound Test";
			
			super.onPopulate();
		}
		
		override protected function configUI() : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "configUI");
			super.configUI();
		}
		
		override protected function draw() :void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "draw");
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
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "as_setConfig");
			wwsoundData = data;
		}
		
	}
	
}