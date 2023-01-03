# dotfiles

This repository contains the configuration files for my Linux desktop.
I use i3wm/Arch but there exists some configuration for MATE as well.

# Install

There is a script `deploy-dotfiles` in `.local/bin` which makes installing
this configuration easy.  It will pull from remote if any arguments
are passed.  The `DOTFILES_REPO` environment variable in `.profile`
will need to be set accordingly prior to running it.

The script also creates a `~/.Xresources` if one doesn't exist --
this is so machine-specific X resources can be placed in
`~/.Xresources`, while `.Xresources.d/` can configure all machines.
If you are bringing your own `~/.Xresources`, make sure the
`#include` headers from `deploy-dotfiles` are included.  Note that
`xrdb` requires the CPP preprocessor for this functionality, and
some display managers annoyingly set the `--no-cpp` flag -- so
either use LightDM or don't use a display manager.

Conversely, there is an `update-dotfiles` script which replaces the
files in `$DOTFILES_REPO` with those in `~`.

# Look and feel

- GTK2/3/4 theme: Adwaita:dark
  - GTK2: set in `.gtkrc-2.0`
  - GTK3: set in `.config/gtk-3.0/settings.ini`
  - GTK4: `GTK_THEME` environment variable in `.xprofile`
- Qt theme: Windows
  - Determined by `QT_STYLE_OVERRIDE` environment variable in `.xprofile`
  - Note: Many Qt applications were designed with light themes in mind
- Cursor: Vanilla-DMZ
  - Set in `.Xresources.d/cursor` and `.icons/default/index.theme`
- Sans-serif font: DejaVu Sans
  - Set in `.config/fontconfig/fonts.conf`
    - This font is referenced in `.gtkrc-2.0`, `.config/gtk-3.0/settings.ini`, 
    `.config/dunst/dunstrc`, and `.config/i3/config`
- Monospace font: Source Code Pro
  - Set in `.config/fontconfig/fonts.conf`
  - Set in `.Xresources.d/urxvt`
- GTK icon theme: MATE
  - Set in `.gtkrc-2.0` and `.config/gtk-3.0/settings.ini`
- GTK animations: disabled
  - Set in `.gtkrc-2.0` and `.config/gtk-3.0/settings.ini`
- Transparent applications: urxvt, code, spotify, rhythmbox, clementine, gvim
  - Set in `.config/picom.conf`

# Software

## Packages used by this configuration

These packages are considered the basic requirements for this setup
to function smoothly **in my case**.

In the official Arch Linux repository:
```
rxvt-unicode xorg-xset picom unclutter mate-polkit feh
playerctl numlockx gnome-keyring dunst redshift seahorse
keepassxc caja evolution evolution-ews evolution-on firefox
mate-calc mate-utils mate-user-guide xss-lock xorg-xrandr
mate-icon-theme xclip light xorg-xmodmap xorg-setxkbmap
ttf-dejavu adobe-source-code-pro-fonts xcursor-vanilla-dmz
autorandr arandr pavucontrol atril engrampa eom gvim
rhythmbox mpv mpv-mpris xdotool zenity rsync
```
In the AUR:
```
onedrive-abraunegg spotify
```

## Daemons/utilities

Some provide a systemd unit so I don't start them in my configs. Anything
that doesn't implement what a typical DE would do is started in
`.xprofile`; the others are started in the i3 config. A `~/.xprofile.d/`
directory can be used for system-specific things.  I don't currently use
`~/.xinitrc` as I use LightDM.

All of these are included in the packages section.

