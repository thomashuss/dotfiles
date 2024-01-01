# this bashism is ok :)
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
export EDITOR="/usr/bin/vim"
export DOTFILES_REPO="$HOME/projects/dotfiles"
