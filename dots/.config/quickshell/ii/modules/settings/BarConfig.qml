import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    ConfigSwitch {
        id: panelSwitch
        buttonIcon: "toast"
        iconRotation: 180
        text: Translation.tr("Enable %1").arg(Translation.tr("Bar").toLowerCase())
        checked: !Config.options.panel.disabled
        onCheckedChanged: {
            Config.options.panel.disabled = !checked;
        }
    }

    ContentSection {
        visible: panelSwitch.checked

        // ContentSection {
        //     icon: "family_restroom"
        //     title: Translation.tr("Panel family")

        //     ColumnLayout {
        //         ConfigSelectionArray {
        //             id: panelFamilyOptions
        //             currentValue: Config.options.panel.tools.findIndex(tool => tool.bar.name === Config.options.panel.family);
        //             onSelected: index => {
        //                 Config.options.panel.family = Config.options.panel.tools[index].bar.name;
        //             }
        //             options: Config.options.panel.tools.map((tool, index) => {
        //                 return {
        //                     displayName: tool.bar.name,
        //                     value: index
        //                 };
        //             })
        //         }
        //     }
        // }

        ContentSection {
            icon: "family_restroom"
            title: Translation.tr("Panel family")

            ColumnLayout {
                ConfigSelectionArray {
                    id: panelFamilyOptions
                    
                    currentValue: {
                        let tools = Config.options?.panel?.tools;
                        if (!tools) return 0;
                        let idx = tools.findIndex(tool => tool.bar.name === Config.options.panel.family);
                        return idx !== -1 ? idx : 0;
                    }

                    onSelected: index => {
                        if (Config.options?.panel?.tools[index]) {
                            Config.options.panel.family = Config.options.panel.tools[index].bar.name;
                        }
                    }

                    options: {
                        let tools = Config.options?.panel?.tools;
                        if (!tools) return [];
                        return tools.map((tool, index) => {
                            return {
                                displayName: tool?.bar?.name ?? "Unknown",
                                value: index
                            };
                        });
                    }
                }
            }
        }

        ContentSection {
            id: configSectionII
            visible: Config.options.panel.family === "ii"

            ContentSection {
                icon: "notifications"
                title: Translation.tr("Notifications")
                ConfigSwitch {
                    buttonIcon: "counter_2"
                    text: Translation.tr("Unread indicator: show count")
                    checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.indicators.notifications.showUnreadCount
                    onCheckedChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.indicators.notifications.showUnreadCount = checked;
                    }
                }
            }
            
            ContentSection {
                icon: "spoke"
                title: Translation.tr("Positioning")

                ConfigRow {
                    ContentSubsection {
                        title: Translation.tr("Bar position")
                        Layout.fillWidth: true

                        ConfigSelectionArray {
                            currentValue: (Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.bottom ? 1 : 0) | (Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.vertical ? 2 : 0)
                            onSelected: newValue => {
                                Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.bottom = (newValue & 1) !== 0;
                                Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.vertical = (newValue & 2) !== 0;
                            }
                            options: [
                                {
                                    displayName: Translation.tr("Top"),
                                    icon: "arrow_upward",
                                    value: 0
                                },
                                {
                                    displayName: Translation.tr("Left"),
                                    icon: "arrow_back",
                                    value: 2
                                },
                                {
                                    displayName: Translation.tr("Bottom"),
                                    icon: "arrow_downward",
                                    value: 1
                                },
                                {
                                    displayName: Translation.tr("Right"),
                                    icon: "arrow_forward",
                                    value: 3
                                }
                            ]
                        }
                    }
                    ContentSubsection {
                        title: Translation.tr("Automatically hide")
                        Layout.fillWidth: false

                        ConfigSelectionArray {
                            currentValue: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.autoHide.enable
                            onSelected: newValue => {
                                Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.autoHide.enable = newValue;
                            }
                            options: [
                                {
                                    displayName: Translation.tr("No"),
                                    icon: "close",
                                    value: false
                                },
                                {
                                    displayName: Translation.tr("Yes"),
                                    icon: "check",
                                    value: true
                                }
                            ]
                        }
                    }
                }

                ConfigRow {
                    ContentSubsection {
                        title: Translation.tr("%1 style").arg(Translation.tr("Corner"))
                        Layout.fillWidth: true

                        ConfigSelectionArray {
                            currentValue: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.cornerStyle
                            onSelected: newValue => {
                                Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.cornerStyle = newValue;
                            }
                            options: [
                                {
                                    displayName: Translation.tr("Hug"),
                                    icon: "line_curve",
                                    value: 0
                                },
                                {
                                    displayName: Translation.tr("Float"),
                                    icon: "page_header",
                                    value: 1
                                },
                                {
                                    displayName: Translation.tr("Rect"),
                                    icon: "toolbar",
                                    value: 2
                                }
                            ]
                        }
                    }

                    ContentSubsection {
                        title: Translation.tr("%1 style").arg(Translation.tr("Group"))
                        Layout.fillWidth: false

                        ConfigSelectionArray {
                            currentValue: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.borderless
                            onSelected: newValue => {
                                Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.borderless = newValue;
                            }
                            options: [
                                {
                                    displayName: Translation.tr("Pills"),
                                    icon: "location_chip",
                                    value: false
                                },
                                {
                                    displayName: Translation.tr("Line-separated"),
                                    icon: "split_scene",
                                    value: true
                                }
                            ]
                        }
                    }
                }
            }

            ContentSection {
                icon: "shelf_auto_hide"
                title: Translation.tr("Tray")

                ConfigSwitch {
                    buttonIcon: "keep"
                    text: Translation.tr('Make icons pinned by default')
                    checked: Config.options.tray.invertPinnedItems
                    onCheckedChanged: {
                        Config.options.tray.invertPinnedItems = checked;
                    }
                }
                
                ConfigSwitch {
                    buttonIcon: "colors"
                    text: Translation.tr('Tint icons')
                    checked: Config.options.tray.monochromeIcons
                    onCheckedChanged: {
                        Config.options.tray.monochromeIcons = checked;
                    }
                }
            }

            ContentSection {
                icon: "widgets"
                title: Translation.tr("Utility buttons")

                ConfigRow {
                    uniform: true
                    ConfigSwitch {
                        buttonIcon: "content_cut"
                        text: Translation.tr("Screen snip")
                        checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showScreenSnip
                        onCheckedChanged: {
                            Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showScreenSnip = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "colorize"
                        text: Translation.tr("Color picker")
                        checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showColorPicker
                        onCheckedChanged: {
                            Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showColorPicker = checked;
                        }
                    }
                }
                ConfigRow {
                    uniform: true
                    ConfigSwitch {
                        buttonIcon: "keyboard"
                        text: Translation.tr("Keyboard toggle")
                        checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showKeyboardToggle
                        onCheckedChanged: {
                            Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showKeyboardToggle = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "mic"
                        text: Translation.tr("Mic toggle")
                        checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showMicToggle
                        onCheckedChanged: {
                            Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showMicToggle = checked;
                        }
                    }
                }
                ConfigRow {
                    uniform: true
                    ConfigSwitch {
                        buttonIcon: "dark_mode"
                        text: Translation.tr("Dark/Light toggle")
                        checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showDarkModeToggle
                        onCheckedChanged: {
                            Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showDarkModeToggle = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "speed"
                        text: Translation.tr("Performance Profile toggle")
                        checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showPerformanceProfileToggle
                        onCheckedChanged: {
                            Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showPerformanceProfileToggle = checked;
                        }
                    }
                }
                ConfigRow {
                    uniform: true
                    ConfigSwitch {
                        buttonIcon: "videocam"
                        text: Translation.tr("Record")
                        checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showScreenRecord
                        onCheckedChanged: {
                            Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.utilButtons.showScreenRecord = checked;
                        }
                    }
                }
            }

            ContentSection {
                icon: "cloud"
                title: Translation.tr("Weather")
                ConfigSwitch {
                    buttonIcon: "check"
                    text: Translation.tr("Enable")
                    checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.weather.enable
                    onCheckedChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.weather.enable = checked;
                    }
                }
            }

            ContentSection {
                icon: "workspaces"
                title: Translation.tr("Workspaces")

                ConfigSwitch {
                    buttonIcon: "counter_1"
                    text: Translation.tr('Always show numbers')
                    checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.workspaces.alwaysShowNumbers
                    onCheckedChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.workspaces.alwaysShowNumbers = checked;
                    }
                }

                ConfigSwitch {
                    buttonIcon: "award_star"
                    text: Translation.tr('Show app icons')
                    checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.workspaces.showAppIcons
                    onCheckedChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.workspaces.showAppIcons = checked;
                    }
                }

                ConfigSwitch {
                    buttonIcon: "colors"
                    text: Translation.tr('Tint app icons')
                    checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.workspaces.monochromeIcons
                    onCheckedChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.workspaces.monochromeIcons = checked;
                    }
                }

                ConfigSpinBox {
                    icon: "view_column"
                    text: Translation.tr("Workspaces shown")
                    value: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.workspaces.shown
                    from: 1
                    to: 30
                    stepSize: 1
                    onValueChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.workspaces.shown = value;
                    }
                }

                ConfigSpinBox {
                    icon: "touch_long"
                    text: Translation.tr("Number show delay when pressing Super (ms)")
                    value: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.workspaces.showNumberDelay
                    from: 0
                    to: 1000
                    stepSize: 50
                    onValueChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.workspaces.showNumberDelay = value;
                    }
                }

                ContentSubsection {
                    title: Translation.tr("%1 style").arg(Translation.tr("Number"))

                    ConfigSelectionArray {
                        currentValue: JSON.stringify(Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.workspaces.numberMap)
                        onSelected: newValue => {
                            Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.workspaces.numberMap = JSON.parse(newValue)
                        }
                        options: [
                            {
                                displayName: Translation.tr("Normal"),
                                icon: "timer_10",
                                value: '[]'
                            },
                            {
                                displayName: Translation.tr("Han chars"),
                                icon: "square_dot",
                                value: '["一","二","三","四","五","六","七","八","九","十","十一","十二","十三","十四","十五","十六","十七","十八","十九","二十"]'
                            },
                            {
                                displayName: Translation.tr("Roman"),
                                icon: "account_balance",
                                value: '["I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII","XIII","XIV","XV","XVI","XVII","XVIII","XIX","XX"]'
                            }
                        ]
                    }
                }
            }

            ContentSection {
                icon: "tooltip"
                title: Translation.tr("Tooltips")
                ConfigSwitch {
                    buttonIcon: "ads_click"
                    text: Translation.tr("Click to show")
                    checked: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.tooltips.clickToShow
                    onCheckedChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.tooltips.clickToShow = checked;
                    }
                }
            }
        }

        ContentSection {
            id: configSectionWAFFLE
            visible: Config.options.panel.family === "waffle"

            ContentSection {
                icon: "inbox"
                title: Translation.tr("Tweaks")
                ConfigSwitch {
                    buttonIcon: "inbox_customize"
                    text: Translation.tr("Handle position fix")
                    checked: Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.tweaks.switchHandlePositionFix
                    onCheckedChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.tweaks.switchHandlePositionFix = checked;
                    }
                }
                ConfigSwitch {
                    buttonIcon: "inbox_customize"
                    text: Translation.tr("Smoother menu animations")
                    checked: Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.tweaks.smootherMenuAnimations
                    onCheckedChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.tweaks.smootherMenuAnimations = checked;
                    }
                }
                ConfigSwitch {
                    buttonIcon: "inbox_customize"
                    text: Translation.tr("Smoother search bar")
                    checked: Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.tweaks.smootherSearchBar
                    onCheckedChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.tweaks.smootherSearchBar = checked;
                    }
                }
            }

            ContentSection {
                icon: "bottom_navigation"
                title: Translation.tr("Bar")
                ConfigSwitch {
                    buttonIcon: "density_large"
                    text: Translation.tr("Bottom position")
                    checked: Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.bar.bottom
                    onCheckedChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.bar.bottom = checked;
                    }
                }
                ConfigSwitch {
                    buttonIcon: "inbox_customize"
                    text: Translation.tr("Left align apps")
                    checked: Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.bar.leftAlignApps
                    onCheckedChanged: {
                        Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.bar.leftAlignApps = checked;
                    }
                }
            }

            ConfigSwitch {
                buttonIcon: "density_large"
                text: Translation.tr("Bottom position")
                checked: Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.calendar.force2CharDayOfWeek
                onCheckedChanged: {
                    Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.calendar.force2CharDayOfWeek = checked;
                }
            }
        }
    }
}

