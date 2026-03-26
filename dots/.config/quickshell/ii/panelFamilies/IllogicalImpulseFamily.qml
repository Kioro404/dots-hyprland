import QtQuick
import Quickshell

import qs.modules.common
import qs.modules.panel.ii.background
import qs.modules.panel.ii.cheatsheet
import qs.modules.panel.ii.dock
import qs.modules.panel.ii.lock
import qs.modules.panel.ii.mediaControls
import qs.modules.panel.ii.notificationPopup
import qs.modules.panel.ii.onScreenDisplay
import qs.modules.panel.ii.onScreenKeyboard
import qs.modules.panel.ii.overview
import qs.modules.panel.ii.polkit
import qs.modules.panel.ii.regionSelector
import qs.modules.panel.ii.screenCorners
import qs.modules.panel.ii.sessionScreen
import qs.modules.panel.ii.sidebarLeft
import qs.modules.panel.ii.sidebarRight
import qs.modules.panel.ii.overlay
import qs.modules.panel.ii.bar.horizontalBar
import qs.modules.panel.ii.bar.verticalBar
import qs.modules.panel.ii.wallpaperSelector

Scope {
    PanelLoader { component: Background {} }
    PanelLoader { extraCondition: !Config.options.bar.vertical; component: Bar {} }
    PanelLoader { extraCondition: Config.options.bar.vertical; component: VerticalBar {} }
    PanelLoader { component: Cheatsheet {} }
    PanelLoader { extraCondition: Config.options.dock.enable; component: Dock {} }
    PanelLoader { component: Lock {} }
    PanelLoader { component: MediaControls {} }
    PanelLoader { component: NotificationPopup {} }
    PanelLoader { component: OnScreenDisplay {} }
    PanelLoader { component: OnScreenKeyboard {} }
    PanelLoader { component: Overlay {} }
    PanelLoader { component: Overview {} }
    PanelLoader { component: Polkit {} }
    PanelLoader { component: RegionSelector {} }
    PanelLoader { component: ScreenCorners {} }
    PanelLoader { component: SessionScreen {} }
    PanelLoader { component: SidebarLeft {} }
    PanelLoader { component: SidebarRight {} }
    PanelLoader { component: WallpaperSelector {} }
}
