pragma ComponentBehavior: Bound

import qs.services
import qs.modules.common
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: clockColumn
    spacing: 4

    property bool isVertical: Config.options.background.widgets.clock.digital.vertical
    property color colText: Appearance.colors.colOnSecondaryContainer
    property var textHorizontalAlignment: Text.AlignHCenter

    component TimeDigits: Row {
        id: timeDigits
        property int value: 0
        property color textColor: clockColumn.colText
        property var alignment: clockColumn.textHorizontalAlignment
        property int fontSize: Config.options.background.widgets.clock.digital.font.size
        property int fontWeight: Config.options.background.widgets.clock.digital.font.weight
        property string fontFamily: Config.options.background.widgets.clock.digital.font.family
        property var fontAxes: ({
                "wdth": Config.options.background.widgets.clock.digital.font.width,
                "ROND": Config.options.background.widgets.clock.digital.font.roundness
            })
        spacing: 0

        ClockText {
            text: Math.floor(timeDigits.value / 10).toString()
            color: timeDigits.textColor
            horizontalAlignment: timeDigits.alignment
            font {
                pixelSize: timeDigits.fontSize
                weight: timeDigits.fontWeight
                family: timeDigits.fontFamily
                variableAxes: timeDigits.fontAxes
            }
        }
        ClockText {
            text: (timeDigits.value % 10).toString()
            color: timeDigits.textColor
            horizontalAlignment: timeDigits.alignment
            font {
                pixelSize: timeDigits.fontSize
                weight: timeDigits.fontWeight
                family: timeDigits.fontFamily
                variableAxes: timeDigits.fontAxes
            }
        }
    }

    // Time
    Loader {
        id: timeLoader
        Layout.fillWidth: true
        sourceComponent: clockColumn.isVertical ? verticalTimeComponent : horizontalTimeComponent
    }

    Component {
        id: verticalTimeComponent
        ColumnLayout {
            spacing: 4
            TimeDigits {
                value: DateTime.clock.hours
                Layout.alignment: Qt.AlignHCenter
            }
            TimeDigits {
                value: DateTime.clock.minutes
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: -40
            }
        }
    }

    Component {
        id: horizontalTimeComponent
        Row {
            spacing: 0
            anchors.horizontalCenter: parent.horizontalCenter
            TimeDigits {
                value: DateTime.clock.hours
            }
            ClockText {
                text: ":"
                color: clockColumn.colText
                horizontalAlignment: clockColumn.textHorizontalAlignment
                font {
                    pixelSize: Config.options.background.widgets.clock.digital.font.size
                    weight: Config.options.background.widgets.clock.digital.font.weight
                    family: Config.options.background.widgets.clock.digital.font.family
                    variableAxes: ({
                            "wdth": Config.options.background.widgets.clock.digital.font.width,
                            "ROND": Config.options.background.widgets.clock.digital.font.roundness
                        })
                }
            }
            TimeDigits {
                value: DateTime.clock.minutes
            }
        }
    }

    // Date
    ClockText {
        visible: Config.options.background.widgets.clock.digital.showDate
        Layout.topMargin: -20
        Layout.fillWidth: true
        text: DateTime.longDate
        color: clockColumn.colText
        horizontalAlignment: clockColumn.textHorizontalAlignment
    }

    // Quote
    ClockText {
        visible: Config.options.background.widgets.clock.quote.enable && Config.options.background.widgets.clock.quote.text.length > 0
        font.pixelSize: Appearance.font.pixelSize.normal
        text: Config.options.background.widgets.clock.quote.text
        animateChange: false
        color: clockColumn.colText
        horizontalAlignment: clockColumn.textHorizontalAlignment
    }
}
