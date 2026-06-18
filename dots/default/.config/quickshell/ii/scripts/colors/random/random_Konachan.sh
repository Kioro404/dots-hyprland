#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/random.sh"
setup_paths

if [ "$1" == "getTag" ]; then
    echo '[]'
    exit 0
fi

response=$(curl "https://konachan.net/post.json?tags=rating%3Asafe&limit=1&page=$((1 + RANDOM % 1000))")
link=$(echo "$response" | jq '.[0].file_url' -r);
downloadPath=$(download_unique_wallpaper "$link")
switch_wallpaper "$downloadPath"
