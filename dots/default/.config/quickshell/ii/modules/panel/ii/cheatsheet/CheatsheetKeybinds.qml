pragma ComponentBehavior: Bound

import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    readonly property var keybinds: HyprlandKeybinds.keybinds
    property real spacing: 20
    property real titleSpacing: 7
    property real padding: 4
    implicitWidth: row.implicitWidth + padding * 2
    implicitHeight: row.implicitHeight + padding * 2
    // Excellent symbol explaination and source :
    // http://xahlee.info/comp/unicode_computing_symbols.html
    // https://www.nerdfonts.com/cheat-sheet
    property var macSymbolMap: ({
        "Ctrl":      "󰘴",
        "Alt":       "󰘵",
        "Shift":     "󰘶",
        "Space":     "󱁐",
        "Tab":       "↹",
        "Equal":     "",
        "Plus":      "",
        "Minus":     "",
        "Print":     "",
        "BackSpace": "󰭜",
        "Delete":    "⌦",
        "Return":    "󰌑",
        "Period":    ".",
        "Escape":    "⎋",
        "Page_up":   "⇞",
        "Page_down": "⇟"
      })
    property var functionSymbolMap: ({
        "F1":  "󱊫",
        "F2":  "󱊬",
        "F3":  "󱊭",
        "F4":  "󱊮",
        "F5":  "󱊯",
        "F6":  "󱊰",
        "F7":  "󱊱",
        "F8":  "󱊲",
        "F9":  "󱊳",
        "F10": "󱊴",
        "F11": "󱊵",
        "F12": "󱊶",
    })

    property var mouseSymbolMap: ({
        "mouse_up":   "󱕐",
        "mouse_down": "󱕑",
        "mouse:272":  "L 󰍽",
        "mouse:273":  "󰍽 R",
        "mouse:275":  "󰁍 󰍽",
        "mouse:276":  "󰁔 󰍽",
    })

    property var arrowSymbolMap: ({
        "Up":    "󰁝",
        "Down":  "󰁅",
        "Left":  "󰁍",
        "Right": "󰁔"
    })

    property var pageSymbolMap: ({
        "Page_up":   "󰮰",
        "Page_down": "󰮲"
    })

    property var keyBlacklist: ["Super_L"]
    property var keySubstitutions: Object.assign({
        "mouse_up":   "Scroll ↓",  // ikr, weird
        "mouse_down": "Scroll ↑",  // trust me bro
        "Page_up":    "Page ↑",
        "Page_down":  "Page ↓",
        "mouse:272":  "LMB",
        "mouse:273":  "RMB",
        "mouse:275":  "Mouse 󰁍",
        "mouse:276":  "Mouse 󰁔",
        "Slash":      "/",
        "Backslash":  "\\",
        "Hash":       "#",
        "Return":     "↵",
        "Equal":      "=",
        "Plus":       "+",
        "Minus":      "-"
      },
      !!Config.options.cheatsheet.superKey ? {
          "Super": Config.options.cheatsheet.superKey,
      }: {},
      Config.options.cheatsheet.useMacSymbol ? macSymbolMap : {},
      Config.options.cheatsheet.useFnSymbol ? functionSymbolMap : {},
      Config.options.cheatsheet.useMouseSymbol ? mouseSymbolMap : {},
      Config.options.cheatsheet.useArrowSymbol ? arrowSymbolMap : {},
      Config.options.cheatsheet.usePageSymbol ? pageSymbolMap : {}
    )

    // Helper function to safely extract keys from a JavaScript object
    function getKeys(obj) {
        return (obj && typeof obj === "object") ? Object.keys(obj) : [];
    }

    ScrollView {
        id: mainScrollView
        anchors.fill: parent
        clip: true

        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        contentWidth: row.implicitWidth + row.leftPadding + row.rightPadding
        contentHeight: row.implicitHeight + row.topPadding + row.bottomPadding

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
                } else wheel.accepted = false;
            }
        }

        Row {
            id: row
            spacing: root.spacing
            topPadding: 15
            bottomPadding: 15
            leftPadding: 15
            rightPadding: 15

            // Level 1: Categories (Columns)
            Repeater {
                model: root.getKeys(root.keybinds)
                delegate: Column {
                    id: categoryColumn
                    spacing: root.spacing
                    required property string modelData 
                    anchors.top: parent.top

                    StyledText {
                        font {
                            family: Appearance.font.family.title
                            pixelSize: Appearance.font.pixelSize.title + 2
                            variableAxes: Appearance.font.variableAxes.title
                        }
                        color: Appearance.colors.colOnLayer0
                        text: categoryColumn.modelData.toUpperCase()
                    }

                    // Level 2: Subcategories
                    Repeater {
                        model: root.getKeys(root.keybinds[categoryColumn.modelData] || {})
                        delegate: Item {
                            id: keybindSection
                            required property string modelData 

                            readonly property var subcatObject: {
                                var cat = root.keybinds[categoryColumn.modelData];
                                return (cat && cat[keybindSection.modelData]) ? cat[keybindSection.modelData] : {};
                            }

                            readonly property var descriptionsList: root.getKeys(keybindSection.subcatObject)

                            implicitWidth: sectionColumn.implicitWidth
                            implicitHeight: sectionColumn.implicitHeight

                            Column {
                                id: sectionColumn
                                spacing: root.titleSpacing

                                StyledText {
                                    font {
                                        family: Appearance.font.family.title
                                        pixelSize: Appearance.font.pixelSize.larger
                                        variableAxes: Appearance.font.variableAxes.title
                                    }
                                    color: Appearance.colors.colOnLayer0
                                    text: "    " + keybindSection.modelData
                                }

                                Column {
                                    id: descriptionsContainer
                                    spacing: 12
                                    leftPadding: 24

                                    // Level 3: Descriptions
                                    Repeater {
                                        model: keybindSection.descriptionsList

                                        delegate: Column {
                                            id: descBlock
                                            required property string modelData 
                                            spacing: 6

                                            // Translates and strictly filters out blacklisted keys
                                            function processBind(bindArray) {
                                                if (!Array.isArray(bindArray)) return [];
                                                var processedKeys = [];
                                                var lowerBlacklist = root.keyBlacklist.map(function(k) { 
                                                    return String(k).trim().toLowerCase(); 
                                                });

                                                for (var i = 0; i < bindArray.length; i++) {
                                                    var rawKey = bindArray[i];
                                                    if (rawKey === undefined || rawKey === null) continue;
                                                    var cleanKey = String(rawKey).trim();
                                                    if (lowerBlacklist.indexOf(cleanKey.toLowerCase()) !== -1) continue;
                                                    
                                                    if (root.keySubstitutions[cleanKey] !== undefined) {
                                                        processedKeys.push(root.keySubstitutions[cleanKey]);
                                                    } else {
                                                        processedKeys.push(cleanKey);
                                                    }
                                                }
                                                return processedKeys;
                                            }

                                            // Pre-processes shortcuts into a Regex structural tree with numeric sorting (0-9)
                                            readonly property var regexBindsModel: {
                                                var rawBinds = keybindSection.subcatObject[descBlock.modelData];
                                                if (!Array.isArray(rawBinds)) return [];

                                                var cleanBinds = rawBinds.map(function(bind) {
                                                    return Array.isArray(bind) ? descBlock.processBind(bind) : [bind];
                                                }).filter(function(b) { return b.length > 0; });

                                                if (cleanBinds.length === 0) return [];

                                                var groupedModel = [];
                                                var currentGroup = null;

                                                for (var i = 0; i < cleanBinds.length; i++) {
                                                    var currentBind = cleanBinds[i];
                                                    var currentModifiers = currentBind.slice(0, -1);
                                                    var lastKey = currentBind[currentBind.length - 1];
                                                    var modifiersStr = currentModifiers.join("+");

                                                    if (currentGroup === null) {
                                                        currentGroup = {
                                                            modifiers: currentModifiers,
                                                            modifiersKey: modifiersStr,
                                                            variants: [lastKey]
                                                        };
                                                    } else if (currentGroup.modifiersKey === modifiersStr && currentModifiers.length > 0) {
                                                        currentGroup.variants.push(lastKey);
                                                    } else {
                                                        groupedModel.push(currentGroup);
                                                        currentGroup = {
                                                            modifiers: currentModifiers,
                                                            modifiersKey: modifiersStr,
                                                            variants: [lastKey]
                                                        };
                                                    }
                                                }
                                                if (currentGroup !== null) {
                                                    groupedModel.push(currentGroup);
                                                }

                                                // Post-process groups to sort numeric keys sequentially from 0 to 9
                                                return groupedModel.map(function(group) {
                                                    if (group.variants.length > 1) {
                                                        // Enforce strict ascending order where '0' is evaluated as the lowest digit
                                                        group.variants.sort(function(a, b) {
                                                            var numA = parseInt(a, 10);
                                                            var numB = parseInt(b, 10);
                                                            if (!isNaN(numA) && !isNaN(numB)) {
                                                                return numA - numB;
                                                            }
                                                            return String(a).localeCompare(String(b));
                                                        });

                                                        var digitsMap = {};
                                                        var numericCount = 0;
                                                        
                                                        for (var j = 0; j < group.variants.length; j++) {
                                                            var v = group.variants[j];
                                                            if (/^[0-9]$/.test(v) && !digitsMap[v]) {
                                                                digitsMap[v] = true;
                                                                numericCount++;
                                                            }
                                                        }
                                                        
                                                        // Flag true if all 10 standard digits are present in the sorted cluster
                                                        group.isFullNumericRange = (numericCount === 10);
                                                    } else {
                                                        group.isFullNumericRange = false;
                                                    }
                                                    return group;
                                                });
                                            }

                                            // Description Label
                                            StyledText {
                                                font.pixelSize: Config.options.cheatsheet.fontSize.comment || Appearance.font.pixelSize.smaller
                                                color: Appearance.colors.colOnLayer0
                                                text: descBlock.modelData
                                            }

                                            // Level 4: Regex-styled Shortcut Variant Groups
                                            Repeater {
                                                model: descBlock.regexBindsModel

                                                delegate: Row {
                                                    id: groupRow
                                                    spacing: 4
                                                    required property var modelData 

                                                    // 1. Render Shared Base Modifiers
                                                    Repeater {
                                                        model: groupRow.modelData.modifiers
                                                        delegate: KeyboardKey {
                                                            required property string modelData
                                                            key: modelData
                                                            pixelSize: Config.options.cheatsheet.fontSize.key
                                                        }
                                                    }

                                                    // 2. Render Full Regex Numeric Range ([0-9]) using boxes and plain text
                                                    Row {
                                                        spacing: 4
                                                        visible: groupRow.modelData.isFullNumericRange
                                                        anchors.verticalCenter: parent.verticalCenter

                                                        StyledText {
                                                            text: "["
                                                            color: Appearance.colors.colOnLayer0
                                                            font.pixelSize: Config.options.cheatsheet.fontSize.comment || Appearance.font.pixelSize.smaller
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }

                                                        KeyboardKey {
                                                            key: groupRow.modelData.variants[0] || ""
                                                            pixelSize: Config.options.cheatsheet.fontSize.key
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }

                                                        StyledText {
                                                            text: "-"
                                                            color: Appearance.colors.colOnLayer0
                                                            font.pixelSize: Config.options.cheatsheet.fontSize.comment || Appearance.font.pixelSize.smaller
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }

                                                        KeyboardKey {
                                                            key: groupRow.modelData.variants[groupRow.modelData.variants.length - 1] || ""
                                                            pixelSize: Config.options.cheatsheet.fontSize.key
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }

                                                        StyledText {
                                                            text: "]"
                                                            color: Appearance.colors.colOnLayer0
                                                            font.pixelSize: Config.options.cheatsheet.fontSize.comment || Appearance.font.pixelSize.smaller
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }
                                                    }

                                                    // 3. Render Multi-variant Branching (a|b|c) if it's not a full numeric range
                                                    Row {
                                                        spacing: 4
                                                        visible: groupRow.modelData.variants.length > 1 && !groupRow.modelData.isFullNumericRange
                                                        
                                                        StyledText {
                                                            text: "("
                                                            color: Appearance.colors.colOnLayer0
                                                            font.pixelSize: Config.options.cheatsheet.fontSize.comment || Appearance.font.pixelSize.smaller
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }

                                                        Repeater {
                                                            model: groupRow.modelData.variants
                                                            delegate: Row {
                                                                spacing: 4
                                                                required property string modelData
                                                                required property int index

                                                                StyledText {
                                                                    text: "|"
                                                                    visible: parent.index > 0
                                                                    color: Appearance.colors.colOnLayer0
                                                                    font.pixelSize: Config.options.cheatsheet.fontSize.comment || Appearance.font.pixelSize.smaller
                                                                    anchors.verticalCenter: parent.verticalCenter
                                                                }

                                                                KeyboardKey {
                                                                    key: parent.modelData
                                                                    pixelSize: Config.options.cheatsheet.fontSize.key
                                                                }
                                                            }
                                                        }

                                                        StyledText {
                                                            text: ")"
                                                            color: Appearance.colors.colOnLayer0
                                                            font.pixelSize: Config.options.cheatsheet.fontSize.comment || Appearance.font.pixelSize.smaller
                                                            anchors.verticalCenter: parent.verticalCenter
                                                        }
                                                    }

                                                    // 4. Fallback: Standalone key rendering for single actions
                                                    KeyboardKey {
                                                        visible: groupRow.modelData.variants.length === 1
                                                        key: groupRow.modelData.variants[0] || ""
                                                        pixelSize: Config.options.cheatsheet.fontSize.key
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
