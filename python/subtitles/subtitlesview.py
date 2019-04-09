# -*- coding: utf-8 -*-

import logging

import BigWorld
import GUI
from gui.Scaleform.framework import ViewSettings, ViewTypes, ScopeTemplates
from gui.Scaleform.framework.entities.View import View

from modsettings import MOD_NAME

for name in [ 'gui.Scalform.framework.entities.View', 'gui.Scaleform.Flash' ]:
    logging.getLogger(name).setLevel(logging.DEBUG)
_logger = logging.getLogger(__name__)
_logger.setLevel(logging.DEBUG)


class SubtitlesView(View):

    def __onLogGui(self, logType, msg, *kargs):
        _logger.debug('%s.GUI: %r, %r', str(logType), msg, kargs)

    def __onLogGuiFormat(self, logType, msg, *kargs):
        _logger.debug('%s.GUI: %s', str(logType), msg % kargs)

    def afterCreate(self):
        self.addExternalCallback('debug.LOG_GUI', self.__onLogGui)
        self.addExternalCallback('debug.LOG_GUI_FORMAT', self.__onLogGuiFormat)

    def _populate(self):
        BigWorld.logInfo(MOD_NAME, '_populate', None)
        super(SubtitlesView, self)._populate()
        screen = GUI.screenResolution()
        center = ( screen[0] / 2, screen[1] / 2)
        BigWorld.logInfo(MOD_NAME, '({}, {}), width={}, height={}'.format(center[0], center[1], screen[0], screen[1]), None)
        self.as_setPositionS(center[0] - 100, center[1] + 280)
    
    def as_setMessageS(self, message):
        BigWorld.logInfo(MOD_NAME, 'as_setMessageS: {}'.format(message), None)
        self.flashObject.as_setMessage(message)

    def as_setPositionS(self, x, y):
        BigWorld.logInfo(MOD_NAME, 'as_setPositionS: ({}, {})'.format(x, y), None)
        self.flashObject.as_setPosition(x, y)
