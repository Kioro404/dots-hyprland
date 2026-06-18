# ~/.bash_profile

if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec uwsm start hyprland-uwsm.desktop > /dev/null 2>&1
fi
