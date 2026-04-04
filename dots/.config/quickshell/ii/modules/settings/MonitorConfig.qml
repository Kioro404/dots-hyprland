import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    Process {
        id: randomWallProc
        property string status: ""
        property string scriptPath: `${Directories.scriptPath}/colors/random/random_konachan_wall.sh`
        property string monitorName: Config.options.monitor[monitorSelector.currentIndex].output.screen.name
        command: ["bash", "-c", `${FileUtils.trimFileProtocol(randomWallProc.scriptPath)} "${randomWallProc.monitorName}"`]
        stdout: SplitParser {
            onRead: data => {
                randomWallProc.status = data.trim();
            }
        }
    }

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

    ContentSection {
        icon: "screenshot_monitor"
        title: Translation.tr("Select %1").arg(Translation.tr("Monitor"))

        ContentSubsection {
            title: Translation.tr("Select monitor to apply changes")
            tooltip: Translation.tr("Select the monitor to apply screen setting and individual changes for %1 and %2.").arg(Translation.tr("Wallpaper")).arg(Translation.tr("Bar"))

            StyledComboBox {
                id: monitorSelector
                buttonIcon: "screenshot_monitor"
                textRole: "displayName"

                model: Config.options.monitor.map(monitor => {
                    return {
                        displayName: monitor.output.screen.name,
                        value:       monitor.output.screen.id
                    };
                })

                currentIndex: {
                    const index = Config.options.monitor.findIndex(m => m.output.screen.name === HyprlandData.activeWorkspace?.monitor);
                    return index !== -1 ? index : 0;
                }
            }
        }
    }

    ConfigSwitch {
        id: wallpaperSwitch
        buttonIcon: "texture"
        text: Translation.tr("Enable %1").arg(Translation.tr("Wallpaper"))
        checked: !Config.options.monitor[monitorSelector.currentIndex].output.background.disabled
        onCheckedChanged: {
            Config.options.monitor[monitorSelector.currentIndex].output.background.disabled = !checked;
        }
    }

    ContentSection {
        visible: wallpaperSwitch.checked

        ContentSubsection {
            title: Translation.tr("Wallpaper & Colors")
            Layout.fillWidth: true

            RowLayout {
                Layout.fillWidth: true

                Item {
                    implicitWidth: 340
                    implicitHeight: 200
                    
                    StyledImage {
                        id: wallpaperPreview
                        anchors.fill: parent
                        sourceSize.width: parent.implicitWidth
                        sourceSize.height: parent.implicitHeight
                        fillMode: Image.PreserveAspectCrop
                        source: Config.options.monitor[monitorSelector.currentIndex].output.background.wallpaperPath
                        cache: false
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: 340
                                height: 200
                                radius: Appearance.rounding.normal
                            }
                        }
                    }
                }

                ColumnLayout {
                    RippleButtonWithIcon {
                        enabled: !randomWallProc.running
                        visible: Config.options.policies.weeb === 1
                        Layout.fillWidth: true
                        buttonRadius: Appearance.rounding.small
                        materialIcon: "ifl"
                        mainText: randomWallProc.running ? Translation.tr("Be patient...") : Translation.tr("Random: Konachan")
                        onClicked: {
                            randomWallProc.scriptPath = `${Directories.scriptPath}/colors/random/random_konachan_wall.sh`;
                            randomWallProc.running = true;
                        }
                        StyledToolTip {
                            text: Translation.tr("Random SFW Anime wallpaper from Konachan\nImage is saved to ~/Pictures/Wallpapers")
                        }
                    }
                    RippleButtonWithIcon {
                        Layout.fillWidth: true
                        materialIcon: "wallpaper"
                        StyledToolTip {
                            text: Translation.tr("Pick wallpaper image on your system")
                        }
                        onClicked: {
                            Quickshell.execDetached(["bash", "-c", `${Directories.wallpaperSwitchScriptPath} --monitor "${Config.options.monitor[monitorSelector.currentIndex].output.screen.name}"`]);
                        }
                        mainContentComponent: Component {
                            RowLayout {
                                spacing: 10
                                StyledText {
                                    font.pixelSize: Appearance.font.pixelSize.small
                                    text: Translation.tr("Choose file")
                                    color: Appearance.colors.colOnSecondaryContainer
                                }
                                RowLayout {
                                    spacing: 3
                                    KeyboardKey {
                                        key: "Ctrl"
                                    }
                                    KeyboardKey {
                                        key: Config.options.cheatsheet.superKey ?? "󰖳"
                                    }
                                    StyledText {
                                        Layout.alignment: Qt.AlignVCenter
                                        text: "+"
                                    }
                                    KeyboardKey {
                                        key: "T"
                                    }
                                }
                            }
                        }
                    }
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        uniformCellSizes: true

                        SmallLightDarkPreferenceButton {
                            Layout.fillHeight: true
                            dark: false
                        }
                        SmallLightDarkPreferenceButton {
                            Layout.fillHeight: true
                            dark: true
                        }
                    }
                }
            }

            ConfigSelectionArray {
                currentValue: Config.options.appearance.palette.type
                onSelected: newValue => {
                    Config.options.appearance.palette.type = newValue;
                    Quickshell.execDetached(["bash", "-c", `${Directories.wallpaperSwitchScriptPath} --noswitch`]);
                }
                options: [
                    {
                        "value": "auto",
                        "displayName": Translation.tr("Auto")
                    },
                    {
                        "value": "scheme-content",
                        "displayName": Translation.tr("Content")
                    },
                    {
                        "value": "scheme-expressive",
                        "displayName": Translation.tr("Expressive")
                    },
                    {
                        "value": "scheme-fidelity",
                        "displayName": Translation.tr("Fidelity")
                    },
                    {
                        "value": "scheme-fruit-salad",
                        "displayName": Translation.tr("Fruit Salad")
                    },
                    {
                        "value": "scheme-monochrome",
                        "displayName": Translation.tr("Monochrome")
                    },
                    {
                        "value": "scheme-neutral",
                        "displayName": Translation.tr("Neutral")
                    },
                    {
                        "value": "scheme-rainbow",
                        "displayName": Translation.tr("Rainbow")
                    },
                    {
                        "value": "scheme-tonal-spot",
                        "displayName": Translation.tr("Tonal Spot")
                    }
                ]
            }

            ConfigSwitch {
                buttonIcon: "ev_shadow"
                text: Translation.tr("Transparency")
                checked: Config.options.appearance.transparency.enable
                onCheckedChanged: {
                    Config.options.appearance.transparency.enable = checked;
                }
            }
        }

        ContentSection {
            icon: "sync_alt"
            title: Translation.tr("Parallax")

            ConfigSwitch {
                buttonIcon: "unfold_more_double"
                text: Translation.tr("Vertical")
                checked: Config.options.monitor[monitorSelector.currentIndex].output.background.parallax.vertical
                onCheckedChanged: {
                    Config.options.monitor[monitorSelector.currentIndex].output.background.parallax.vertical = checked;
                }
            }

            ConfigRow {
                uniform: true
                ConfigSwitch {
                    buttonIcon: "counter_1"
                    text: Translation.tr("Depends on workspace")
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.background.parallax.enableWorkspace
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.parallax.enableWorkspace = checked;
                    }
                }
                ConfigSwitch {
                    buttonIcon: "side_navigation"
                    text: Translation.tr("Depends on sidebars")
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.background.parallax.enableSidebar
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.parallax.enableSidebar = checked;
                    }
                }
            }
            ConfigSpinBox {
                icon: "loupe"
                text: Translation.tr("Preferred wallpaper zoom (%)")
                value: Config.options.monitor[monitorSelector.currentIndex].output.background.parallax.workspaceZoom * 100
                from: 100
                to: 150
                stepSize: 1
                onValueChanged: {
                    Config.options.monitor[monitorSelector.currentIndex].output.background.parallax.workspaceZoom = value / 100;
                }
            }
        }

        ContentSection {
            id: settingsClock
            icon: "clock_loader_40"
            title: Translation.tr("Widget: %1").arg(Translation.tr("Clock"))

            function stylePresent(styleName) {
                if (!Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.showOnlyWhenLocked && Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.style === styleName) {
                    return true;
                }
                if (Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.styleLocked === styleName) {
                    return true;
                }
                return false;
            }

            readonly property bool digitalPresent: stylePresent("digital")
            readonly property bool cookiePresent: stylePresent("cookie")

            ConfigRow {
                Layout.fillWidth: true

                ConfigSwitch {
                    Layout.fillWidth: false
                    buttonIcon: "check"
                    text: Translation.tr("Enable")
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.enable
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.enable = checked;
                    }
                }
                Item {
                    Layout.fillWidth: true
                }
                ConfigSelectionArray {
                    Layout.fillWidth: false
                    currentValue: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.placementStrategy
                    onSelected: newValue => {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.placementStrategy = newValue;
                    }
                    options: [
                        {
                            displayName: Translation.tr("Draggable"),
                            icon: "drag_pan",
                            value: "free"
                        },
                        {
                            displayName: Translation.tr("Least busy"),
                            icon: "category",
                            value: "leastBusy"
                        },
                        {
                            displayName: Translation.tr("Most busy"),
                            icon: "shapes",
                            value: "mostBusy"
                        },
                    ]
                }
            }

            ConfigSwitch {
                buttonIcon: "lock_clock"
                text: Translation.tr("Show only when locked")
                checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.showOnlyWhenLocked
                onCheckedChanged: {
                    Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.showOnlyWhenLocked = checked;
                }
            }

            ConfigRow {
                ContentSubsection {
                    visible: !Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.showOnlyWhenLocked
                    title: Translation.tr("Clock style")
                    Layout.fillWidth: true
                    ConfigSelectionArray {
                        currentValue: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.style
                        onSelected: newValue => {
                            Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.style = newValue;
                        }
                        options: [
                            {
                                displayName: Translation.tr("Digital"),
                                icon: "timer_10",
                                value: "digital"
                            },
                            {
                                displayName: Translation.tr("Cookie"),
                                icon: "cookie",
                                value: "cookie"
                            }
                        ]
                    }
                }

                ContentSubsection {
                    title: Translation.tr("%1 style (locked)").arg(Translation.tr("Clock"))
                    Layout.fillWidth: false
                    ConfigSelectionArray {
                        currentValue: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.styleLocked
                        onSelected: newValue => {
                            Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.styleLocked = newValue;
                        }
                        options: [
                            {
                                displayName: Translation.tr("Digital"),
                                icon: "timer_10",
                                value: "digital"
                            },
                            {
                                displayName: Translation.tr("Cookie"),
                                icon: "cookie",
                                value: "cookie"
                            }
                        ]
                    }
                }
            }

            ContentSubsection {
                visible: settingsClock.digitalPresent
                title: Translation.tr("Digital clock settings")
                tooltip: Translation.tr("Font width and roundness settings are only available for some fonts like Google Sans Flex")

                ConfigRow {
                    uniform: true
                    ConfigSwitch {
                        buttonIcon: "vertical_distribute"
                        text: Translation.tr("Vertical")
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.vertical
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.vertical = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "animation"
                        text: Translation.tr("Animate time change")
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.animateChange
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.animateChange = checked;
                        }
                    }
                }

                ConfigRow {
                    uniform: true

                    ConfigSwitch {
                        buttonIcon: "date_range"
                        text: Translation.tr("Show date")
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.showDate
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.showDate = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "activity_zone"
                        text: Translation.tr("Use adaptive alignment")
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.adaptiveAlignment
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.adaptiveAlignment = checked;
                        }
                        StyledToolTip {
                            text: Translation.tr("Aligns the date and quote to left, center or right depending on its position on the screen.")
                        }
                    }
                }

                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Font family")
                    text: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.font.family
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.font.family = text;
                    }
                }

                ConfigSlider {
                    text: Translation.tr("Font weight")
                    value: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.font.weight
                    usePercentTooltip: false
                    buttonIcon: "format_bold"
                    from: 1
                    to: 1000
                    stopIndicatorValues: [350]
                    onValueChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.font.weight = value;
                    }
                }

                ConfigSlider {
                    text: Translation.tr("Font size")
                    value: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.font.size
                    usePercentTooltip: false
                    buttonIcon: "format_size"
                    from: 50
                    to: 700
                    stopIndicatorValues: [90]
                    onValueChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.font.size = value;
                    }
                }

                ConfigSlider {
                    text: Translation.tr("Font width")
                    value: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.font.width
                    usePercentTooltip: false
                    buttonIcon: "fit_width"
                    from: 25
                    to: 125
                    stopIndicatorValues: [100]
                    onValueChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.font.width = value;
                    }
                }
                ConfigSlider {
                    text: Translation.tr("Font roundness")
                    value: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.font.roundness
                    usePercentTooltip: false
                    buttonIcon: "line_curve"
                    from: 0
                    to: 100
                    onValueChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.digital.font.roundness = value;
                    }
                }
            }

            ContentSubsection {
                visible: settingsClock.cookiePresent
                title: Translation.tr("Cookie clock settings")

                ConfigSwitch {
                    buttonIcon: "wand_stars"
                    text: Translation.tr("Auto styling with Gemini")
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.aiStyling
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.aiStyling = checked;
                    }
                    StyledToolTip {
                        text: Translation.tr("Uses Gemini to categorize the wallpaper then picks a preset based on it.\nYou'll need to set Gemini API key on the left sidebar first.\nImages are downscaled for performance, but just to be safe,\ndo not select wallpapers with sensitive information.")
                    }
                }

                ConfigSwitch {
                    buttonIcon: "airwave"
                    text: Translation.tr("Use old sine wave cookie implementation")
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.useSineCookie
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.useSineCookie = checked;
                    }
                    StyledToolTip {
                        text: "Looks a bit softer and more consistent with different number of sides,\nbut has less impressive morphing"
                    }
                }

                ConfigSpinBox {
                    icon: "add_triangle"
                    text: Translation.tr("Sides")
                    value: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.sides
                    from: 0
                    to: 40
                    stepSize: 1
                    onValueChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.sides = value;
                    }
                }

                ConfigSwitch {
                    buttonIcon: "autoplay"
                    text: Translation.tr("Constantly rotate")
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.constantlyRotate
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.constantlyRotate = checked;
                    }
                    StyledToolTip {
                        text: "Makes the clock always rotate. This is extremely expensive\n(expect 50% usage on Intel UHD Graphics) and thus impractical."
                    }
                }

                ConfigRow {

                    ConfigSwitch {
                        enabled: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.dialNumberStyle === "dots" || Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.dialNumberStyle === "full"
                        buttonIcon: "brightness_7"
                        text: Translation.tr("Hour marks")
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.hourMarks
                        onEnabledChanged: {
                            checked = Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.hourMarks;
                        }
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.hourMarks = checked;
                        }
                        StyledToolTip {
                            text: "Can only be turned on using the 'Dots' or 'Full' dial style for aesthetic reasons"
                        }
                    }

                    ConfigSwitch {
                        enabled: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.dialNumberStyle !== "numbers"
                        buttonIcon: "timer_10"
                        text: Translation.tr("Digits in the middle")
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.timeIndicators
                        onEnabledChanged: {
                            checked = Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.timeIndicators;
                        }
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.timeIndicators = checked;
                        }
                        StyledToolTip {
                            text: "Can't be turned on when using 'Numbers' dial style for aesthetic reasons"
                        }
                    }
                }
            }

            ContentSubsection {
                visible: settingsClock.cookiePresent
                title: Translation.tr("%1 style").arg(Translation.tr("Dial"))
                ConfigSelectionArray {
                    currentValue: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.dialNumberStyle
                    onSelected: newValue => {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.dialNumberStyle = newValue;
                        if (newValue !== "dots" && newValue !== "full") {
                            Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.hourMarks = false;
                        }
                        if (newValue === "numbers") {
                            Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.timeIndicators = false;
                        }
                    }
                    options: [
                        {
                            displayName: "",
                            icon: "block",
                            value: "none"
                        },
                        {
                            displayName: Translation.tr("Dots"),
                            icon: "graph_6",
                            value: "dots"
                        },
                        {
                            displayName: Translation.tr("Full"),
                            icon: "history_toggle_off",
                            value: "full"
                        },
                        {
                            displayName: Translation.tr("Numbers"),
                            icon: "counter_1",
                            value: "numbers"
                        }
                    ]
                }
            }

            ContentSubsection {
                visible: settingsClock.cookiePresent
                title: Translation.tr("Hour hand")
                ConfigSelectionArray {
                    currentValue: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.hourHandStyle
                    onSelected: newValue => {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.hourHandStyle = newValue;
                    }
                    options: [
                        {
                            displayName: "",
                            icon: "block",
                            value: "hide"
                        },
                        {
                            displayName: Translation.tr("Classic"),
                            icon: "radio",
                            value: "classic"
                        },
                        {
                            displayName: Translation.tr("Hollow"),
                            icon: "circle",
                            value: "hollow"
                        },
                        {
                            displayName: Translation.tr("Fill"),
                            icon: "eraser_size_5",
                            value: "fill"
                        },
                    ]
                }
            }

            ContentSubsection {
                visible: settingsClock.cookiePresent
                title: Translation.tr("Minute hand")

                ConfigSelectionArray {
                    currentValue: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.minuteHandStyle
                    onSelected: newValue => {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.minuteHandStyle = newValue;
                    }
                    options: [
                        {
                            displayName: "",
                            icon: "block",
                            value: "hide"
                        },
                        {
                            displayName: Translation.tr("Classic"),
                            icon: "radio",
                            value: "classic"
                        },
                        {
                            displayName: Translation.tr("Thin"),
                            icon: "line_end",
                            value: "thin"
                        },
                        {
                            displayName: Translation.tr("Medium"),
                            icon: "eraser_size_2",
                            value: "medium"
                        },
                        {
                            displayName: Translation.tr("Bold"),
                            icon: "eraser_size_4",
                            value: "bold"
                        },
                    ]
                }
            }

            ContentSubsection {
                visible: settingsClock.cookiePresent
                title: Translation.tr("Second hand")

                ConfigSelectionArray {
                    currentValue: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.secondHandStyle
                    onSelected: newValue => {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.secondHandStyle = newValue;
                    }
                    options: [
                        {
                            displayName: "",
                            icon: "block",
                            value: "hide"
                        },
                        {
                            displayName: Translation.tr("Classic"),
                            icon: "radio",
                            value: "classic"
                        },
                        {
                            displayName: Translation.tr("Line"),
                            icon: "line_end",
                            value: "line"
                        },
                        {
                            displayName: Translation.tr("Dot"),
                            icon: "adjust",
                            value: "dot"
                        },
                    ]
                }
            }

            ContentSubsection {
                visible: settingsClock.cookiePresent
                title: Translation.tr("%1 style").arg(Translation.tr("Date"))

                ConfigSelectionArray {
                    currentValue: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.dateStyle
                    onSelected: newValue => {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.cookie.dateStyle = newValue;
                    }
                    options: [
                        {
                            displayName: "",
                            icon: "block",
                            value: "hide"
                        },
                        {
                            displayName: Translation.tr("Bubble"),
                            icon: "bubble_chart",
                            value: "bubble"
                        },
                        {
                            displayName: Translation.tr("Border"),
                            icon: "rotate_right",
                            value: "border"
                        },
                        {
                            displayName: Translation.tr("Rect"),
                            icon: "rectangle",
                            value: "rect"
                        }
                    ]
                }
            }

            ContentSubsection {
                title: Translation.tr("Quote")

                ConfigSwitch {
                    buttonIcon: "check"
                    text: Translation.tr("Enable")
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.quote.enable
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.quote.enable = checked;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Quote")
                    text: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.quote.text
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.clock.quote.text = text;
                    }
                }
            }
        }

        ContentSection {
            icon: "weather_mix"
            title: Translation.tr("Widget: %1").arg(Translation.tr("Weather"))

            ConfigRow {
                Layout.fillWidth: true

                ConfigSwitch {
                    Layout.fillWidth: false
                    buttonIcon: "check"
                    text: Translation.tr("Enable")
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.weather.enable
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.weather.enable = checked;
                    }
                }
                Item {
                    Layout.fillWidth: true
                }
                ConfigSelectionArray {
                    Layout.fillWidth: false
                    currentValue: Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.weather.placementStrategy
                    onSelected: newValue => {
                        Config.options.monitor[monitorSelector.currentIndex].output.background.widgets.weather.placementStrategy = newValue;
                    }
                    options: [
                        {
                            displayName: Translation.tr("Draggable"),
                            icon: "drag_pan",
                            value: "free"
                        },
                        {
                            displayName: Translation.tr("Least busy"),
                            icon: "category",
                            value: "leastBusy"
                        },
                        {
                            displayName: Translation.tr("Most busy"),
                            icon: "shapes",
                            value: "mostBusy"
                        },
                    ]
                }
            }
        }
    }

    ConfigSwitch {
        id: panelSwitch
        buttonIcon: "toast"
        iconRotation: 180
        text: Translation.tr("Enable %1").arg(Translation.tr("Bar"))
        checked: !Config.options.monitor[monitorSelector.currentIndex].output.panel.disabled
        onCheckedChanged: {
            Config.options.monitor[monitorSelector.currentIndex].output.panel.disabled = !checked;
        }
    }

    ContentSection {
        visible: panelSwitch.checked

        ContentSection {
            icon: "family_restroom"
            title: Translation.tr("Panel family")

            ColumnLayout {
                ConfigSelectionArray {
                    id: panelFamilyOptions
                    currentValue: {
                        return Config.options.monitor[monitorSelector.currentIndex].output.panel.tools.findIndex(tool => tool.bar.name === Config.options.monitor[monitorSelector.currentIndex].output.panel.family);
                    }
                    onSelected: newValue => {
                        Config.options.monitor[monitorSelector.currentIndex].output.panel.family = Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[newValue].bar.name;
                    }
                    options: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools.map((tool, index) => {
                        return {
                            displayName: tool.bar.name,
                            value: index
                        };
                    })
                }
            }
        }

        ContentSection {
            visible: Config.options.monitor[monitorSelector.currentIndex].output.panel.family === "ii"

            ContentSection {
                icon: "notifications"
                title: Translation.tr("Notifications")
                ConfigSwitch {
                    buttonIcon: "counter_2"
                    text: Translation.tr("Unread indicator: show count")
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.indicators.notifications.showUnreadCount
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.indicators.notifications.showUnreadCount = checked;
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
                            currentValue: (Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.bottom ? 1 : 0) | (Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.vertical ? 2 : 0)
                            onSelected: newValue => {
                                Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.bottom = (newValue & 1) !== 0;
                                Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.vertical = (newValue & 2) !== 0;
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
                            currentValue: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.autoHide.enable
                            onSelected: newValue => {
                                Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.autoHide.enable = newValue;
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
                            currentValue: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.cornerStyle
                            onSelected: newValue => {
                                Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.cornerStyle = newValue;
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
                            currentValue: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.borderless
                            onSelected: newValue => {
                                Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.borderless = newValue;
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
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showScreenSnip
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showScreenSnip = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "colorize"
                        text: Translation.tr("Color picker")
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showColorPicker
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showColorPicker = checked;
                        }
                    }
                }
                ConfigRow {
                    uniform: true
                    ConfigSwitch {
                        buttonIcon: "keyboard"
                        text: Translation.tr("Keyboard toggle")
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showKeyboardToggle
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showKeyboardToggle = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "mic"
                        text: Translation.tr("Mic toggle")
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showMicToggle
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showMicToggle = checked;
                        }
                    }
                }
                ConfigRow {
                    uniform: true
                    ConfigSwitch {
                        buttonIcon: "dark_mode"
                        text: Translation.tr("Dark/Light toggle")
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showDarkModeToggle
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showDarkModeToggle = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "speed"
                        text: Translation.tr("Performance Profile toggle")
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showPerformanceProfileToggle
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showPerformanceProfileToggle = checked;
                        }
                    }
                }
                ConfigRow {
                    uniform: true
                    ConfigSwitch {
                        buttonIcon: "videocam"
                        text: Translation.tr("Record")
                        checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showScreenRecord
                        onCheckedChanged: {
                            Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.utilButtons.showScreenRecord = checked;
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
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.weather.enable
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.weather.enable = checked;
                    }
                }
            }

            ContentSection {
                icon: "workspaces"
                title: Translation.tr("Workspaces")

                ConfigSwitch {
                    buttonIcon: "counter_1"
                    text: Translation.tr('Always show numbers')
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.workspaces.alwaysShowNumbers
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.workspaces.alwaysShowNumbers = checked;
                    }
                }

                ConfigSwitch {
                    buttonIcon: "award_star"
                    text: Translation.tr('Show app icons')
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.workspaces.showAppIcons
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.workspaces.showAppIcons = checked;
                    }
                }

                ConfigSwitch {
                    buttonIcon: "colors"
                    text: Translation.tr('Tint app icons')
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.workspaces.monochromeIcons
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.workspaces.monochromeIcons = checked;
                    }
                }

                ConfigSpinBox {
                    icon: "view_column"
                    text: Translation.tr("Workspaces shown")
                    value: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.workspaces.shown
                    from: 1
                    to: 30
                    stepSize: 1
                    onValueChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.workspaces.shown = value;
                    }
                }

                ConfigSpinBox {
                    icon: "touch_long"
                    text: Translation.tr("Number show delay when pressing Super (ms)")
                    value: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.workspaces.showNumberDelay
                    from: 0
                    to: 1000
                    stepSize: 50
                    onValueChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.workspaces.showNumberDelay = value;
                    }
                }

                ContentSubsection {
                    title: Translation.tr("%1 style").arg(Translation.tr("Number"))

                    ConfigSelectionArray {
                        currentValue: JSON.stringify(Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.workspaces.numberMap)
                        onSelected: newValue => {
                            Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.workspaces.numberMap = JSON.parse(newValue)
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
                    checked: Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.tooltips.clickToShow
                    onCheckedChanged: {
                        Config.options.monitor[monitorSelector.currentIndex].output.panel.tools[panelFamilyOptions.currentValue].bar.config.tooltips.clickToShow = checked;
                    }
                }
            }
        }
    }

}
