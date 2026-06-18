pragma ComponentBehavior: Bound

import "periodic_table.js" as PTable
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    readonly property var elements: PTable.elements
    readonly property var series: PTable.series
    property real spacing: 6
    property real padding: 20

    implicitWidth: mainScrollView.implicitWidth
    implicitHeight: mainScrollView.implicitHeight

    ScrollView {
        id: mainScrollView
        anchors.fill: parent
        clip: true
        
        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        contentWidth: mainLayout.width + root.padding * 2
        contentHeight: mainLayout.height + root.padding * 2

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true 
            onPressed: (mouse) => mouse.accepted = false
            onReleased: (mouse) => mouse.accepted = false

            onWheel: (wheel) => {
                if (wheel.modifiers & Qt.ShiftModifier) {
                    if (wheel.angleDelta.y !== 0) {
                        mainScrollView.ScrollBar.horizontal.position = Math.max(
                            0, 
                            Math.min(
                                1 - mainScrollView.ScrollBar.horizontal.size, 
                                mainScrollView.ScrollBar.horizontal.position - (wheel.angleDelta.y / 120) * 0.05
                            )
                        );
                    }
                    wheel.accepted = true;
                } else {
                    wheel.accepted = false;
                }
            }
        }

        Column {
            id: mainLayout
            
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: root.padding
            anchors.leftMargin: root.padding
            spacing: root.spacing

            width: implicitWidth
            height: implicitHeight

            Repeater { // Main table rows
                model: root.elements
                
                delegate: Row { // Table cells
                    id: tableRow
                    spacing: root.spacing
                    required property var modelData
                    
                    Repeater {
                        model: tableRow.modelData
                        delegate: ElementTile {
                            required property var modelData
                            element: modelData
                        }
                    }
                }
            }

            Item {
                id: gap
                implicitHeight: 20
            }

            Repeater { // Main table rows
                model: root.series
                
                delegate: Row { // Table cells
                    id: seriesTableRow
                    spacing: root.spacing
                    required property var modelData
                    
                    Repeater {
                        model: seriesTableRow.modelData
                        delegate: ElementTile {
                            required property var modelData
                            element: modelData
                        }
                    }
                }
            }
        }
    }
}