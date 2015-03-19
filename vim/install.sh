#!/usr/bin/env bash
# Don't execute this. Read-it
# NOT SAFE in any way. Use at your own risk

# Bash "strict" mode
set -euo pipefail
IFS=$'\n\t'

# Application root
readonly APP_ROOT=$(pwd)

# Vundle Repository URI
readonly VUNDLE_URI=${VUNDLE_URI:-"https://github.com/gmarik/vundle.git"}
readonly VUNDLE_DIR="$HOME/.vim/bundle/vundle"

# Backup files
today=$(date +%Y%m%d_%s)
[ -e "$HOME/.vim" ] && mv "$HOME/.vim" "$HOME/.vim.$today"
[ -e "$HOME/.vimrc" ] && mv "$HOME/.vimrc" "$HOME/.vimrc.$today"

# Create necessary symbolic links
ln -sf "$APP_ROOT" "$HOME/.vim"
ln -sf "$HOME/.vim/vimrc" "$HOME/.vimrc"

# If vundle dir is not found, clone it
[ ! -d $VUNDLE_DIR ] && git clone "$VUNDLE_URI" "$HOME/.vim/bundle/vundle"

# Download plugins
vim +PluginInstall
