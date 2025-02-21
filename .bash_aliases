#!/usr/bin/env bash
alias ccopy="xclip -i -sel c"
alias cpaste="xclip -o -sel c"
alias i3-config='"$EDITOR" "$HOME"/.config/i3/config'
alias dconf-config="vim -o $HOME/.local/lib/dotfiles/dconf <(dconf dump /)"
alias doc="cd ~/Documents"
alias ondr="cd ~/onedrive"
alias sond="cd ~/school_onedrive"
alias dl="cd ~/Downloads"
alias e="$EDITOR"
alias mpv-yta='mpv --ytdl-format=140 --force-window'
alias tm='tmux attach || tmux new-session \; split-window -h \; last-pane'
