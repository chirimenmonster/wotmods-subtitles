# -*- coding: utf-8 -*-

from gui.Scaleform.framework import ViewSettings, ViewTypes, ScopeTemplates
from subtitlesview import SubtitlesView
from selectorview import SelectorView

from modsettings import VIEW_ALIAS, SWF_FILE_PATH, SELECTOR_VIEW_ALIAS, SELECTOR_SWF_FILE_PATH

VIEW_SETTINGS = ViewSettings(
    VIEW_ALIAS,
    SubtitlesView,
    SWF_FILE_PATH,
    ViewTypes.WINDOW,
    None,
    ScopeTemplates.DEFAULT_SCOPE
)

SELECTOR_VIEW_SETTINGS = ViewSettings(
    SELECTOR_VIEW_ALIAS,
    SelectorView,
    SELECTOR_SWF_FILE_PATH,
    ViewTypes.WINDOW,
    None,
    ScopeTemplates.DEFAULT_SCOPE
)
