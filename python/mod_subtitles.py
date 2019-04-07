
import json
import re
import struct
import weakref

import BigWorld
import GUI
import ResMgr
import game
import Keys
from debug_utils import LOG_CURRENT_EXCEPTION
from gui.shared import g_eventBus, events
from gui.app_loader import g_appLoader
from gui.app_loader.settings import APP_NAME_SPACE
from gui.Scaleform.framework import g_entitiesFactories
from gui.Scaleform.framework.entities.View import View, ViewKey
from gui.Scaleform.framework.managers.loaders import SFViewLoadParams
from gui.IngameSoundNotifications import IngameSoundNotifications

from subtitles.modsettings import MOD_NAME, SOUNDINFO, VIEW_ALIAS, SELECTOR_VIEW_ALIAS
from subtitles.viewsettings import VIEW_SETTINGS, SELECTOR_VIEW_SETTINGS


ignore_event_patterns = [
    ".*_ribbon",
    "chat_shortcut_common_fx"
]

g_soundInfo = None

def overrideMethod(cls, method):
    def decorator(handler):
        orig = getattr(cls, method)
        newm = lambda *args, **kwargs: handler(orig, *args, **kwargs)
        if type(orig) is not property:
            setattr(cls, method, newm)
        else:
            setattr(cls, method, property(newm))
    return decorator


@overrideMethod(game, 'handleKeyEvent')
def _handleKeyEvent(orig, event):
    ret = orig(event)
    try:
        if event.isKeyDown() and not event.isRepeatedEvent():
            if event.key == Keys.KEY_F12:
                print '### press F12'
                g_selector.start()
    except:
        LOG_CURRENT_EXCEPTION()
    return ret


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
        g_control.sendMessage(text)
        BigWorld.logInfo(MOD_NAME, 'eventName={}, soundPath={}, text={}'.format(eventName, soundPath, text), None)
    return result

def _getSoundText(eventName):
    sec = g_soundInfo.get(eventName, None)
    soundPath = text = None
    if sec:
        soundPath = sec['soundPath']
        description = sec['description']
        if sec['text'] and sec['text'] is not None:
            text = sec['text'][0]
    return soundPath, text


def cvt(d):
    return struct.pack('B', d) if d < 256 else unichr(d)

def _readSoundInfo():
    database = {}
    section = ResMgr.openSection(SOUNDINFO)
    if section is None:
        BigWorld.logInfo(MOD_NAME, 'file not found: {}'.format(SOUNDINFO), None)
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
    return database


def init():
    global g_soundInfo
    g_soundInfo = _readSoundInfo()
    g_entitiesFactories.addSettings(VIEW_SETTINGS)
    g_entitiesFactories.addSettings(SELECTOR_VIEW_SETTINGS)
    g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZED, g_control.onAppInitialized)

class Control(object):
    def onAppInitialized(self, event):
        if event.ns != APP_NAME_SPACE.SF_BATTLE:
            return
        BigWorld.logInfo(MOD_NAME, 'AppLifeCycleEvent.INITIALIZED', None)
        battleEntry = g_appLoader.getDefBattleApp()
        if not battleEntry:
            return
        battleEntry.loadView(SFViewLoadParams(VIEW_ALIAS))
        pyEntity = battleEntry.containerManager.getViewByKey(ViewKey(VIEW_ALIAS))
        self.__pyEntity = weakref.proxy(pyEntity)
        BigWorld.logInfo(MOD_NAME, 'pyEntity: {}'.format(pyEntity), None)

    def sendMessage(self, message):
        if self.__pyEntity:
            self.__pyEntity.as_setMessageS(message)


class Selector(object):
    def start(self):
        app = g_appLoader.getDefLobbyApp()
        if not app:
            return
        app.loadView(SFViewLoadParams(SELECTOR_VIEW_ALIAS))
        pyEntity = app.containerManager.getViewByKey(ViewKey(SELECTOR_VIEW_ALIAS))
        self.__pyEntity = weakref.proxy(pyEntity)
        BigWorld.logInfo(MOD_NAME, 'pyEntity: {}'.format(pyEntity), None)


g_control = Control()
g_selector = Selector()
