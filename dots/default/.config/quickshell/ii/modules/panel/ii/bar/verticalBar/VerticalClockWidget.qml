import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import qs.modules.panel.ii.bar.horizontalBar as HorizontalBar

Item {
    id: root
    property bool borderless: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.borderless
    implicitHeight: clockColumn.implicitHeight
    implicitWidth: Appearance.sizes.verticalBarWidth

    ColumnLayout {
        id: clockColumn
        anchors.centerIn: parent
        spacing: 0

        Repeater {
            model: DateTime.time.split(/[: ]/)
            delegate: StyledText {
                required property string modelData
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: modelData.match(/am|pm/i) ? 
                    Appearance.font.pixelSize.smaller // Smaller "am"/"pm" text
                    : Appearance.font.pixelSize.large
                color: Appearance.colors.colOnLayer1
                text: modelData.padStart(2, "0")
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: !Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.tooltips.clickToShow

        HorizontalBar.ClockWidgetPopup {
            hoverTarget: mouseArea
        }
    }
}
