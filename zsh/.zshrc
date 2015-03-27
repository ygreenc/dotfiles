# Replace oh-my-zsh by Antigen
# Change default Antigen configuration directory
export ADOTDIR=${HOME}/.config/zsh/antigen/

# Load Antigen
source ${ADOTDIR}/antigen.zsh

# Use oh-my-zsh as base
antigen-use oh-my-zsh

# Load my modules
antigen-bundles <<EOBUNDLES
git
gnu-utils
symfony2
vundle
composer
git-flow
pip
lein
python
go
zsh-users/zsh-completions
zsh-users/zsh-syntax-highlighting
EOBUNDLES

antigen-theme mortalscumbag
antigen-apply

# Keep large history
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000

# Append to history file instead of truncating
setopt APPEND_HISTORY
# Automatically cd to directory
setopt AUTO_CD

# Treat #~^ as pattern
setopt EXTENDED_GLOB

# Display an error if pattern has no matches
setopt NOMATCH

# Share history between sessions
setopt SHARE_HISTORY

# Prefix timestamp to command in history file
setopt EXTENDED_HISTORY

# Do not append command to history if the same as previous one
setopt HIST_IGNORE_DUPS

# When searching history, don't display duplicates
setopt HIST_FIND_NO_DUPS

# Allow comments even in shell
setopt INTERACTIVECOMMENTS

# Try to correct spelling of arguments
setopt CORRECTALL

# Disable terminal bell
unsetopt BEEP NOTIFY

# vi-style bindings
bindkey -v

# Fix up/down arrow history (put cursor at end of line)
bindkey '\e[A' up-line-or-history
bindkey '\e[B' down-line-or-history

# If .zshrc.local exists, source it
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
