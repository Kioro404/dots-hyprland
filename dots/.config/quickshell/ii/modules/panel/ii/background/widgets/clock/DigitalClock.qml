pragma ComponentBehavior: Bound

import qs.services
import qs.modules.common
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: clockColumn
    spacing: 0
    
    property bool isVertical: Config.options && Appearance.activeMonitorBackground && Appearance.activeMonitorBackground.widgets && Appearance.activeMonitorBackground.widgets.clock && Appearance.activeMonitorBackground.widgets.clock.digital && Appearance.activeMonitorBackground.widgets.clock.digital.vertical ? Appearance.activeMonitorBackground.widgets.clock.digital.vertical : false
    property color colText: Appearance.colors.colOnSecondaryContainer
    property var textHorizontalAlignment: Text.AlignHCenter

    component TimeDigits: Row {
        id: timeDigits
        property int value: 0
        property color textColor: clockColumn.colText
        property var alignment: clockColumn.textHorizontalAlignment
        property int fontSize: Appearance.activeMonitorBackground.widgets.clock.digital.font.size
        property int fontWeight: Appearance.activeMonitorBackground.widgets.clock.digital.font.weight
        property string fontFamily: Appearance.activeMonitorBackground.widgets.clock.digital.font.family
        property var fontAxes: ({
                "wdth": Appearance.activeMonitorBackground.widgets.clock.digital.font.width,
                "ROND": Appearance.activeMonitorBackground.widgets.clock.digital.font.roundness
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
            sourceComponent: dateQuote
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
                font.family: Appearance.activeMonitorBackground.widgets.clock.digital.font.family
                font.pixelSize: Appearance.activeMonitorBackground.widgets.clock.digital.font.size
                font.weight: Appearance.activeMonitorBackground.widgets.clock.digital.font.weight
            }
            TimeDigits {
                id: minuteHDigits
                value: DateTime.clock.minutes
            }
        }
    }

    Component {
        id: dateQuote
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true

            ClockText {
                visible: Appearance.activeMonitorBackground.widgets.clock.digital.showDate
                Layout.alignment: Qt.AlignHCenter
                text: DateTime.longDate
                color: clockColumn.colText
                horizontalAlignment: Text.AlignHCenter
            }

            ClockText {
                visible: Appearance.activeMonitorBackground.widgets.clock.quote.enable && Appearance.activeMonitorBackground.widgets.clock.quote.text.length > 0
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: Appearance.font.pixelSize.normal
                text: Appearance.activeMonitorBackground.widgets.clock.quote.text
                animateChange: false
                color: clockColumn.colText
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}