import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.modules.common
import qs.modules.common.widgets
import qs.services

MouseArea {
    id: root
    hoverEnabled: true
    visible: Updates.updateAdvised || Updates.updateStronglyAdvised

    implicitWidth: 20
    implicitHeight: 20

    onClicked: {
        Quickshell.execDetached(["bash", "-c", Config.options.apps.update]);
    }

    MaterialSymbol {
        id: updateIcon
        text: "update"
        anchors.centerIn: parent
        color: Appearance.colors.colOnLayer0
        iconSize: Appearance.font.pixelSize.normal
    }

    PopupToolTip {
        id: tooltip
        text: Translation.tr("Get the latest features and security improvements with\nthe newest feature update.\n\n%1 packages").arg(Updates.count)
        extraVisibleCondition: root.containsMouse
        alternativeVisibleCondition: extraVisibleCondition
        anchorEdges: (!Config.options.bar.bottom && !Config.options.bar.vertical) ? Edges.Bottom : Edges.Top
    }
}