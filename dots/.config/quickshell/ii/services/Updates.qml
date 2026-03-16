pragma Singleton

import qs.modules.common
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Io

/*
 * System updates service. Currently only supports Arch.
 */
Singleton {
    id: root

    property bool available: false
    property alias checking: checkUpdatesProc.running
    property int count: 0
    property int lastCount: 0
    
    readonly property bool updateAdvised: available && count > Config.options.updates.adviseUpdateThreshold
    readonly property bool updateStronglyAdvised: available && count > Config.options.updates.stronglyAdviseUpdateThreshold

    function load() {}
    function refresh() {
        if (!available) return;
        print("[Updates] Checking for system updates")
        checkUpdatesProc.running = true;
    }

    Timer {
        id: periodicCheckTimer
        interval: 21600000 // 6 hours
        repeat: true
        running: Config.ready && Config.options.updates.enableCheck
        onTriggered: {
            print("[Updates] Periodic update check due")
            root.refresh();
        }
    }

    Process {
        id: checkAvailabilityProc
        running: false
        command: ["which", "checkupdates"]
        onExited: (exitCode, exitStatus) => {
            root.available = (exitCode === 0);
            root.refresh();
        }
    }

    Timer {
        id: initialCheckTimer
        interval: 10000 // seconds
        repeat: false
        running: Config.ready && Config.options.updates.enableCheck
        onTriggered: checkAvailabilityProc.running = true
    }

    Process {
        id: checkUpdatesProc
        command: ["bash", "-c", "checkupdates | wc -l"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.count = parseInt(text.trim());
                if (root.count > 0 && root.lastCount == 0)
                    // Quickshell.execDetached(["notify-send", Translation.tr("Updates"), Translation.tr("There are %1 updates available").arg(root.count), "-a", "Shell"]);
                    Quickshell.execDetached(["notify-send", "-A", "update=" + Translation.tr("Update"), Translation.tr("Updates"), Translation.tr("There are %1 updates available").arg(root.count), "-a", "Shell", '--action-click="update=kitty -e sudo pacman -Syu && exit 0"']);
                root.lastCount = root.count;
            }
        }
    }
}
