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


class SelectorView(View):
    def _populate(self):
        BigWorld.logInfo(MOD_NAME, '_populate', None)
        super(SelectorView, self)._populate()
