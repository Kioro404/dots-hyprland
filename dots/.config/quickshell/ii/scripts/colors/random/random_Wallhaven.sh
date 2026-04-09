#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/random.sh"
setup_paths

if [ "$1" == "getTag" ]; then
    echo '["General","Anime","People"]'
    exit 0
fi

if [ "$1" == "setTag" ]; then
    KEY="" # Define your Wallhaven API key for NSFW content

    c1=0; c2=0; c3=0
    [[ "$2" == *"General"* ]] && c1=1
    [[ "$2" == *"Anime"* ]]   && c2=1
    [[ "$2" == *"People"* ]]  && c3=1

    CAT="${c1}${c2}${c3}"
    if [ "$CAT" == "000" ]; then CAT="111"; fi

    PUR=""
    for i in {1..3}; do
        PUR+=$((RANDOM % 2))
    done

    response=$(curl "https://wallhaven.cc/api/v1/search?apikey=$KEY&categories=$CAT&purity=$PUR&ratios=16x9%2C16x10&sorting=random&order=desc")
    link=$(echo "$response" | jq '.data[0].path' -r);
    downloadPath=$(download_unique_wallpaper "$link")
    switch_wallpaper "$downloadPath"
fi
