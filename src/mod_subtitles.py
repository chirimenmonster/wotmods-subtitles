
import GUI
from debug_utils import LOG_CURRENT_EXCEPTION
from gui.IngameSoundNotifications import IngameSoundNotifications

g_text = None
g_active = False

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
    global g_active
    global g_text
    try:
        print eventName
        if not g_active:
            g_active = True
            GUI.addRoot(g_text)
            position = list(g_text.position)
            position[1] += 200
            print position
            g_text.position = tuple(position)
        g_text.text = eventName
    except:
        LOG_CURRENT_EXCEPTION()
    result = orig(self, eventName, *args, **kwargs)
    return result


def init():
    global g_text
    g_text = GUI.Text()
    g_text.colour = (255, 255, 0, 240)
    g_text.horizontalPositionMode = 'PIXEL'
    g_text.verticalPositionMode = 'PIXEL'
    g_text.widthMode = 'PIXEL'
    g_text.heightMode = 'PIXEL'
