require("hyprland.lib")
require("hyprland.variables")
if is_file_exists(HOME .. "/.config/hypr/custom/variables.lua") then
    require("custom.variables")
end

modKey = "SUPER" --# GLOBAL MAIN MODKEY

local qsScripts = "$HOME/.config/quickshell/$qsConfig/scripts"
local hyprScripts = "$HOME/.config/hypr/hyprland/scripts"
local qsIpcCall = "qs -c $qsConfig ipc call"
local qsIsAlive = qsIpcCall .. " TEST_ALIVE"

-- Setup utility commands
local grimhyprctl = "grim -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\""
local mediaNextCommand = "playerctl next || playerctl position `bc <<< \"100 * $(playerctl metadata mpris:length) / 1000000 / 100\"`"

-- =============================================================================
-- Hierarchical Keybinds Configuration (Base Table)
-- =============================================================================
local keybinds_config = {
    {
        category = "Shell",
        subcategories = {
            {
                name = "Search",
                binds = {
                    {
                        keys = modKey .. " + " .. modKey .. "_L",
                        dsp = hl.dsp.global("quickshell:searchToggleRelease"),
                        desc = "Toggle search"
                    },
                    {
                        keys = modKey .. " + " .. modKey .. "_R",
                        dsp = hl.dsp.global("quickshell:searchToggleRelease")
                    },
                    {
                        keys = modKey .. " + " .. modKey .. "_L",
                        dsp = hl.dsp.exec_cmd(qsIsAlive .. " || pkill fuzzel || fuzzel")
                    },
                    {
                        keys = modKey .. " + " .. modKey .. "_R",
                        dsp = hl.dsp.exec_cmd(qsIsAlive .. " || pkill fuzzel || fuzzel")
                    }
                }
            },
            {
                name = "Workspace Infrastructure",
                binds = {
                    {
                        keys = modKey .. "_L",
                        dsp = hl.dsp.global("quickshell:workspaceNumber"),
                        opts = { ignore_mods = true, transparent = true }
                    },
                    {
                        keys = modKey .. "_R",
                        dsp = hl.dsp.global("quickshell:workspaceNumber"),
                        opts = { ignore_mods = true, transparent = true }
                    },
                    {
                        keys = modKey .. "_L",
                        dsp = hl.dsp.global("quickshell:workspaceNumber"),
                        opts = { ignore_mods = true, transparent = true, release = true }
                    },
                    {
                        keys = modKey .. "_R",
                        dsp = hl.dsp.global("quickshell:workspaceNumber"),
                        opts = { ignore_mods = true, transparent = true, release = true }
                    }
                }
            },
            {
                name = "Interface Toggles",
                binds = {
                    {
                        keys = modKey .. " + V",
                        dsp = hl.dsp.global("quickshell:overviewClipboardToggle"),
                    },
                    {
                        keys = modKey .. " + Period",
                        dsp = hl.dsp.global("quickshell:overviewEmojiToggle"),
                    },
                    {
                        keys = modKey .. " + ALT + A",
                        dsp = hl.dsp.global("quickshell:sidebarLeftToggleDetach"),
                    },
                    {
                        keys = "CTRL + ALT + Delete",
                        dsp = hl.dsp.exec_cmd(qsIsAlive .. " || pkill wlogout || wlogout -p layer-shell"),
                    },
                    {
                        keys = modKey .. " + SHIFT + ALT + H",
                        dsp = hl.dsp.exec_cmd("qs -p $HOME/.config/quickshell/$qsConfig/welcome.qml"),
                    },
                    {
                        keys = modKey .. " + Tab",
                        dsp = hl.dsp.global("quickshell:overviewWorkspacesToggle"),
                        desc = "Toggle overview"
                    },
                    {
                        keys = modKey .. " + B",
                        dsp = hl.dsp.global("quickshell:barToggle"),
                        desc = "Toggle bar"
                    },
                    {
                        keys = modKey .. " + CTRL + B",
                        dsp = hl.dsp.global("quickshell:sidebarLeftToggle"),
                        desc = "Toggle left sidebar"
                    },
                    {
                        keys = modKey .. " + ALT + B",
                        dsp = hl.dsp.global("quickshell:sidebarRightToggle"),
                        desc = "Toggle right sidebar"
                    },
                    {
                        keys = modKey .. " + H",
                        dsp = hl.dsp.global("quickshell:cheatsheetToggle"),
                        desc = "Toggle cheatsheet"
                    },
                    {
                        keys = modKey .. " + K",
                        dsp = hl.dsp.global("quickshell:oskToggle"),
                        desc = "Toggle on-screen keyboard"
                    },
                    {
                        keys = modKey .. " + SHIFT + M",
                        dsp = hl.dsp.global("quickshell:mediaControlsToggle"),
                        desc = "Toggle media controls"
                    },
                    {
                        keys = modKey .. " + SHIFT + O",
                        dsp = hl.dsp.global("quickshell:overlayToggle"),
                        desc = "Toggle widget overlay"
                    },
                    {
                        keys = "CTRL + ALT + Delete",
                        dsp = hl.dsp.global("quickshell:sessionToggle"),
                        desc = "Toggle session menu"
                    }
                }
            },
            {
                name = "Environment Controls",
                binds = {
                    {
                        keys = "XF86MonBrightnessUp",
                        dsp = hl.dsp.exec_cmd(qsIpcCall .. " brightness increment || brightnessctl s 5%+"),
                        opts = { locked = true, repeating = true }
                    },
                    {
                        keys = "XF86MonBrightnessDown",
                        dsp = hl.dsp.exec_cmd(qsIpcCall .. " brightness decrement || brightnessctl s 5%-"),
                        opts = { locked = true, repeating = true }
                    },
                    {
                        keys = "XF86AudioRaiseVolume",
                        dsp = hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.5"),
                        opts = { locked = true, repeating = true }
                    },
                    {
                        keys = "XF86AudioLowerVolume",
                        dsp = hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"),
                        opts = { locked = true, repeating = true }
                    },
                    {
                        keys = modKey .. " + CTRL + SHIFT + D",
                        dsp = hl.dsp.global("quickshell:toggleLightDark"),
                        desc = "Toggle light/dark mode"
                    },
                    {
                        keys = modKey .. " + CTRL + R",
                        dsp = hl.dsp.exec_cmd("killall ydotool qs quickshell; qs -c $qsConfig &"),
                        desc = "Restart widgets"
                    },
                    {
                        keys = modKey .. " + CTRL + P",
                        dsp = hl.dsp.global("quickshell:panelFamilyCycle"),
                        desc = "Change panel family"
                    }
                }
            }
        }
    },
    {
        category = "Utilities",
        subcategories = {
            {
                name = "Clipboard",
                binds = {
                    {
                        keys = modKey .. " + V",
                        dsp = hl.dsp.exec_cmd(qsIsAlive .. " || pkill fuzzel || cliphist list | fuzzel --match-mode fzf --dmenu | cliphist decode | wl-copy"),
                        desc = "History"
                    },
                    {
                        keys = modKey .. " + Period",
                        dsp = hl.dsp.exec_cmd(qsIsAlive .. " || pkill fuzzel || " .. hyprScripts .. "/fuzzel-emoji.sh copy"),
                        desc = "Emoji"
                    }
                }
            },
            {
                name = "Screen Tasks",
                binds = {
                    {
                        keys = modKey .. " + SHIFT + C",
                        dsp = hl.dsp.exec_cmd("hyprpicker -a"),
                        desc = "Pick color"
                    },
                    {
                        keys = modKey .. " + SHIFT + X",
                        dsp = hl.dsp.global("quickshell:regionOcr"),
                        desc = "Character recognition"
                    },
                    {
                        keys = modKey .. " + SHIFT + A",
                        dsp = hl.dsp.global("quickshell:regionSearch"),
                        desc = "Google Lens"
                    },
                    {
                        keys = modKey .. " + SHIFT + T",
                        dsp = hl.dsp.global("quickshell:screenTranslate"),
                        desc = "Translate screen content"
                    }
                }
            },
            {
                name = "Recording",
                binds = {
                    {
                        keys = modKey .. " + SHIFT + R",
                        dsp = hl.dsp.global("quickshell:regionRecord"),
                        opts = { locked = true },
                        desc = "Record region (no sound)"
                    },
                    {
                        keys = modKey .. " + ALT + SHIFT + R",
                        dsp = hl.dsp.exec_cmd(qsScripts .. "/videos/record.sh --fullscreen"),
                        opts = { locked = true },
                        desc = "Record fullscreen (no sound)"
                    },
                    {
                        keys = modKey .. " + ALT + CTRL + R",
                        dsp = hl.dsp.exec_cmd(qsScripts .. "/videos/record.sh --fullscreen --sound"),
                        opts = { locked = true },
                        desc = "Record fullscreen"
                    }
                }
            },
            {
                name = "Screenshot Management",
                binds = {
                    {
                        keys = "Print",
                        dsp = hl.dsp.exec_cmd(grimhyprctl .. " - | wl-copy"),
                        opts = { locked = true },
                        desc = "Screenshot"
                    },
                    {
                        keys = modKey .. " + SHIFT + Print",
                        dsp = hl.dsp.global("quickshell:regionScreenshot"),
                        desc = "Screenshot region"
                    },
                    {
                        keys = modKey .. " + CTRL + Print",
                        dsp = hl.dsp.exec_cmd("mkdir -p $(xdg-user-dir PICTURES)/Screenshots && " .. grimhyprctl .. " $(xdg-user-dir PICTURES)/Screenshots/Screenshot_\"$(date '+%Y-%m-%d_%H.%M.%S')\".png"),
                        opts = { locked = true, non_consuming = true },
                        desc = "Screenshot fullscreen file and copy to clipboard"
                    },
                    {
                        keys = modKey .. " + CTRL + Print",
                        dsp = hl.dsp.exec_cmd(grimhyprctl .. " - | wl-copy"),
                        opts = { locked = true, non_consuming = true }
                    }
                }
            },
            {
                name = "Artificial Intelligence",
                binds = {
                    {
                        keys = modKey .. " + SHIFT + ALT + mouse:273",
                        dsp = hl.dsp.exec_cmd(hyprScripts .. "/ai/primary-buffer-query.sh"),
                        desc = "Generate AI summary for selected text"
                    }
                }
            }
        }
    },
    {
        category = "Screen",
        subcategories = {
            { name = "Desktop Zoom", binds = {
                {
                    keys = modKey .. " + CTRL + Equal",
                    dsp = function() zoomfunction(0.3) end,
                    opts = { repeating = true },
                    desc = "Zoom in/out"
                },
                {
                    keys = modKey .. " + CTRL + Plus",
                    dsp = function() zoomfunction(0.3) end,
                    opts = { repeating = true },
                    desc = "Zoom in/out"
                },
                {
                    keys = modKey .. " + CTRL + code:35",
                    dsp = function() zoomfunction(0.3) end,
                    opts = { repeating = true }
                },
                {
                    keys = modKey .. " + CTRL + code:86",
                    dsp = function() zoomfunction(0.3) end,
                    opts = { repeating = true }
                },
                {
                    keys = modKey .. " + CTRL + Minus",
                    dsp = function() zoomfunction(-0.3) end,
                    opts = { repeating = true },
                    desc = "Zoom in/out"
                },
                {
                    keys = modKey .. " + CTRL + code:82",
                    dsp = function() zoomfunction(-0.3) end,
                    opts = { repeating = true }
                }
            } }
        }
    },
    {
        category = "Media",
        subcategories = {
            {
                name = "Track Control",
                binds = {
                    {
                        keys = modKey .. " + SHIFT + N",
                        dsp = hl.dsp.exec_cmd(mediaNextCommand),
                        opts = { locked = true },
                        desc = "Next track"
                    },
                    {
                        keys = modKey .. " + SHIFT + mouse:276",
                        dsp = hl.dsp.exec_cmd(mediaNextCommand),
                        desc = "Next track"
                    },
                    {
                        keys = "XF86AudioNext",
                        dsp = hl.dsp.exec_cmd(mediaNextCommand),
                        opts = { locked = true }
                    },
                    {
                        keys = modKey .. " + SHIFT + B",
                        dsp = hl.dsp.exec_cmd("playerctl previous"),
                        opts = { locked = true },
                        desc = "Previous track"
                    },
                    {
                        keys = modKey .. " + SHIFT + mouse:275",
                        dsp = hl.dsp.exec_cmd("playerctl previous"),
                        desc = "Previous track" 
                    },
                    {
                        keys = "XF86AudioPrev",
                        dsp = hl.dsp.exec_cmd("playerctl previous"),
                        opts = { locked = true }
                    },
                    {
                        keys = modKey .. " + SHIFT + P",
                        dsp = hl.dsp.exec_cmd("playerctl play-pause"),
                        opts = { locked = true },
                        desc = "Play/pause media"
                    },
                    {
                        keys = "XF86AudioPlay",
                        dsp = hl.dsp.exec_cmd("playerctl play"),
                        opts = { locked = true }
                    },
                    {
                        keys = "XF86AudioPause",
                        dsp = hl.dsp.exec_cmd("playerctl pause"),
                        opts = { locked = true }
                    },
                }
            },
            {
                name = "Audio Control",
                binds = {
                    {
                        keys = modKey .. " + SHIFT + M",
                        dsp = hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"),
                        opts = { locked = true },
                        desc = "Toggle audio mute"
                    },
                    {
                        keys = "XF86AudioMute",
                        dsp = hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"),
                        opts = { locked = true },
                    },
                    {
                        keys = modKey .. " + ALT + M",
                        dsp = hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"),
                        opts = { locked = true },
                        desc = "Toggle mic mute"
                    },
                    {
                        keys = "XF86AudioMicMute",
                        dsp = hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"),
                        opts = { locked = true }
                    },
                    {
                        keys = modKey .. " + Equal",
                        dsp = hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
                        opts = { repeat_key = true, locked = true },
                        desc = "Adjust Volume"
                    },
                    {
                        keys = modKey .. " + Plus",
                        dsp = hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
                        opts = { repeat_key = true, locked = true },
                        desc = "Adjust Volume"
                    },
                    {
                        keys = modKey .. " + code:35",
                        dsp = hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
                        opts = { repeat_key = true, locked = true }
                    },
                    {
                        keys = modKey .. " + code:86",
                        dsp = hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
                        opts = { repeat_key = true, locked = true }
                    },
                    {
                        keys = modKey .. " + Minus",
                        dsp = hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
                        opts = { repeat_key = true, locked = true },
                        desc = "Adjust Volume"
                    },
                    {
                        keys = modKey .. " + code:82",
                        dsp = hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
                        opts = { repeat_key = true, locked = true }
                    }
                }
            }
        }
    },
    {
        category = "Window",
        subcategories = {
            {
                name = "Mouse Manipulation",
                binds = {
                    {
                        keys = modKey .. " + mouse:272",
                        dsp = hl.dsp.window.drag(),
                        opts = { mouse = true },
                        desc = "Move"
                    },
                    {
                        keys = modKey .. " + mouse:273",
                        dsp = hl.dsp.window.resize(),
                        opts = { mouse = true },
                        desc = "Resize"
                    }
                }
            },
            {
                name = "State",
                binds = {
                    {
                        keys = modKey .. " + Q",
                        dsp = hl.dsp.window.close(),
                        desc = "Close"
                    },
                    {
                        keys = modKey .. " + SHIFT + Q",
                        dsp = hl.dsp.exec_cmd("hyprctl kill"),
                        desc = "Force close a window"
                    },
                    {
                        keys = modKey .. " + ALT + Space",
                        dsp = hl.dsp.window.float({ action = "toggle" }),
                        desc = "Float/Tile"
                    },
                    {
                        keys = modKey .. " + M",
                        dsp = hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
                        desc = "Maximize"
                    },
                    {
                        keys = modKey .. " + F",
                        dsp = hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
                        desc = "Fullscreen"
                    },
                    {
                        keys = modKey .. " + ALT + F",
                        dsp = hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }),
                        desc = "Fullscreen spoof"
                    },
                    {
                        keys = modKey .. " + P",
                        dsp = hl.dsp.window.pin(),
                        desc = "Pin"
                    }
                }
            },
            {
                name = "Scratchpad",
                binds = {
                    {
                        keys = modKey .. " + ALT + S",
                        dsp = function() hl.dispatch(hl.dsp.window.move({ workspace = "special:special", follow = false })) end,
                        desc = "Send to scratchpad"
                    },
                    {
                        keys = modKey .. " + CTRL + S",
                        dsp = hl.dsp.workspace.toggle_special("special"),
                        desc = "Toggle scratchpad view"
                    }
                }
            },
            {
                name = "Dimensional Shifting",
                binds = {
                    {
                        keys = modKey .. " + CTRL + Backslash",
                        dsp = hl.dsp.window.resize({ x = 640, y = 480, "exact" }),
                        desc = "Resize to 640x480"
                    }
                }
            },
            { name = "Focusing", binds = {} },   -- Will be populated dynamically
            { name = "Split ratio", binds = {
                {
                    keys = modKey .. " + SHIFT + Equal",
                    dsp = hl.dsp.layout("splitratio " .. (0.1)),
                    opts = { repeating = true },
                    desc = "Adjust split ratio in/out"
                },
                {
                    keys = modKey .. " + SHIFT + Plus",
                    dsp = hl.dsp.layout("splitratio " .. (0.1)),
                    opts = { repeating = true },
                    desc = "Adjust split ratio in/out"
                },
                {
                    keys = modKey .. " + SHIFT + code:35",
                    dsp = hl.dsp.layout("splitratio " .. (0.1)),
                    opts = { repeating = true }
                },
                {
                    keys = modKey .. " + SHIFT + code:86",
                    dsp = hl.dsp.layout("splitratio " .. (0.1)),
                    opts = { repeating = true }
                },
                {
                    keys = modKey .. " + SHIFT + Minus",
                    dsp = hl.dsp.layout("splitratio " .. (-0.1)),
                    opts = { repeating = true },
                    desc = "Adjust split ratio in/out"
                },
                {
                    keys = modKey .. " + SHIFT + code:82",
                    dsp = hl.dsp.layout("splitratio " .. (-0.1)),
                    opts = { repeating = true }
                }
            } }
        }
    },
    {
        category = "Workspace",
        subcategories = {
            {
                name = "Scratchpad Allocation",
                binds = {
                    {
                        keys = modKey .. " + S",
                        dsp = hl.dsp.workspace.toggle_special("special"),
                        desc = "Toggle scratchpad"
                    },
                    {
                        keys = modKey .. " + mouse:275",
                        dsp = hl.dsp.workspace.toggle_special("special"),
                        desc = "Toggle scratchpad"
                    }
                }
            },
            { name = "Switching", binds = {} }, -- Will be populated dynamically
            { name = "Special",   binds = {} }  -- Will be populated dynamically
        }
    },
    {
        category = "Session",
        subcategories = {
            {
                name = "Power Profiles",
                binds = {
                    {
                        keys = modKey .. " + CTRL + ALT + L",
                        dsp = hl.dsp.exec_cmd("loginctl lock-session"),
                        desc = "Lock session"
                    },
                    {
                        keys = modKey .. " + CTRL + ALT + T",
                        dsp = hl.dsp.exec_cmd("loginctl terminate-session self || uwsm stop"),
                        desc = "Terminate session"
                    },
                    {
                        keys = modKey .. " + CTRL + ALT + S",
                        dsp = hl.dsp.exec_cmd("systemctl suspend || loginctl suspend"),
                        opts = { locked = true },
                        desc = "Suspend"
                    },
                    {
                        keys = modKey .. " + CTRL + ALT + H",
                        dsp = hl.dsp.exec_cmd("systemctl hibernate || loginctl hibernate"),
                        opts = { locked = true },
                        desc = "Hibernate"
                    },
                    {
                        keys = modKey .. " + CTRL + ALT + R",
                        dsp = hl.dsp.exec_cmd("systemctl reboot || loginctl reboot"),
                        desc = "Reboot"
                    },
                    {
                        keys = modKey .. " + CTRL + ALT + P",
                        dsp = hl.dsp.exec_cmd("systemctl poweroff || loginctl poweroff"),
                        desc = "Poweroff"
                    }
                }
            }
        }
    },
    {
        category = "Apps",
        subcategories = {
            {
                name = "Quick Launchers",
                binds = {
                    {
                        keys = "CTRL + ALT + T",
                        dsp = function() hl.dispatch(hl.dsp.exec_cmd(terminal)) end
                    },
                    {
                        keys = modKey .. " + T",
                        dsp = function() hl.dispatch(hl.dsp.exec_cmd(terminal)) end,
                        desc = "Terminal"
                    },
                    {
                        keys = modKey .. " + E",
                        dsp = function() hl.dispatch(hl.dsp.exec_cmd(fileManager)) end,
                        desc = "File manager"
                    },
                    {
                        keys = modKey .. " + W",
                        dsp = function() hl.dispatch(hl.dsp.exec_cmd(browser)) end,
                        desc = "Browser"
                    },
                    {
                        keys = modKey .. " + C",
                        dsp = function() hl.dispatch(hl.dsp.exec_cmd(codeEditor)) end,
                        desc = "Code editor"
                    },
                    {
                        keys = modKey .. " + O",
                        dsp = function() hl.dispatch(hl.dsp.exec_cmd(officeSoftware)) end,
                        desc = "Office software"
                    },
                    {
                        keys = modKey .. " + X",
                        dsp = function() hl.dispatch(hl.dsp.exec_cmd(textEditor)) end,
                        desc = "Text editor"
                    },
                    {
                        keys = modKey .. " + CTRL + V",
                        dsp = function() hl.dispatch(hl.dsp.exec_cmd(volumeMixer)) end,
                        desc = "Volume mixer"
                    },
                    {
                        keys = modKey .. " + I",
                        dsp = function() hl.dispatch(hl.dsp.exec_cmd(settingsApp)) end,
                        desc = "Settings app"
                    },
                    {
                        keys = "CTRL + SHIFT + Escape",
                        dsp = function() hl.dispatch(hl.dsp.exec_cmd(taskManager)) end,
                        desc = "Task manager"
                    }
                }
            }
        }
    },
    {
        category = "Testing",
        subcategories = {
            {
                name = "Notification test",
                binds = {
                    {
                        keys = modKey .. " + ALT + F10",
                        dsp = hl.dsp.exec_cmd("bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | shuf -n 1); ACTION=$(notify-send \"Test notification with body image\" \"This notification should contain your user account <b>image</b> and <a href=\\\"https://discord.com/app\\\">Discord</a> <b>icon</b>. Oh and here is a random image in your Pictures folder: <img src=\\\"$RANDOM_IMAGE\\\" alt=\\\"Testing image\\\"/>\" -a \"Hyprland\" -p -h \"string:image-path:/var/lib/AccountsService/icons/$USER\" -t 6000 -i \"discord\" -A \"openImage=Profile image\" -A \"action2=Open the random image\" -A \"action3=Useless button\"); [[ $ACTION == *openImage ]] && xdg-open \"/var/lib/AccountsService/icons/$USER\"; [[ $ACTION == *action2 ]] && xdg-open \"$RANDOM_IMAGE\"'"),
                        desc = "Enriched (Complex)"
                    },
                    {
                        keys = modKey .. " + ALT + F11",
                        dsp = hl.dsp.exec_cmd("bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | shuf -n 1); ACTION=$(notify-send \"Test notification\" \"This notification should contain a random image in your <b>Pictures</b> folder and <a href=\\\"https://discord.com/app\\\">Discord</a> <b>icon</b>.\n<i>Flick right to dismiss!</i>\" -a \"Discord (fake)\" -p -h \"string:image-path:$RANDOM_IMAGE\" -t 6000 -i \"discord\" -A \"openImage=Profile image\" -A \"action2=Useless button\"); [[ $ACTION == *openImage ]] && xdg-open \"/var/lib/AccountsService/icons/$USER\"'"),
                        desc = "Enriched (Simple)"
                    },
                    {
                        keys = modKey .. " + ALT + F12",
                        dsp = hl.dsp.exec_cmd("notify-send 'Urgent notification' 'Ah hell no' -u critical -a 'Hyprland keybind'"),
                        desc = "Urgent"
                    }
                }
            }
        }
    },
    {
        category = "Virtual machines",
        subcategories = {
            {
                name = "Toggle submap",
                binds = {
                    -- Submaps require a raw function wrapper block, we register its internal initialization setup below
                }
            }
        }
    }
}