|Name|Purpose|systemd unit|xprofile|i3|Notes|
|----|-------|------------|--------|--|-----|
|[`dunst`](https://dunst-project.org/)|Displays notifications|=|||Launches by systemd when needed, but onedrive tries to start it before X is ready, so an override file exists to restart 5 seconds after failure.|
|[`feh`](https://feh.finalrewind.org/)|Desktop background|||=|Creates a `~/.fehbg` script upon setting background which can be run to re-apply it.|
|[`gnome-keyring-daemon`](https://wiki.gnome.org/Projects/GnomeKeyring)|Stores passwords (secret service agent)|=|||No attention needed; it should be handled by systemd and dbus.|
|[`mate-polkit`](https://github.com/mate-desktop/mate-polkit)|Privilege escalation for graphical applications|||=||
|[`numlockx`](https://github.com/rg3/numlockx)|Enables numlock|||=||
|[`onedrive`](https://github.com/abraunegg/onedrive)|Cloud file sync|=|||This repository contains a config for a personal and a school OneDrive account.  It will need to be authenticated and then enabled.|
|[`picom`](https://github.com/yshui/picom)|Compositor for i3|||=||
|[`playerctld`](https://github.com/altdesktop/playerctl)|Detects media players|||=||
|[`redshift`](http://jonls.dk/redshift/)|Blue light filter|=|||Needs to be enabled.|
|[`unclutter`](https://github.com/Airblader/unclutter-xfixes)|Hides cursor after 5 seconds||=||Timeout is hard coded.  The cursor appears when scrolling unless "jitter" is enabled, which then makes it annoyingly insensitive.|
|[`autorandr`](https://github.com/phillipberndt/autorandr)|Load/save display profiles automatically|||=||

## Preferred applications

Some of these are defined as constants in the i3 configuration.  When
they are referenced in the [i3 section](#i3-configuration), the
underlying configuration refers to the relevant constant.  Most of
these are just here to remind me what I like to use.

C = some configuration present, P = listed in [packages](#packages-used-by-this-configuration)
|Type|Application|C|P|Notes|
|----|-----------|-|-|-----|
|Terminal emulator|[URxvt](http://software.schmorp.de/pkg/rxvt-unicode.html)|=|=||
|Editor|[Vim](https://www.vim.org/)|=|=|Install `gvim` for X clipboard support.|
|File manager|[Caja](https://github.com/mate-desktop/caja)|=|=|The `caja-image-converter` and `caja-open-terminal` plugins are useful.|
|Web browser|[Firefox](https://www.mozilla.org/firefox)|=|=|This repo contains a configuration file for [Tridactyl](https://tridactyl.xyz/).|
|Mail client|[Evolution](https://wiki.gnome.org/Apps/Evolution)|=|=|Install the [`evolution-ews`](https://wiki.gnome.org/Apps/Evolution/EWS) plugin for Microsoft Exchange (e.g., school, work) support. The [`evolution-on`](https://github.com/acidrain42/evolution-on) plugin provides a tray icon indicating when a message has been received.|
|Calculator|[MATE Calculator](https://github.com/mate-desktop/mate-calc)||=||
|Screenshot utility|[MATE Screenshot](https://github.com/mate-desktop/mate-utils)||=||
|Password manager|[KeePassXC](https://keepassxc.org/)||=||
|Music player|[Rhythmbox](https://wiki.gnome.org/Apps/Rhythmbox), [Spotify](https://www.spotify.com/download/linux/)||=||
|PDF reader|[Atril](https://github.com/mate-desktop/atril)||=||
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

## Workspaces

I've assigned workspaces based on the purposes that come up consistently no
matter what I am using my computer for.

|n|Purpose|
|-|-------|
|1|Priority task -- usually the "main window(s)" of my primary focus at any point in time|
|2|Web browsing -- due to "web app" culture, this does not mean web browsers in general|
|3|Email, IM, video calls|
|4-9|Free|
|10|Multimedia|

## Keybindings

Let W<sub>`n`</sub> denote workspace number n, `1 ≤ n ≤ 10`, and W<sub>0</sub> denote the focused
workspace.  Let C<sub>0</sub> denote the focused container.  F(`x`) focuses `x` and L(`a`)
launches `a`.  L\*(`x`) launches `x` if it isn't already running, or focuses `x`
otherwise.

Where `c` is the number of keys in a chord, the following tables group chords
by their first `c - 1` keys.

### `$mod+...`

Because chords of more than 2 keys are uncomfortable, these actions should be the most common.

|Last key|Action|
|--------|------|
|`q`|Kill C<sub>0</sub>|
|`h`,`j`,`k`,`l`|F(container to left/down/up/right of C<sub>0</sub>)|
|n, `1 ≤ n ≤ 9`|F(W<sub>n</sub>)|
|`0`|F(W<sub>`10`</sub>)|
|`'`|F(above output)|
|`;`|F(below output)|
|`[`|F(left output)|
|`]`|F(right output)|
|`/`|F(child of C<sub>0</sub>)|
|`=`|F(parent of C<sub>0</sub>)|
|`Space`|F(floating container) toggle|
|`Return`|L(terminal)|
|`a`|L(`pavucontrol`) -- PulseAudio volume control|
|`b`|Close all floating file manager windows if any are open OR L(file manager) [ideal for spatial file managers]|
|`c`|L(calculator)|
|`d`|L(`dmenu_run`) -- application launcher|
|`e`|F(W<sub>`3`</sub>) and L(mail client)|
|`o`|L(`arandr`) -- graphical frontend for multihead configuration, L(`~/.fehbg`) -- re-apply wallpaper, prompt to save display profile with `autorandr`|
|`p`|L(password manager)|
|`u`|F(W<sub>`10`</sub>) and L\*(music player)|
|`w`|L(web browser)|
|`y`|F(W<sub>`10`</sub>) and L\*(`spotify`)|
|`m`|Prompt for C<sub>0</sub> mark|
|`n`|Prompt for new C<sub>0</sub> title|
|`\`|Horizontal layout|
|`-`|Vertical layout|
|`i`|Split layout|
|`t`|Tabbed layout|
|`s`|Stacking layout|
|`r`|Resize mode (use hjkl to alter container's size, `Escape` to exit)|
|`f`|Toggle C<sub>0</sub> fullscreen|
|`Left`|Previous track|
|`Right`|Next track|
|`Down`|Play/pause media playback|
|`Up`|Stop media playback|
|`Escape`|Lock screen|
|`Left mouse button`|Move floating container|
|`Right mouse button`|Resize container|
|`Backspace`|Show/hide scratchpad|

### `$mod+Shift+...`

|Last key|Action|
|--------|------|
|`h`,`j`,`k`,`l`|Move C<sub>0</sub> within W<sub>0</sub>|
|n, `1 ≤ n ≤ 9`|Move C<sub>0</sub> to W<sub>`n`</sub>|
|`0`|Move C<sub>0</sub> to W<sub>`10`</sub>|
|`Backspace`|Move C<sub>0</sub> to scratchpad|
|`[`|Move W<sub>0</sub> to left output|
|`]`|Move W<sub>0</sub> to right output|
|`'`|Move W<sub>0</sub> to above output|
|`;`|Move W<sub>0</sub> to below output|
|`w`|L(web browser) private window|
|`Return`|L(floating terminal)|
|`d`|L(`i3-dmenu-desktop`) -- application launcher for `.desktop` files|
|`n`|Reset C<sub>0</sub> title|
|`Space`|Float/unfloat C<sub>0</sub>|
|`o`|Prompt for and load `autorandr` display configuration|
|`Down`|Show popup with currently playing media title and artist|

### `$mod+Control+...`

Actions that change the window manager's behavior.

|Last key|Action|
|--------|------|
|n, `1 ≤ n ≤ 9`|Prompt for postfix and rename W<sub>0</sub> to W<sub>`n`</sub> with postfix|
|`0`|Prompt for postfix and rename W<sub>0</sub> to W<sub>`10`</sub> with postfix|
|`c`|Reload i3 configuration|
|`d`|Open i3 documentation in web browser|
|`e`|Prompt to exit i3|
|`o`|Prompt for i3 command|
|`r`|Restart i3|
|`v`|[Pseudo-vim mode](#pseudo-vim-mode)|
|`g`|Passthrough mode (unbinds all keys, `$mod+g` to revert)|

### Single keys

These actions are performed very frequently, or their nature encourages
the use of a single key.

|Key|Action|
|---|------|
|`PrintScr`|L(screenshot utility)|
|`Screensaver`|Lock screen|
|`Volume up`|Volume up|
|`Volume down`|Volume down|
|`Volume mute`|Volume mute|
|`Microphone mute`|Microphone mute|
|`Previous track`|Previous track|
|`Play/pause media playback`|Play/pause media playback (combine with `Shift` for same behavior as `$mod+Shift+Down`)|
|`Stop media playback`|Stop media playback|
|`Next track`|Next track|
|`Brightness up`|Brightness up (uses `light`)|
|`Brightness down `|Brightness down (uses `light`)|
|`F4`|F(previous workspace)|
|`F10`|Prompt for mark and F(marked container)|

### Pseudo-vim mode

Conceived out of frustration while proofreading a document in LibreOffice,
this is an ad-hoc solution for a basic vim-like navigation scheme in many
graphical applications.

The pseudo-vim mode (PVM) consists of two i3 modes, "normal" and "visual",
named after vim's modes.  When PVM is activated with `$mod+Control+v`, the i3
"normal" mode is activated and `xmodmap` remaps hjkl to their
respective arrow keys.  Using i3 keybindings and `xdotool`, the
following keybindings are simulated as in vim's normal mode:
`^B ^F ^R $ ^ b o O p / u v w`

The `v` keybinding in "normal" mode switches i3 to "visual" mode wherein
the following keybindings are simulated as in vim's visual mode:
`h j k l b d w y Esc`

While in i3 "normal" mode, `$mod+Control+v` or `Escape` will dissolve this cheap
illusion.
