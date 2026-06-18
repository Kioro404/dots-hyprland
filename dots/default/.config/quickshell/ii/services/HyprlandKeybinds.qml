pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

/**
 * A service that provides access to Hyprland keybinds matching jq output structure.
 */
Singleton {
    id: root

    property var keybinds: ({})
    property var rawKeybinds: []

    function refreshKeybinds() {
        bindsProcess.running = true
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "configreloaded") {
                root.refreshKeybinds()
            }
        }
    }

    Process {
        id: bindsProcess
        running: true
        command: ["hyprctl", "binds", "-j"]
        stdout: StdioCollector {
            id: bindsCollector
            onStreamFinished: {
                try {
                    root.rawKeybinds = JSON.parse(bindsCollector.text)
                    root.keybinds = root.processHyprBinds(root.rawKeybinds)
                } catch (e) {
                    console.error("[HyprlandKeybinds] Failed to parse hyprctl binds output:", e)
                }
            }
        }
    }

    function processHyprBinds(bindsArray) {
        var processed = {}
        if (!bindsArray || !Array.isArray(bindsArray)) return processed

        function getModifiers(mask) {
            var mods = []
            if (((mask / 64) | 0) % 2 === 1) mods.push("Super")
            if (((mask / 8)  | 0) % 2 === 1) mods.push("Alt")
            if (((mask / 4)  | 0) % 2 === 1) mods.push("Ctrl")
            if (((mask / 1)  | 0) % 2 === 1) mods.push("Shift")
            return mods
        }

        function safeKeyString(bind) {
            if (bind.key && bind.key !== "") return bind.key
            if (bind.keycode !== undefined && bind.keycode !== null) return "code:" + String(bind.keycode)
            return ""
        }

        for (var i = 0; i < bindsArray.length; i++) {
            var b = bindsArray[i]

            if (!b || !b.has_description) continue
            if (b.description === null || b.description === undefined) continue
            if (String(b.description).trim().length === 0) continue

            try {
                var mods = getModifiers(b.modmask)
                var keyStr = safeKeyString(b)
                if (!keyStr) continue

                var fullBind = mods.concat([keyStr])

                var payload = JSON.parse(b.description)

                var catKeys = Object.keys(payload)
                if (!catKeys.length) continue
                var cat = catKeys[0]

                var subPayload = payload[cat]
                var subKeys = Object.keys(subPayload || {})
                if (!subKeys.length) continue
                var subcat = subKeys[0]

                var descPayload = (subPayload || {})[subcat]
                var descKeys = Object.keys(descPayload || {})
                if (!descKeys.length) continue
                var desc = descKeys[0]

                if (!processed[cat]) processed[cat] = {}
                if (!processed[cat][subcat]) processed[cat][subcat] = {}
                if (!processed[cat][subcat][desc]) processed[cat][subcat][desc] = []
                
                processed[cat][subcat][desc].push(fullBind)
            } catch (e) {
                
            }
        }

        console.log(JSON.stringify(processed, null, 2))

        return processed
    }
}
