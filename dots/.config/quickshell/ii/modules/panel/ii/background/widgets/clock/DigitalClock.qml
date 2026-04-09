pragma ComponentBehavior: Bound

import qs.services
import qs.modules.common
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: clockColumn
    spacing: 0
    
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

    ColumnLayout {
        spacing: - (timeLoader.height * 0.08)
        Layout.alignment: Qt.AlignHCenter

        // Time
        Loader {
            id: timeLoader
            Layout.alignment: Qt.AlignHCenter
            sourceComponent: clockColumn.isVertical ? verticalTimeComponent : horizontalTimeComponent
        }

        // Date and quote
        Loader {
            id: dateQuoteLoader
            Layout.alignment: Qt.AlignHCenter
            sourceComponent: dateQuoteComponent
        }
    }

    Component {
        id: verticalTimeComponent
        ColumnLayout {
            spacing: - (Math.max(hourVDigits.height, minuteVDigits.height) * 0.3)
            TimeDigits {
                id: hourVDigits
                value: DateTime.clock.hours
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
            }
            TimeDigits {
                id: minuteVDigits
                value: DateTime.clock.minutes
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    Component {
        id: horizontalTimeComponent
        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            TimeDigits {
                id: hourHDigits
                value: DateTime.clock.hours
            }
            ClockText {
                text: ":"
                color: clockColumn.colText
                horizontalAlignment: clockColumn.textHorizontalAlignment
                font.family: Config.options.background.widgets.clock.digital.font.family
                font.pixelSize: Config.options.background.widgets.clock.digital.font.size
                font.weight: Config.options.background.widgets.clock.digital.font.weight
            }
            TimeDigits {
                id: minuteHDigits
                value: DateTime.clock.minutes
            }
        }
    }

    Component {
        id: dateQuoteComponent

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true

            ClockText {
                visible: Config.options.background.widgets.clock.digital.showDate
                Layout.alignment: Qt.AlignHCenter
                text: DateTime.longDate
                color: clockColumn.colText
                horizontalAlignment: Text.AlignHCenter
            }

            ClockText {
                visible: Config.options.background.widgets.clock.quote.enable && Config.options.background.widgets.clock.quote.text.length > 0
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: Appearance.font.pixelSize.normal
                text: Config.options.background.widgets.clock.quote.text
                animateChange: false
                color: clockColumn.colText
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}