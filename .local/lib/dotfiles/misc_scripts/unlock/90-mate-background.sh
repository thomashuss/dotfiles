#!/bin/sh
if pgrep mate-settings > /dev/null 2>&1 && [ "$(gsettings get org.mate.background draw-background)" = true ]; then
	gsettings set org.mate.background draw-background false
	gsettings set org.mate.background draw-background true
fi
