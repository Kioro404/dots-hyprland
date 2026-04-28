pragma Singleton
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Wayland

/**
 * A nice wrapper for date and time strings.
 */
Singleton {
    id: root

    Connections {
        target: Persistent
        function onReadyChanged() {
            if (!Persistent.isNewHyprlandInstance) Config.setNestedValue("battery.idleInhibit", Persistent.states.idle.inhibit);
            else Persistent.states.idle.inhibit = Config.options?.battery?.idleInhibit ?? false;
        }
    }

    function toggleInhibit(active = null) {
        const newValue = active !== null ? active : !(Config.options?.battery?.idleInhibit ?? false);
        Config.setNestedValue("battery.idleInhibit", newValue);
        Persistent.states.idle.inhibit = newValue;
    }

    IdleInhibitor {
        id: idleInhibitor
        enabled: Config.options?.battery?.idleInhibit ?? false
        window: PanelWindow {
            // Inhibitor requires a "visible" surface
            // Actually not lol
            implicitWidth: 0
            implicitHeight: 0
            color: "transparent"
            // Just in case...
            anchors {
                right: true
                bottom: true
            }
            // Make it not interactable
            mask: Region {
                item: null
            }
        }
    }
}
