# dotfiles

This repository contains the configuration files for my Arch Linux desktop
setup.  I alternate between using i3wm and MATE (not at the same time).

# Install

There is a script `deploy-dotfiles` in `.local/bin` which makes installing
this configuration easy.  It will pull from remote if any arguments
are passed.  The `DOTFILES_REPO` environment variable in `.profile`
will need to be set accordingly prior to running it.

The script also creates a `~/.Xresources` if one doesn't exist -- this is so
machine-specific X resources can be placed in `~/.Xresources`, while
`.Xresources.d/` can configure all machines.  If you are bringing your own
`~/.Xresources`, make sure the `#include` headers from
`.local/lib/dotfiles/Xresources` are included.  Note that `xrdb` requires the
CPP preprocessor for this functionality, and some display managers annoyingly
set the `--no-cpp` flag -- so either use LightDM or don't use a display
manager.

Conversely, there is an `update-dotfiles` script which replaces the
files in `$DOTFILES_REPO` with those in `~`.

I use the `Caps Lock` key mapped to nothing.  The first command in this code
block does this and sets the keyboard layout to `us` with the `altgr-intl`
variant.  The second command makes it permanent.
```
setxkbmap -layout us -variant altgr-intl -option caps:none
sudo localectl --no-convert set-x11-keymap us "" altgr-intl caps:none
```

# Look and feel

- GTK2/3/4 theme: Adwaita:dark
  - GTK2: set in `.gtkrc-2.0`
  - GTK3: set in `.config/gtk-3.0/settings.ini`
  - GTK4: `GTK_THEME` environment variable in `.xprofile`
- Cursor: Vanilla-DMZ
  - Set in `.Xresources.d/cursor` and `.icons/default/index.theme`
- Sans-serif font: DejaVu Sans
  - Set in `.config/fontconfig/fonts.conf`
    - This font is referenced in `.gtkrc-2.0`, `.config/gtk-3.0/settings.ini`, 
    `.config/dunst/dunstrc`, and `.config/i3/config`
- Monospace font: Source Code Pro
  - Set in `.config/fontconfig/fonts.conf`
- GTK icon theme: MATE
  - Set in `.gtkrc-2.0`, `.config/gtk-3.0/settings.ini`, `.config/gtk-4.0/settings.ini`
- GTK animations: disabled
  - Set in `.gtkrc-2.0`, `.config/gtk-3.0/settings.ini`, `.config/gtk-4.0/settings.ini`
- Transparent applications: urxvt, code, spotify, rhythmbox, clementine, gvim
  - Set in `.config/picom.conf`

# Software

## Packages used by this configuration

