# dotfiles

I use a heavily customized i3 alongside a barebones MATE on Debian.

## Install

Run `deploy-dotfiles` in `.local/bin`.

I use the `Caps Lock` key mapped to nothing.  The first command in this code
block does this and sets the keyboard layout to `us` with the `altgr-intl`
variant.  The second command makes it permanent.
```
setxkbmap -layout us -variant altgr-intl -option caps:none
sudo localectl --no-convert set-x11-keymap us "" altgr-intl caps:none
```

## Software

Base MATE installation, tools needed for scripts, and other nice programs.
Make sure `marco`, MATE's default window manager, is not installed so it
doesn't conflict with i3.

### Debian

```
adwaita-qt alarm-clock-applet atril blueman caja caja-image-converter
caja-open-terminal caja-sendto caja-xattr-tags dconf-cli dex dmz-cursor-theme
dunst engrampa eom firefox-esr firewall-config flameshot fonts-dejavu
fonts-liberation fonts-noto gnome-keyring gucharmap i3-wm jq keepassxc
libnotify-bin lightdm mate-applets mate-control-center mate-icon-theme
mate-media mate-power-manager mate-screensaver mate-session-manager
mate-settings-daemon mate-terminal mozo mpv mpv-mpris network-manager-gnome
pavucontrol picom pipewire-audio pipewire-jack playerctl python3-dbus
python3-gi python3-i3ipc python3-xlib qalculate-gtk redshift-gtk rofi rsync
suckless-tools unclutter-xfixes vim-gtk3 wmctrl xcape xclip xdotool
```

## Fixes

### Disable Debian's unclutter

Set `START_UNCLUTTER` to `false` in `/etc/default/unclutter`

## License

Files in the `.local` directory except for `dconf` are licensed under the GNU
GPL v3 license.  See [LICENSE.md](LICENSE.md).
