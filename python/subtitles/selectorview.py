# -*- coding: utf-8 -*-

import logging
from functools import partial

import BigWorld
import ResMgr
import GUI
import SoundGroups
import WWISE
from gui.Scaleform.framework import ViewSettings, ViewTypes, ScopeTemplates
from gui.Scaleform.framework.entities.View import View

from gui.IngameSoundNotifications import IngameSoundNotifications

from modsettings import MOD_NAME

for name in [ 'gui.Scalform.framework.entities.View', 'gui.Scaleform.Flash' ]:
    logging.getLogger(name).setLevel(logging.DEBUG)
_logger = logging.getLogger(__name__)
_logger.setLevel(logging.DEBUG)


class SelectorView(View):
    __CFG_SECTION_PATH = 'gui/sound_notifications.xml'

    def __init__(self):
        super(SelectorView, self).__init__()
        self.__readConfig()
    
    def _populate(self):
        BigWorld.logInfo(MOD_NAME, '_populate', None)
        self.flashObject.as_setConfig(self.__events)
        super(SelectorView, self)._populate()

    def __readConfig(self):
        sec = ResMgr.openSection(self.__CFG_SECTION_PATH)
        events = []
        print sec.keys()
        for eventSec in sec.values():
            print eventSec.keys()
            for category in ('voice', ):
                soundSec = eventSec[category]
                if soundSec is not None:
                    print soundSec.readString('wwsound')
                    events.append(soundSec.readString('wwsound'))
        self.__events = events
        print events
        return

    def getConfig(self):
        return self.__events;
    
    def onButtonClickS(self, label):
        print 'onButtonClickS: {}'.format(label);
        play(label)
        #BigWorld.callback(1.0, partial(play, label));


def play(soundPath):
    masterVolume = SoundGroups.g_instance.getMasterVolume()
    print 'soundPath={}, volume={}, {}'.format(soundPath, masterVolume, SoundGroups.g_instance.getVolume('gui'))
    #SoundGroups.g_instance.enableLobbySounds(True)
    #SoundGroups.g_instance.enableArenaSounds(True)
    #SoundGroups.g_instance.enableVoiceSounds(True)
    #sound = SoundGroups.g_instance.getSound2D(soundPath)
    #if sound is not None:
    #    sound.setCallback(onSoundEnd)
    #    BigWorld.callback(0.1, sound.play)
    #    print 'soundPath={}, sound={}, volume={}, {}'.format(soundPath, sound, masterVolume, SoundGroups.g_instance.getVolume('gui'))
    SoundGroups.g_instance.playSound2D(soundPath)

def onSoundEnd():
    print 'onSoundEnd'