These packages are considered the basic requirements for this setup
to function smoothly, assuming you have a basic installation with
PulseAudio/Pipewire, NetworkManager, and Bluetooth (optional, just
ignore blueman).  [Consider switching `/bin/sh` to `dash` or something
faster than `bash`.](https://aur.archlinux.org/packages/dashbinsh)

For i3, from the official Arch Linux repository:
```
adobe-source-code-pro-fonts arandr atril autorandr blueman caja
caja-image-converter caja-open-terminal caja-sendto caja-xattr-tags curl dmenu
dunst engrampa eom evolution evolution-ews evolution-on feh firefox flameshot
gnome-clocks gnome-keyring gucharmap i3-wm i3lock i3status jq keepassxc light
mate-icon-theme mate-polkit mate-terminal mpv mpv-mpris network-manager-applet
pavucontrol picom playerctl python-gobject python-i3ipc python-mpris2
qalculate-gtk redshift rofi rsync surfraw ttf-dejavu unclutter wmctrl xcape
xclip xcursor-vanilla-dmz xdg-desktop-portal-gtk xdotool xorg-setxkbmap
xorg-xmodmap xorg-xrandr xorg-xset xss-lock zenity
```
For MATE, from the official Arch Linux repository:
```
adobe-source-code-pro-fonts atril blueman caja caja-image-converter
caja-open-terminal caja-sendto caja-wallpaper caja-xattr-tags dmenu dunst
engrampa eom evolution evolution-ews evolution-on firefox flameshot
gnome-keyring gucharmap keepassxc marco mate-applets mate-backgrounds
mate-control-center mate-desktop mate-icon-theme mate-media mate-menus
mate-panel mate-polkit mate-power-manager mate-screensaver mate-session-manager
mate-settings-daemon mate-terminal mate-themes mate-user-guide mate-utils mozo
mpv mpv-mpris network-manager-applet pavucontrol playerctl pluma qalculate-gtk
redshift rofi rsync surfraw ttf-dejavu unclutter wmctrl xbindkeys xcape xclip
xcursor-vanilla-dmz xdotool xorg-setxkbmap xorg-xmodmap xorg-xset zenity
```
From the AUR:
```
onedrive-abraunegg spotify
```

## Daemons/utilities

Some provide a systemd unit so I don't start them in my configs. Anything
that doesn't implement what a typical DE would do is started in
`.xprofile`; the others are started by `.local/bin/wm_start`,
which is called by i3.  A `~/.xprofile.d/` directory can be
used for system-specific things.  I don't currently use
`~/.xinitrc` as I use LightDM.

All of these are included in the packages section.

|Name|Purpose|systemd unit|xprofile|`wm_start`|Notes|
|----|-------|------------|--------|--|-----|
|[`dunst`](https://dunst-project.org/)|Displays notifications|=|||Launches by systemd when needed, but onedrive tries to start it before X is ready, so an override file exists to restart 5 seconds after failure.|
|[`feh`](https://feh.finalrewind.org/)|Desktop background|||=|Creates a `~/.fehbg` script upon setting background which can be run to re-apply it.|
|[`gnome-keyring-daemon`](https://wiki.gnome.org/Projects/GnomeKeyring)|Stores passwords (secret service agent)|=|||No attention needed; it should be handled by systemd and dbus.|
|[`mate-polkit`](https://github.com/mate-desktop/mate-polkit)|Privilege escalation for graphical applications|||=||
|[`onedrive`](https://github.com/abraunegg/onedrive)|Cloud file sync|=|||This repository contains a config for a personal and a school OneDrive account.  It will need to be authenticated and then enabled.|
|[`picom`](https://github.com/yshui/picom)|Compositor for i3|||=||
|[`playerctld`](https://github.com/altdesktop/playerctl)|Detects media players||=|||
|[`redshift`](http://jonls.dk/redshift/)|Blue light filter|=|||Needs to be enabled.|
|[`unclutter`](https://github.com/Airblader/unclutter-xfixes)|Hides cursor after 5 seconds||=||Timeout is hard coded.  The cursor appears when scrolling unless "jitter" is enabled, which then makes it annoyingly insensitive.|
|[`autorandr`](https://github.com/phillipberndt/autorandr)|Load/save display profiles automatically|||=||

## Preferred applications

Most of these are just here to remind me what I like to use but many
are referenced in my i3 config.

C = some configuration present, P = listed in [packages](#packages-used-by-this-configuration)
|Type|Application|C|P|Notes|
|----|-----------|-|-|-----|
|Terminal emulator|[MATE Terminal](https://github.com/mate-desktop/mate-terminal)|=|=||
|Editor|[Vim](https://www.vim.org/)|[=](https://github.com/thomashuss/vimrc)|=|Install `gvim` for X clipboard support.|
|File manager|[Caja](https://github.com/mate-desktop/caja)|=|=|The `caja-image-converter` and `caja-open-terminal` plugins are useful.|
|Web browser|[Firefox](https://www.mozilla.org/firefox)|=|=|This repo contains a configuration file for [Tridactyl](https://tridactyl.xyz/).|
|Mail client|[Evolution](https://wiki.gnome.org/Apps/Evolution)|=|=|Install the [`evolution-ews`](https://wiki.gnome.org/Apps/Evolution/EWS) plugin for Microsoft Exchange (e.g., school, work) support. The [`evolution-on`](https://github.com/acidrain42/evolution-on) plugin provides a tray icon indicating when a message has been received.|
|Calculator|[Qalculate](https://qalculate.github.io/)||=||
|Screenshot utility|[Flameshot](https://github.com/flameshot-org/flameshot)||=||
|Password manager|[KeePassXC](https://keepassxc.org/)||=||
|Music player|[Rhythmbox](https://wiki.gnome.org/Apps/Rhythmbox), [Spotify](https://www.spotify.com/download/linux/)||||
|PDF reader|[Atril](https://github.com/mate-desktop/atril)||=|Pass the `-w` flag to open in preview mode which has the beneficial byproduct of being excluded by i3's workspace rule (useful for e.g. LaTeX editors).|
|Archive manager|[Engrampa](https://github.com/mate-desktop/engrampa)||=||
|Image viewer|[Eye of MATE](https://github.com/mate-desktop/eom)||=||
|Media player|[MPV](https://mpv.io/)||=|The `mpv-mpris` plugin provides support for media keys.|
|Office suite|[LibreOffice](https://www.libreoffice.org/)|||Install the proper hunspell package (e.g., `hunspell-en_us`) for spellcheck support.|
|Math frontend|[Cantor](https://apps.kde.org/cantor/)|||Does not play well with dark Qt themes. Don't forget to install a math backend.|
|E-book reader|[Bookworm](https://babluboy.github.io/bookworm)||||
|Image editor|[GIMP](https://www.gimp.org/)||||
|PDF annotator|[Xournal++](https://github.com/xournalpp/xournalpp)||||
|Bluetooth manager|[Blueman](https://github.com/blueman-project/blueman)||||
|Graphical text editor|[Pluma](https://github.com/mate-desktop/pluma)||||
|QR code reader/generator|[QtQR](https://launchpad.net/qr-tools)||||

# i3 configuration

## Keybinds

### Pseudo-vim mode

Conceived out of frustration while proofreading a document in LibreOffice,
this is an ad-hoc solution for a basic vim-like navigation scheme in many
graphical applications.

The pseudo-vim mode (PVM) consists of two i3 modes, "normal" and "visual",
named after vim's modes.  When PVM is activated with its keybind, the i3
"normal" mode is activated and `xmodmap` remaps hjkl to their
respective arrow keys.  Using i3 keybindings and `xdotool`, the
following keybindings are simulated as in vim's normal mode:
`^B ^F ^R $ ^ b o O p / u v w`

The `v` keybinding in "normal" mode switches i3 to "visual" mode wherein
the following keybindings are simulated as in vim's visual mode:
`h j k l b d w y Esc`

While in i3 "normal" mode, `Escape` will dissolve this cheap illusion.
