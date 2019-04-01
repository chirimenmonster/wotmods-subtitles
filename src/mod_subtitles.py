
import json
import re
import struct

import BigWorld
import GUI
import ResMgr
from debug_utils import LOG_CURRENT_EXCEPTION
from gui.IngameSoundNotifications import IngameSoundNotifications
from gui.Scaleform.Flash import Flash
from PlayerEvents import g_playerEvents

MOD_NAME = 'subtitles'
SWF_FILE = 'ShowText.swf'
SWF_PATH = '${flash_dir}'
SOUNDINFO = '${resource_dir}/sound.json'
SOUNDINFO2 = '${resource_dir}/sound_text.xml'


ignore_event_patterns = [
    ".*_ribbon",
    "chat_shortcut_common_fx"
]

g_textField = None
g_soundInfo = None
g_soundInfo2 = None

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
    BigWorld.logInfo(MOD_NAME, 'eventName: {}'.format(eventName), None)
    result = orig(self, eventName, *args, **kwargs)
    event = self._IngameSoundNotifications__events.get(eventName, None)
    for category, soundDesc in event.iteritems():
        if category not in ('fx', 'voice') or soundDesc['sound'] == '':
            continue
        soundPath = soundDesc['sound']
        _, text = _getSoundText(eventName)
        if not text:
            for pattern in ignore_event_patterns:
                if re.match(pattern, eventName):
                    return
            text = '({})'.format(soundPath) if soundPath else '[{}]'.format(eventName)
        if g_textField:
            g_textField.setText(text)
        BigWorld.logInfo(MOD_NAME, 'eventName={}, soundPath={}, text={}'.format(eventName, soundPath, text), None)
    return result
    
    try:
        BigWorld.logInfo(MOD_NAME, 'eventName: {}'.format(eventName), None)
        event = self._IngameSoundNotifications__events.get(eventName, None)
        ignore = False
        for pattern in g_soundInfo['ignore_event_patterns']:
            if re.match(pattern, eventName):
                ignore = True
                break
        for category, soundDesc in event.iteritems():
            if category not in ('fx', 'voice') or soundDesc['sound'] == '':
                continue
            soundPath = soundDesc['sound']
            if soundPath in g_soundInfo['sound_texts']:
                text = g_soundInfo['sound_texts'][soundPath][0]
            else:
                if ignore:
                    continue
                text = '({})'.format(soundPath)
            if g_textField:
                g_textField.setText(text)
            BigWorld.logInfo(MOD_NAME, 'soundPath={}, text="{}"'.format(soundPath, text), None)
    except:
        LOG_CURRENT_EXCEPTION()
    return result


def _getSoundText(eventName):
    sec = g_soundInfo2.get(eventName, None)
    soundPath = text = None
    if sec:
        soundPath = sec['soundPath']
        description = sec['description']
        if sec['text'] and sec['text'] is not None:
            text = sec['text'][0]
    return soundPath, text

def _readSoundInfo():
    def encode_key(data):
        ascii_encode = lambda x: x.encode('ascii') if isinstance(x, unicode) else x
        return dict({ ascii_encode(key): value for key, value in data.items() })
    BigWorld.logInfo(MOD_NAME, 'load config file: {}'.format(SOUNDINFO), None)
    section = ResMgr.openSection(SOUNDINFO)
    return json.loads(section.asString, object_hook=encode_key)

def cvt(d):
	return struct.pack('B', d) if d < 256 else unichr(d)

def _readSoundInfo2():
    database = {}
    section = ResMgr.openSection(SOUNDINFO2)
    if section is None:
        BigWorld.logInfo(MOD_NAME, 'file not found: {}'.format(SOUNDINFO2), None)
    for sec in section.values():
        voice = sec['voice']
        if voice is None:
            continue
        eventName = sec.name
        soundPath = voice['wwsound'].asString
        description = voice['description'] if voice['description'] is not None else None
        if voice['sentences'] is not None:
            texts = []
            for v in voice['sentences'].values():
                text = v.asBinary
                text = re.sub(r'&#(\d+);', lambda m: cvt(int(m.group(1))), text)
                text = text.decode()
                text = re.sub(r'<root>\s*(.*)\s*</root>', r'\1', text, re.DOTALL)
                text = re.sub(r'\s*(<[^>]+>)\s*', r'\1', text, re.DOTALL)
                text = re.sub(r'\A\s+', '', text, re.DOTALL)
                text = re.sub(r'\s+\Z', '', text, re.DOTALL)
                texts.append(text)
        else:
            texts = None
        database[eventName] = {
            'eventName':    eventName,
            'soundPath':    soundPath,
            'description':  description,
            'text':         texts
        }
    print database
    return database


def init():
    global g_soundInfo
    global g_soundInfo2
    global g_textField
    g_soundInfo = _readSoundInfo()
    g_soundInfo2 = _readSoundInfo2()
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
        g_textField.setPositionToken(self.objId, center[0] - 80, center[1] + 180)
        g_textField.activeToken(self.objId)
        BigWorld.callback(5.0, self.free)
    
    def free(self):
        g_textField.disposeToken(self.objId)
        #print self.objId
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
        self.setPosition(center[0] - 80, center[1] + 180)
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