-- =============================================================================
-- Helper to Reference Target Subcategory Tables Directly
-- =============================================================================
local function get_sub_binds(cat_name, sub_name, kQuery, return_single)
    for _, cat in ipairs(keybinds_config) do
        if cat.category == cat_name then
            for _, sub in ipairs(cat.subcategories) do
                if sub.name == sub_name then
                    
                    if not kQuery or kQuery == "" then
                        return sub.binds
                    end
                    
                    local result = {}
                    for _, bind in ipairs(sub.binds) do
                        local keys_str = tostring(bind.keys or "")
                        local desc_str = tostring(bind.desc or "")
                        
                        if keys_str:find(kQuery, 1, true) or desc_str:find(kQuery, 1, true) then
                            if return_single then
                                return bind
                            end
                            table.insert(result, bind)
                        end
                    end
                    
                    return #result > 0 and result or nil
                end
            end
        end
    end
    return nil
end

-- =============================================================================
-- Injecting Procedural/Algorithmic Binds into the Tree
-- =============================================================================

;(function()
    local focus_binds = get_sub_binds("Window", "Focusing")
    
    local resize = 50
    
    for _, base in ipairs({
            {
                name = "horizontal",
                keys = {
                    "Left",
                    "Right"
                }
            },
            {
                name = "vertical",
                keys = {
                    "Up",
                    "Down"
                }
            }
        }) do
            
            local dx = ((base.name == "horizontal") and resize or 0)
            local dy = ((base.name == "vertical")   and resize or 0)
            
            for j, key in ipairs(base.keys) do
            local dir = string.lower(string.sub(key, 1, 1))
            
            local sign = ((j == 1) and -1 or 1)
            
            table.insert(focus_binds, {
                keys = modKey .. " + " .. key,
                dsp = function() hl.dispatch(hl.dsp.focus({ direction = dir })) end,
                desc = "Focus"
            })
            table.insert(focus_binds, {
                keys = modKey .. " + SHIFT + " .. key,
                dsp = function() hl.dispatch(hl.dsp.window.move({ direction = dir })) end,
                desc = "Move"
            })
            table.insert(focus_binds, {
                keys = modKey .. " + SHIFT + ALT + " .. key,
                dsp = hl.dsp.window.swap({ direction = dir }),
                desc = "Swap"
            })
            table.insert(focus_binds, {
                keys = modKey .. " + SHIFT + CTRL + " .. key,
                dsp = hl.dsp.window.resize({ x = (dx * sign), y = (dy * sign), relative = true}),
                opts = { repeating = true },
                desc = "Resize"
            })
        end
    end
end)()

