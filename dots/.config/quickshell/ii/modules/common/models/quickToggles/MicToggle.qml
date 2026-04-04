import QtQuick
import Quickshell
import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

QuickToggleModel {
    name: Translation.tr("%1 input").arg(Translation.tr("Audio"))
    statusText: toggled ? Translation.tr("Enabled") : Translation.tr("Muted")
    toggled: !Audio.source?.audio?.muted
    icon: Audio.source?.audio?.muted ? "mic_off" : "mic"
    mainAction: () => {
        Audio.toggleMicMute()
    }
    hasMenu: true

    tooltipText: Translation.tr("Audio %1 | Right-click for volume mixer & device selector").arg(Translation.tr("Input"))
}
