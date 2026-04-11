import QtQuick
import QtQuick.Layouts
import qs.modules.common

WToolbarButton {
    id: root
    override property real implicitWidth: height
    contentItem: Item {
        FluentIcon {
            anchors.centerIn: parent
            icon: root.icon.name
            implicitSize: 18
            color: root.fgColor
        }
    }
}