-- Notification info
;(function()
    local closeKey = get_sub_binds("Window", "State", "Close", true)
    if closeKey then
        local forbidden_key = "ALT + F4"
        
        table.insert(get_sub_binds("Window", "State"), {
            keys = forbidden_key,
            dsp = hl.dsp.exec_cmd("notify-send \"Invalid Keybind: " .. forbidden_key .. "\" \"This shortcut is reserved for VMs. Use " .. closeKey.keys .. " to close windows.\" -a Hyprland"),
            opts = { non_consuming = true }
        })
    end
end)()

;(function()
    local switch_binds = get_sub_binds("Workspace", "Switching")
    local lifecycle_binds = get_sub_binds("Window", "State")
    
    -- Workspaces loop generator (1 to 10)
    for i, base in ipairs({ 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }) do
        local display_index = i % 10
        -- Send Window to Workspaces
        for _, key in ipairs({
                {
                    name = "ALT",
                    cond = true
                },
                {
                    name = "SHIFT",
                    cond = false
                }
            }) do
            table.insert(lifecycle_binds, {
                keys = modKey .. " + " .. key.name .. " + " .. display_index,
                dsp = function() hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(i), follow = key.cond })) end,
                desc = "Send to workspace" .. (key.cond and " and follow" or "")
            })
            table.insert(lifecycle_binds, {
                keys = modKey .. " + " .. key.name .. " + code:1" .. i-1,
                dsp = function() hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(i), follow = key.cond })) end
            })
            table.insert(lifecycle_binds, {
                keys = modKey .. " + " .. key.name .. " + code:" .. base,
                dsp = function() hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(i), follow = key.cond })) end
            })
        end
        -- Focus Workspaces
        table.insert(switch_binds, {
            keys = modKey .. " + " .. display_index,
            dsp = function() hl.dispatch(hl.dsp.focus({ workspace = workspace_in_group(i) })) end,
            desc = "Focus workspace"
        })
        table.insert(switch_binds, {
            keys = modKey .. " + code:1" .. i-1,
            dsp = function() hl.dispatch(hl.dsp.focus({ workspace = workspace_in_group(i) })) end
        })
        table.insert(switch_binds, {
            keys = modKey .. " + code:" .. base,
            dsp = function() hl.dispatch(hl.dsp.focus({ workspace = workspace_in_group(i) })) end
        })
    end
    
    for _, key in ipairs({
            {
                name = "Left",
                cond = "-"
            },
            {
                name = "Right",
                cond = "+"
            }
        }) do
        table.insert(lifecycle_binds, {
            keys = modKey .. " + ALT + " .. key.name,
            dsp = function() hl.dispatch(hl.dsp.window.move({ workspace = "r" .. key.cond .. "1" })) end,
            desc = "Send to workspace left/right"
        })
        table.insert(switch_binds, { keys = modKey .. " + CTRL + ALT + " .. key.name,
            dsp = function() hl.dispatch(hl.dsp.focus({ workspace = "m" .. key.cond .. "1" })) end,
            desc = "Focus busy left/right"
        })
        table.insert(switch_binds, { keys = modKey .. " + CTRL + " .. key.name,
            dsp = function() hl.dispatch(hl.dsp.focus({ workspace = "r" .. key.cond .. "1" })) end,
            desc = "Focus left/right"
        })
        table.insert(switch_binds, {
            keys = modKey .. " + CTRL + ALT + SHIFT + " .. key.name,
            dsp = function() hl.dispatch(hl.dsp.focus({ workspace = "r" .. key.cond .. "5" })) end,
            desc = "Focus left/right quick jump"
        })
    end
    for _, base in ipairs({
            "Page",
            "mouse"
        }) do for __, key in ipairs({
                {
                    name = "down",
                    cond = "-"
                },
                {
                    name = "up",
                    cond = "+"
                }
            }) do
            table.insert(lifecycle_binds, {
                keys = modKey .. " + ALT + " .. base .. "_" .. key.name,
                dsp = function() hl.dispatch(hl.dsp.window.move({ workspace = "r" .. key.cond .. "1" })) end,
                desc = "Send to workspace left/right"
            })
            table.insert(switch_binds, { keys = modKey .. " + CTRL + ALT + " .. base .. "_" .. key.name,
                dsp = function() hl.dispatch(hl.dsp.focus({ workspace = "m" .. key.cond .. "1" })) end,
                desc = "Focus busy left/right"
            })
            table.insert(switch_binds, {
                keys = modKey .. " + CTRL + " .. base .. "_" .. key.name,
                dsp = function() hl.dispatch(hl.dsp.focus({ workspace = "r" .. key.cond .. "1" })) end,
                desc = "Focus left/right"
            })
            table.insert(switch_binds, {
                keys = modKey .. " + CTRL + ALT + SHIFT + " .. base .. "_" .. key.name,
                dsp = function() hl.dispatch(hl.dsp.focus({ workspace = "r" .. key.cond .. "5" })) end,
                desc = "Focus left/right quick jump"
            })
        end
    end
