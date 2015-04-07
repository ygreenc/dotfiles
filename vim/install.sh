#!/usr/bin/env bash
# Don't execute this. Read-it
# NOT SAFE in any way. Use at your own risk

# Bash "strict" mode
set -euo pipefail
IFS=$'\n\t'

# Application root
readonly APP_ROOT=$(pwd)

# vim-plug File URI
readonly PLUG_URI=${PLUG_URI:-"https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"}
readonly PLUG_DIR=${PLUG_DIR:-"$HOME/.vim/bundle/plug/autoload"}

# Backup files
today=$(date +%Y%m%d_%s)
[ -e "$HOME/.vim" ] && mv "$HOME/.vim" "$HOME/.vim.$today"
[ -e "$HOME/.vimrc" ] && mv "$HOME/.vimrc" "$HOME/.vimrc.$today"

# Create necessary symbolic links
ln -sf "$APP_ROOT" "$HOME/.vim"
ln -sf "$HOME/.vim/vimrc" "$HOME/.vimrc"

# If vim-plug dir is not found, get it
[ ! -d $PLUG_DIR ] && curl -fLo "$PLUG_DIR/plug.vim" --create-dirs "$PLUG_URI"

# Download plugins
vim +PlugInstall

# Create local config
touch "$HOME/.vimrc.local"
