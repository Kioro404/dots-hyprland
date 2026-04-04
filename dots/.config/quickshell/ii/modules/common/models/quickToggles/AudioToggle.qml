import QtQuick
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

QuickToggleModel {
    name: Translation.tr("%1 output").arg(Translation.tr("Audio"))
    statusText: toggled ? Translation.tr("Unmuted") : Translation.tr("Muted")
    tooltipText: Translation.tr("Audio %1 | Right-click for volume mixer & device selector").arg(Translation.tr("Output"))
    toggled: !Audio.sink?.audio?.muted
    icon: Audio.sink?.audio?.muted ? "volume_off" : "volume_up"
    mainAction: () => {
        Audio.toggleMute()
    }
    hasMenu: true
}
