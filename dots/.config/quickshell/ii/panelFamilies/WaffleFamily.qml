import QtQuick
import Quickshell

import qs.modules.common
import qs.modules.panel.waffle.actionCenter
import qs.modules.panel.waffle.background
import qs.modules.panel.waffle.bar
import qs.modules.panel.waffle.lock
import qs.modules.panel.waffle.notificationCenter
import qs.modules.panel.waffle.notificationPopup
import qs.modules.panel.waffle.onScreenDisplay
// import qs.modules.panel.waffle.overlay
import qs.modules.panel.waffle.polkit
import qs.modules.panel.waffle.screenSnip
import qs.modules.panel.waffle.startMenu
import qs.modules.panel.waffle.sessionScreen
import qs.modules.panel.waffle.taskView

// Fallbacks
import qs.modules.panel.ii.cheatsheet
import qs.modules.panel.ii.onScreenKeyboard
import qs.modules.panel.ii.overlay
import qs.modules.panel.ii.wallpaperSelector

Scope {
    PanelLoader { component: WaffleActionCenter {} }
    PanelLoader { component: WaffleBar {} }
    PanelLoader { component: WaffleBackground {} }
    PanelLoader { component: WaffleLock {} }
    PanelLoader { component: WaffleNotificationCenter {} }
    PanelLoader { component: WaffleNotificationPopup {} }
    PanelLoader { component: WaffleOSD {} }
    // PanelLoader { component: WaffleOverlay {} }
    PanelLoader { component: WafflePolkit {} }
    PanelLoader { component: WScreenSnip {} }
    PanelLoader { component: WaffleStartMenu {} }
    PanelLoader { component: WaffleSessionScreen {} }
    PanelLoader { component: WaffleTaskView {} }

    PanelLoader { component: Cheatsheet {} }
    PanelLoader { component: OnScreenKeyboard {} }
    PanelLoader { component: Overlay {} }
    PanelLoader { component: WallpaperSelector {} }
}
