import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

ContentPage {
    forceWidth: true

    // Process {
    //     id: randomWallProc
    //     property string status: ""
    //     property string scriptPath: ""
    //     property string tag: ""
    //     command: ["bash", "-c", FileUtils.trimFileProtocol(randomWallProc.scriptPath) + " setTag " + randomWallProc.tag]
    //     stdout: SplitParser {
    //         onRead: data => {
    //             randomWallProc.status = data.trim();
    //         }
    //     }
    // }

    // Process {
    //     id: listWallpaperTagsProc
    //     running: true
    //     property ListModel providers: ListModel {}
    //     property string scriptPath: `${Directories.scriptPath}/colors/random/random_${Config.options.background.provider.name}.sh`
    //     command: ["bash", "-c", FileUtils.trimFileProtocol(listWallpaperTagsProc.scriptPath) + " getTag"]
    //     stdout: SplitParser {
    //         onRead: data => {
    //             try {
    //                 let tags = JSON.parse(data);
    //                 tags.forEach(tag => {
    //                     listWallpaperTagsProc.providers.append({
    //                         displayName: tag,
    //                         value: tag
    //                     });
    //                 });
    //             } catch (e) {
    //             }
    //         }
    //     }
    // }

    // Process {
    //     id: listRandomScriptsProc
    //     running: true
    //     property ListModel providers: ListModel {}
    //     command: ["find", Directories.scriptPath + "/colors/random/", "-maxdepth", "1", "-type", "f", "-name", "random_*.sh", "-printf", "%f\\n"]
    //     stdout: SplitParser {
    //         onRead: data => {
    //             data.trim().split('\\n').filter(line => line.trim()).forEach(fileName => {
    //                 if (fileName.startsWith("random_") && fileName.endsWith(".sh")) {
    //                     const cleanName = fileName.slice(7, -3);
    //                     if (cleanName.length > 0) {
    //                         const displayName = cleanName.split('_').join(' ');
    //                         listRandomScriptsProc.providers.append({
    //                             displayName: displayName,
    //                             value: displayName
    //                         });
    //                     }
    //                 }
    //             });
    //         }
    //     }
    // }

    component SmallLightDarkPreferenceButton: RippleButton {
        id: smallLightDarkPreferenceButton
        required property bool dark
        property color colText: toggled ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer2
        padding: 5
        Layout.fillWidth: true
        toggled: Appearance.m3colors.darkmode === dark
        colBackground: Appearance.colors.colLayer2
        onClicked: {
            Quickshell.execDetached(["bash", "-c", `${Directories.wallpaperSwitchScriptPath} --mode ${dark ? "dark" : "light"} --noswitch`]);
        }
        contentItem: Item {
            anchors.centerIn: parent
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0
                MaterialSymbol {
                    Layout.alignment: Qt.AlignHCenter
                    iconSize: 30
                    text: dark ? "dark_mode" : "light_mode"
                    color: smallLightDarkPreferenceButton.colText
                }
                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: dark ? Translation.tr("Dark") : Translation.tr("Light")
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: smallLightDarkPreferenceButton.colText
                }
            }
        }
    }

    //// Wallpaper selection
    // ContentSection {
    //     icon: "format_paint"
    //     title: Translation.tr("Wallpaper & Colors")
    //     Layout.fillWidth: true

    //     RowLayout {
    //         Layout.fillWidth: true

    //         Item {
    //             implicitWidth: 360
    //             implicitHeight: 220
                
    //             StyledImage {
    //                 id: wallpaperPreview
    //                 anchors.fill: parent
    //                 sourceSize.width: parent.implicitWidth
    //                 sourceSize.height: parent.implicitHeight
    //                 fillMode: Image.PreserveAspectCrop
    //                 source: Config.options.background.wallpaperPath
    //                 cache: false
    //                 layer.enabled: true
    //                 layer.effect: OpacityMask {
    //                     maskSource: Rectangle {
    //                         width: 360
    //                         height: 220
    //                         radius: Appearance.rounding.normal
    //                     }
    //                 }
    //             }
    //         }

    //         ColumnLayout {
    //             StyledComboBox {
    //                 id: wallpaperProviderSelector
    //                 buttonIcon: "swap_horiz"
    //                 textRole: "displayName"
    //                 model: listRandomScriptsProc.providers

    //                 currentIndex: {
    //                     let foundIndex = 0;
    //                     for (let i = 0; i < model.count; i++) {
    //                         if (model.get(i).value === Config.options.background.provider.name) {
    //                             foundIndex = i;
    //                             break;
    //                         }
    //                     }
    //                     return foundIndex;
    //                 }

    //                 onActivated: index => {
    //                     Config.options.background.provider.name = model.get(index).value;

    //                     listWallpaperTagsProc.running = false;
    //                     listWallpaperTagsProc.providers.clear();

    //                     listWallpaperTagsProc.scriptPath = `${Directories.scriptPath}/colors/random/random_${model.get(index).value}.sh`;
    //                     listWallpaperTagsProc.running = true;
    //                 }

    //                 StyledToolTip {
    //                     text: Translation.tr("Wallpaper provider")
    //                 }
    //             }
    //             RowLayout {
    //                 StyledComboBox {
    //                     id: tagSelector
    //                     buttonIcon: "sell"
    //                     textRole: "displayName"
    //                     enabled: listWallpaperTagsProc.providers.count > 0
    //                     model: listWallpaperTagsProc.providers

    //                     currentIndex: {
    //                         let foundIndex = 0;
    //                         for (let i = 0; i < model.count; i++) {
    //                             if (model.get(i).value === Config.options.background.provider.tag) {
    //                                 foundIndex = i;
    //                                 break;
    //                             }
    //                         }
    //                         return foundIndex;
    //                     }

    //                     onActivated: index => {
    //                         Config.options.background.provider.tag = model.get(index).value;
    //                     }

    //                 }
    //                 RippleButtonWithIcon {
    //                     enabled: !randomWallProc.running
    //                     visible: Config.options.policies.weeb === 1
    //                     buttonRadius: Appearance.rounding.small
    //                     materialIcon: "ifl"
    //                     mainText: randomWallProc.running ? Translation.tr("Be patient...") : Translation.tr("Random")
    //                     onClicked: {
    //                         randomWallProc.scriptPath = `${Directories.scriptPath}/colors/random/random_${wallpaperProviderSelector.model.get(wallpaperProviderSelector.currentIndex).value}.sh`;
    //                         randomWallProc.running = true;
    //                     }
    //                     StyledToolTip {
    //                         text: Translation.tr("Random wallpaper\nImage is saved to %1").arg(`${Directories.pictures}/Wallpapers`)
    //                     }
    //                 }
    //             }
    //             RippleButtonWithIcon {
    //                 Layout.fillWidth: true
    //                 materialIcon: "wallpaper"
    //                 StyledToolTip {
    //                     text: Translation.tr("Pick wallpaper image on your system")
    //                 }
    //                 onClicked: {
    //                     Quickshell.execDetached(`${Directories.wallpaperSwitchScriptPath}`);
    //                 }
    //                 mainContentComponent: Component {
    //                     RowLayout {
    //                         spacing: 10
    //                         StyledText {
    //                             font.pixelSize: Appearance.font.pixelSize.small
    //                             text: Translation.tr("Choose file")
    //                             color: Appearance.colors.colOnSecondaryContainer
    //                         }
    //                         RowLayout {
    //                             spacing: 3
    //                             KeyboardKey {
    //                                 key: "Ctrl"
    //                             }
    //                             KeyboardKey {
    //                                 key: Config.options.cheatsheet.superKey ?? "󰖳"
    //                             }
    //                             StyledText {
    //                                 Layout.alignment: Qt.AlignVCenter
    //                                 text: "+"
    //                             }
    //                             KeyboardKey {
    //                                 key: "T"
    //                             }
    //                         }
    //                     }
    //                 }
    //             }
    //             RowLayout {
    //                 Layout.alignment: Qt.AlignHCenter
    //                 Layout.fillWidth: true
    //                 Layout.fillHeight: true
    //                 uniformCellSizes: true

    //                 SmallLightDarkPreferenceButton {
    //                     Layout.fillHeight: true
    //                     dark: false
    //                 }
    //                 SmallLightDarkPreferenceButton {
    //                     Layout.fillHeight: true
    //                     dark: true
    //                 }
    //             }
    //         }
    //     }

    //     ConfigSelectionArray {
    //         currentValue: Config.options.appearance.palette.type
    //         onSelected: newValue => {
    //             Config.options.appearance.palette.type = newValue;
    //             Quickshell.execDetached(["bash", "-c", `${Directories.wallpaperSwitchScriptPath} --noswitch`]);
    //         }
    //         options: [
    //             {
    //                 "value": "auto",
    //                 "displayName": Translation.tr("Auto")
    //             },
    //             {
    //                 "value": "scheme-content",
    //                 "displayName": Translation.tr("Content")
    //             },
    //             {
    //                 "value": "scheme-expressive",
    //                 "displayName": Translation.tr("Expressive")
    //             },
    //             {
    //                 "value": "scheme-fidelity",
    //                 "displayName": Translation.tr("Fidelity")
    //             },
    //             {
    //                 "value": "scheme-fruit-salad",
    //                 "displayName": Translation.tr("Fruit Salad")
    //             },
    //             {
    //                 "value": "scheme-monochrome",
    //                 "displayName": Translation.tr("Monochrome")
    //             },
    //             {
    //                 "value": "scheme-neutral",
    //                 "displayName": Translation.tr("Neutral")
    //             },
    //             {
    //                 "value": "scheme-rainbow",
    //                 "displayName": Translation.tr("Rainbow")
    //             },
    //             {
    //                 "value": "scheme-tonal-spot",
    //                 "displayName": Translation.tr("Tonal Spot")
    //             }
    //         ]
    //     }

    //     ConfigSwitch {
    //         buttonIcon: "ev_shadow"
    //         text: Translation.tr("Transparency")
    //         checked: Config.options.appearance.transparency.enable
    //         onCheckedChanged: {
    //             Config.options.appearance.transparency.enable = checked;
    //         }
    //     }
    // }

    ContentSection {
        icon: "screenshot_monitor"
        title: Translation.tr("Bar")

        ConfigRow {
            ContentSubsection {
                title: Translation.tr("Bar position")
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
                            value: 0 // bottom: false, vertical: false
                        },
                        {
                            displayName: Translation.tr("Left"),
                            icon: "arrow_back",
                            value: 2 // bottom: false, vertical: true
                        },
                        {
                            displayName: Translation.tr("Bottom"),
                            icon: "arrow_downward",
                            value: 1 // bottom: true, vertical: false
                        },
                        {
                            displayName: Translation.tr("Right"),
                            icon: "arrow_forward",
                            value: 3 // bottom: true, vertical: true
                        }
                    ]
                }
            }
            ContentSubsection {
                title: Translation.tr("%1 style").arg(Translation.tr("Bar"))

                ConfigSelectionArray {
                    currentValue: Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.cornerStyle
                    onSelected: newValue => {
                        Config.options.panel.tools[Config.panelFamilyIndexII].bar.config.cornerStyle = newValue; // Update local copy
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
        }

        ConfigRow {
            ContentSubsection {
                title: Translation.tr("Screen round corner")

                ConfigSelectionArray {
                    currentValue: Config.options.appearance.fakeScreenRounding
                    onSelected: newValue => {
                        Config.options.appearance.fakeScreenRounding = newValue;
                    }
                    options: [
                        {
                            displayName: Translation.tr("No"),
                            icon: "close",
                            value: 0
                        },
                        {
                            displayName: Translation.tr("Yes"),
                            icon: "check",
                            value: 1
                        },
                        {
                            displayName: Translation.tr("When not fullscreen"),
                            icon: "fullscreen_exit",
                            value: 2
                        }
                    ]
                }
            }
            
        }
    }

    NoticeBox {
        Layout.fillWidth: true
        text: Translation.tr('Not all options are available in this app. You should also check the config file by hitting the "Config file" button on the topleft corner or opening %1 manually.').arg(Directories.shellConfigPath)

        Item {
            Layout.fillWidth: true
        }
        RippleButtonWithIcon {
            id: copyPathButton
            property bool justCopied: false
            Layout.fillWidth: false
            buttonRadius: Appearance.rounding.small
            materialIcon: justCopied ? "check" : "content_copy"
            mainText: justCopied ? Translation.tr("Path copied") : Translation.tr("Copy path")
            onClicked: {
                copyPathButton.justCopied = true
                Quickshell.clipboardText = FileUtils.trimFileProtocol(`${Directories.config}/illogical-impulse/config.json`);
                revertTextTimer.restart();
            }
            colBackground: ColorUtils.transparentize(Appearance.colors.colPrimaryContainer)
            colBackgroundHover: Appearance.colors.colPrimaryContainerHover
            colRipple: Appearance.colors.colPrimaryContainerActive

            Timer {
                id: revertTextTimer
                interval: 1500
                onTriggered: {
                    copyPathButton.justCopied = false
                }
            }
        }
    }
}
