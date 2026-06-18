import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    ContentSection {
        icon: "side_navigation"
        title: Translation.tr("Left")

        ContentSection {
            icon: "neurology"
            title: Translation.tr("AI")

            MaterialTextArea {
                Layout.fillWidth: true
                placeholderText: Translation.tr("System %1").arg(Translation.tr("Prompt").toLowerCase())
                text: Config.options.sidebar.left.ai.systemPrompt
                wrapMode: TextEdit.Wrap
                onTextChanged: {
                    Qt.callLater(() => {
                        Config.options.sidebar.left.ai.systemPrompt = text;
                    });
                }
            }
        }

        ConfigSwitch {
            buttonIcon: "memory"
            text: Translation.tr('Keep right sidebar loaded')
            checked: Config.options.sidebar.left.keepRightSidebarLoaded
            onCheckedChanged: {
                Config.options.sidebar.left.keepRightSidebarLoaded = checked;
            }
            StyledToolTip {
                text: Translation.tr("When enabled keeps the content of the right sidebar loaded to reduce the delay when opening,\nat the cost of around 15MB of consistent RAM usage. Delay significance depends on your system's performance.\nUsing a custom kernel like linux-cachyos might help")
            }
        }

        ConfigSwitch {
            buttonIcon: "translate"
            text: Translation.tr('Enable translator')
            checked: Config.options.sidebar.left.translator.enable
            onCheckedChanged: {
                Config.options.sidebar.left.translator.enable = checked;
            }
        }
    }

    ContentSection {
        icon: "side_navigation"
        iconRotation: 180
        title: Translation.tr("Right")

        ContentSubsection {
            title: Translation.tr("Quick toggles")

            ConfigSwitch {
                buttonIcon: "subtitles"
                text: Translation.tr("Detailed mode")
                checked: ((Config.options.sidebar.right.quickToggles.toggles[0].size !== 1) ? true : false)
                onCheckedChanged: {
                    Config.options.sidebar.right.quickToggles.toggles.forEach(toggle => toggle.size = ((checked) ? 2 : 1));
                }
            }

            ConfigSpinBox {
                icon: "splitscreen_left"
                text: Translation.tr("Columns")
                value: Config.options.sidebar.right.quickToggles.columns
                from: 1
                to: 8
                stepSize: 1
                onValueChanged: {
                    Config.options.sidebar.right.quickToggles.columns = value;
                }
            }
        }

        ContentSubsection {
            title: Translation.tr("Sliders")

            ConfigSwitch {
                buttonIcon: "check"
                text: Translation.tr("Enable")
                checked: Config.options.sidebar.right.quickSliders.enable
                onCheckedChanged: {
                    Config.options.sidebar.right.quickSliders.enable = checked;
                }
            }
            
            ConfigSwitch {
                buttonIcon: "brightness_6"
                text: Translation.tr("Brightness")
                enabled: Config.options.sidebar.right.quickSliders.enable
                checked: Config.options.sidebar.right.quickSliders.showBrightness
                onCheckedChanged: {
                    Config.options.sidebar.right.quickSliders.showBrightness = checked;
                }
            }

            ConfigSwitch {
                buttonIcon: "volume_up"
                text: Translation.tr("Volume")
                enabled: Config.options.sidebar.right.quickSliders.enable
                checked: Config.options.sidebar.right.quickSliders.showVolume
                onCheckedChanged: {
                    Config.options.sidebar.right.quickSliders.showVolume = checked;
                }
            }

            ConfigSwitch {
                buttonIcon: "mic"
                text: Translation.tr("Microphone")
                enabled: Config.options.sidebar.right.quickSliders.enable
                checked: Config.options.sidebar.right.quickSliders.showMic
                onCheckedChanged: {
                    Config.options.sidebar.right.quickSliders.showMic = checked;
                }
            }
        }

        ContentSubsection {
            title: Translation.tr("Corner open")
            tooltip: Translation.tr("Allows you to open sidebars by clicking or hovering screen corners regardless of bar position")
            ConfigRow {
                uniform: true
                ConfigSwitch {
                    buttonIcon: "check"
                    text: Translation.tr("Enable")
                    checked: Config.options.sidebar.right.cornerOpen.enable
                    onCheckedChanged: {
                        Config.options.sidebar.right.cornerOpen.enable = checked;
                    }
                }
            }
            ConfigSwitch {
                buttonIcon: "highlight_mouse_cursor"
                text: Translation.tr("Hover to trigger")
                checked: Config.options.sidebar.right.cornerOpen.clickless
                onCheckedChanged: {
                    Config.options.sidebar.right.cornerOpen.clickless = checked;
                }

                StyledToolTip {
                    text: Translation.tr("When this is off you'll have to click")
                }
            }
            Row {
                ConfigSwitch {
                    enabled: !Config.options.sidebar.right.cornerOpen.clickless
                    text: Translation.tr("Force hover open at absolute corner")
                    checked: Config.options.sidebar.right.cornerOpen.clicklessCornerEnd
                    onCheckedChanged: {
                        Config.options.sidebar.right.cornerOpen.clicklessCornerEnd = checked;
                    }

                    StyledToolTip {
                        text: Translation.tr("When the previous option is off and this is on,\nyou can still hover the corner's end to open sidebar,\nand the remaining area can be used for volume/brightness scroll")
                    }
                }
                ConfigSpinBox {
                    icon: "arrow_cool_down"
                    text: Translation.tr("with vertical offset")
                    value: Config.options.sidebar.right.cornerOpen.clicklessCornerVerticalOffset
                    from: 0
                    to: 20
                    stepSize: 1
                    onValueChanged: {
                        Config.options.sidebar.right.cornerOpen.clicklessCornerVerticalOffset = value;
                    }
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.NoButton
                        StyledToolTip {
                            extraVisibleCondition: mouseArea.containsMouse
                            text: Translation.tr("Why this is cool:\nFor non-0 values, it won't trigger when you reach the\nscreen corner along the horizontal edge, but it will when\nyou do along the vertical edge")
                        }
                    }
                }
            }
            
            ConfigRow {
                uniform: true
                ConfigSwitch {
                    buttonIcon: "vertical_align_bottom"
                    text: Translation.tr("Place at bottom")
                    checked: Config.options.sidebar.right.cornerOpen.bottom
                    onCheckedChanged: {
                        Config.options.sidebar.right.cornerOpen.bottom = checked;
                    }

                    StyledToolTip {
                        text: Translation.tr("Place the corners to trigger at the bottom")
                    }
                }
                ConfigSwitch {
                    buttonIcon: "unfold_more_double"
                    text: Translation.tr("Value scroll")
                    checked: Config.options.sidebar.right.cornerOpen.valueScroll
                    onCheckedChanged: {
                        Config.options.sidebar.right.cornerOpen.valueScroll = checked;
                    }

                    StyledToolTip {
                        text: Translation.tr("Brightness and volume")
                    }
                }
            }
            ConfigSwitch {
                buttonIcon: "visibility"
                text: Translation.tr("Visualize region")
                checked: Config.options.sidebar.right.cornerOpen.visualize
                onCheckedChanged: {
                    Config.options.sidebar.right.cornerOpen.visualize = checked;
                }
            }
            ConfigRow {
                ConfigSpinBox {
                    icon: "arrow_range"
                    text: Translation.tr("Region width")
                    value: Config.options.sidebar.right.cornerOpen.cornerRegionWidth
                    from: 1
                    to: 300
                    stepSize: 1
                    onValueChanged: {
                        Config.options.sidebar.right.cornerOpen.cornerRegionWidth = value;
                    }
                }
                ConfigSpinBox {
                    icon: "height"
                    text: Translation.tr("Region height")
                    value: Config.options.sidebar.right.cornerOpen.cornerRegionHeight
                    from: 1
                    to: 300
                    stepSize: 1
                    onValueChanged: {
                        Config.options.sidebar.right.cornerOpen.cornerRegionHeight = value;
                    }
                }
            }
        }
    }
}
