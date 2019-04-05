package
{
	import net.wg.infrastructure.base.AbstractView;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import Panel;
	
	/**
	 * ...
	 * @author Chirimen
	 */
	public class SubtitlesView extends AbstractView 
	{
		public var className:String = null;
		private var panel:Panel = null;
		
		public function SubtitlesView() : void
		{
			super();
			className = getQualifiedClassName(this);
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "constructor");
		}

		override protected function onPopulate() : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "onPopulate");
			super.onPopulate();
			panel = new Panel();
			addChild(panel);
		}
		
		override protected function onDispose() : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s", className, "onDispose");
			panel.stop();
			removeChild(panel);
			panel = null;
			super.onDispose();
		}
				
		public function as_setPosition(newX:int = 0, newY:int = 0) : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s: (%r, %r)", className, "as_setPosition", x, y);
			panel.setPosition(newX, newY);
		}
		
		public function as_setMessage(message:String) : void
		{
			DebugUtils.LOG_DEBUG_FORMAT("%s: %s: %s", className, "as_setMessage", message);
			panel.setMessage(message);
		}

	}
	
}