end)()

-- =============================================================================
-- Dynamic Automated Processing Engine (Normalized & Fully Fixed)
-- =============================================================================
for _, cat_group in ipairs(keybinds_config) do
    local category = cat_group.category
    for _, sub_group in ipairs(cat_group.subcategories) do
        local subcategory = sub_group.name
        for _, b in ipairs(sub_group.binds) do
            local options = b.opts or {}
            local handler = b.dsp
            
            if b.desc then
                -- options.description = string.format("{\"%s\": {\"%s\": {\"%s\"}}}", category, subcategory, b.desc)
                options.description = string.format([[{"%s": {"%s": {"%s": []}}}]], category, subcategory, b.desc)
            end
            
            if type(handler) == "function" then
                hl.bind(b.keys, handler, options)
            else
                hl.bind(b.keys, function() hl.dispatch(handler) end, options)
            end
        end
    end
end

-- -- Submap Isolation Environment Core Execution Setup
-- hl.define_submap("virtual-machine", function()
--     hl.bind(modKey .. " + ALT + F1", function()
--         local currentsubmap = hl.get_current_submap()
--         if currentsubmap == "virtual-machine" then
--             hl.dispatch(hl.dsp.exec_cmd("notify-send 'Exited Virtual Machine submap' 'Keybinds re-enabled' -a 'Hyprland'"))
--             hl.dispatch(hl.dsp.submap("reset"))
--         elseif currentsubmap == "" then
--             hl.dispatch(hl.dsp.exec_cmd("notify-send 'Entered Virtual Machine submap' 'Keybinds disabled. hit SUPER+ALT+F1 to escape' -a 'Hyprland'"))
--             hl.dispatch(hl.dsp.submap("virtual-machine"))
--         end
--     end, { submap_universal = true, description = "Virtual machines (Toggle submap): Toggle submap" })
-- end)