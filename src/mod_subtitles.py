
import BigWorld
import GUI
from debug_utils import LOG_CURRENT_EXCEPTION
from gui.IngameSoundNotifications import IngameSoundNotifications
from gui.Scaleform.Flash import Flash
from PlayerEvents import g_playerEvents

SWF_FILE = 'ShowText.swf'
SWF_PATH = '${flash_dir}'

g_textField = None

def overrideMethod(cls, method):
    def decorator(handler):
        orig = getattr(cls, method)
        newm = lambda *args, **kwargs: handler(orig, *args, **kwargs)
        if type(orig) is not property:
            setattr(cls, method, newm)
        else:
            setattr(cls, method, property(newm))
    return decorator

@overrideMethod(IngameSoundNotifications, 'play')
def _play(orig, self, eventName, *args, **kwargs):
    try:
        print eventName
        g_textField.setText(eventName)
    except:
        LOG_CURRENT_EXCEPTION()
    result = orig(self, eventName, *args, **kwargs)
    return result


def init():
    global g_textField
    g_textField = TextField()
    g_playerEvents.onAvatarBecomePlayer += g_textField.start
    g_playerEvents.onAvatarBecomeNonPlayer += g_textField.stop


class MessageToken(object):
    def __init__(self, message):
        self.objId = g_textField.allocToken()
        g_textField.setMessageToken(self.objId, message)
        for id in g_textField.getListToken():
            g_textField.rmovetoToken(id, y=-18)
        screen = GUI.screenResolution()
        center = ( screen[0] / 2, screen[1] / 2)
        g_textField.setPositionToken(self.objId, center[0] - 20, center[1] + 180)
        g_textField.activeToken(self.objId)
        BigWorld.callback(5.0, self.free)
    
    def free(self):
        g_textField.disposeToken(self.objId)
        print self.objId
        g_textField.freeToken(self.objId)



class TextField(object):
    def __init__(self):
        flash = Flash(SWF_FILE, path=SWF_PATH)
        flash.movie.backgroundAlpha = 0.0
        flash.movie.scaleMode = 'NoScale'
        flash.component.heightMode = 'PIXEL'
        flash.component.widthMode = 'PIXEL'
        flash.component.wg_inputKeyMode = 2
        flash.component.focus = False
        flash.component.moveFocus = False
        self.flash = flash
        
    def start(self):
        screen = GUI.screenResolution()
        center = ( screen[0] / 2, screen[1] / 2)
        self.setPosition(center[0] - 20, center[1] + 180)
        self.flash.active(True)
    
    def stop(self):
        self.flash.active(False)
    
    def setText(self, text):
        self.flash.movie.root.as_setText('')
        MessageToken(text)

    def setPosition(self, x, y):
        self.flash.movie.root.as_setPosition(x, y)

    def allocToken(self):
        return self.flash.movie.root.as_allocToken()
    
    def freeToken(self, id):
        self.flash.movie.root.as_freeToken(id)
        
    def getListToken(self):
        return self.flash.movie.root.as_getListToken()
        
    def setPositionToken(self, id, x, y):
        self.flash.movie.root.as_setPositionToken(id, x, y)
    
    def rmovetoToken(self, id, x=0, y=0):
        self.flash.movie.root.as_rmovetoToken(id, x, y)
    
    def setMessageToken(self, id, text):
        self.flash.movie.root.as_setMessageToken(id, text)
        
    def activeToken(self, id):
        self.flash.movie.root.as_activeToken(id)

    def disposeToken(self, id):
        self.flash.movie.root.as_disposeToken(id)
