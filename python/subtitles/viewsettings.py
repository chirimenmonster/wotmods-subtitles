# -*- coding: utf-8 -*-

from gui.Scaleform.framework import ViewSettings, ViewTypes, ScopeTemplates
from subtitlesview import SubtitlesView

from modsettings import VIEW_ALIAS, SWF_FILE_PATH

VIEW_SETTINGS = ViewSettings(
    VIEW_ALIAS,
    SubtitlesView,
    SWF_FILE_PATH,
    ViewTypes.WINDOW,
    None,
    ScopeTemplates.DEFAULT_SCOPE
)
