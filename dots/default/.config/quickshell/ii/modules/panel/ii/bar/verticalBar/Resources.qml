import qs.services
import qs.modules.common
import QtQuick
import QtQuick.Layouts
import qs.modules.panel.ii.bar.horizontalBar as HorizontalBar

MouseArea {
    id: root
    property bool alwaysShowAllResources: false
    implicitHeight: columnLayout.implicitHeight
    implicitWidth: columnLayout.implicitWidth
    hoverEnabled: !Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.tooltips.clickToShow

    ColumnLayout {
        id: columnLayout
        spacing: 10
        anchors.fill: parent

        Resource {
            Layout.alignment: Qt.AlignHCenter
            iconName: "memory"
            percentage: ResourceUsage.memoryUsedPercentage
            warningThreshold: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.resources.memoryWarningThreshold
        }

        Resource {
            Layout.alignment: Qt.AlignHCenter
            iconName: "swap_horiz"
            percentage: ResourceUsage.swapUsedPercentage
            warningThreshold: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.resources.swapWarningThreshold
        }

        Resource {
            Layout.alignment: Qt.AlignHCenter
            iconName: "planner_review"
            percentage: ResourceUsage.cpuUsage
            warningThreshold: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.resources.cpuWarningThreshold
        }

    }

    HorizontalBar.ResourcesPopup {
        hoverTarget: root
    }
}
