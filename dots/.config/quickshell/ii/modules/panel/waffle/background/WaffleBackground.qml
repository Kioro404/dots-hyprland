pragma ComponentBehavior: Bound

import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.widgets.widgetCanvas
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.modules.panel.ii.background.widgets
import qs.modules.panel.ii.background.widgets.clock
import qs.modules.panel.ii.background.widgets.weather

Variants {
    id: root
    model: Quickshell.screens

    PanelWindow {
        id: panelRoot
        required property var modelData

        screen: modelData
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.namespace: "quickshell:background"
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent"

        property HyprlandMonitor monitor: Hyprland.monitorFor(modelData)
        property var monitorBackground: {
            const monitor = Config.options.monitor.find(m => m.output.screen.name === monitor.name);
            return monitor?.output.background || Appearance.activeMonitorBackground;
        }

        StyledImage {
            anchors.fill: parent
            source: monitorBackground.wallpaperPath
            fillMode: Image.PreserveAspectCrop
        }
    }
}
