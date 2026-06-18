#!/usr/bin/env bash

# random.sh - Shared library for random wallpaper scripts

get_pictures_dir() {
    if command -v xdg-user-dir &> /dev/null; then
        xdg-user-dir PICTURES
        return
    fi

    local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"
    if [ -f "$config_file" ]; then
        local pictures_path
        pictures_path=$(source "$config_file" >/dev/null 2>&1; echo "$XDG_PICTURES_DIR")
        echo "${pictures_path/#\$HOME/$HOME}"
        return
    fi

    echo "$HOME/Pictures"
}

setup_paths() {
    QUICKSHELL_CONFIG_NAME="ii"
    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
    XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
    PICTURES_DIR=$(get_pictures_dir)
    CONFIG_DIR="$XDG_CONFIG_HOME/quickshell/$QUICKSHELL_CONFIG_NAME"
    CACHE_DIR="$XDG_CACHE_HOME/quickshell"
    STATE_DIR="$XDG_STATE_HOME/quickshell"
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
}

download_unique_wallpaper() {
    local url="$1"
    local wallpaper_dir="$PICTURES_DIR/Wallpapers"
    mkdir -p "$wallpaper_dir"
    local ext
    ext=$(echo "$url" | awk -F. '{print $NF}')
    local downloadPath="$wallpaper_dir/random_wallpaper.$ext"
    local illogicalImpulseConfigPath="$HOME/.config/illogical-impulse/config.json"
    local currentWallpaperPath
    currentWallpaperPath=$(jq -r '.background.wallpaperPath' "$illogicalImpulseConfigPath" 2>/dev/null || echo "")
    if [ "$downloadPath" == "$currentWallpaperPath" ]; then
        downloadPath="$wallpaper_dir/random_wallpaper-1.$ext"
    fi
    curl "$url" -o "$downloadPath"
    echo "$downloadPath"
}

switch_wallpaper() {
    local image_path="$1"
    SWITCHWALL_PATH="$SCRIPT_DIR/../switchwall.sh"
    "$SWITCHWALL_PATH" --image "$image_path"
}
