import qs.modules.common.widgets
import qs.services

QuickToggleButton {
    id: root
    toggled: Config.options?.battery?.idleInhibit
    buttonIcon: "coffee"
    onClicked: {
        Idle.toggleInhibit()
    }
    StyledToolTip {
        text: Translation.tr("Keep system awake")
    }

}
