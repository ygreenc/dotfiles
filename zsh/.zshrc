# Replace oh-my-zsh by Antigen
# Change default Antigen configuration directory
source "${HOME}/.config/zsh/zgen/zgen.zsh"

# Configure default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# Create an init script if non-existent
if ! zgen saved; then
    echo "Creating a zgen save"

    # Use oh-my-zsh as base
    zgen oh-my-zsh

    # Load my modules
    # If .zshrc.local exists, source it
    [[ -f ~/.zshrc.bundles ]] && source ~/.zshrc.bundles

    
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/gnu-utils
    zgen oh-my-zsh plugins/symfony2
    zgen oh-my-zsh plugins/vundle
    zgen oh-my-zsh plugins/composer

    zgen load zsh-users/zsh-completions
    zgen load zsh-users/zsh-syntax-highlighting

    # Apply theme
    zgen oh-my-zsh themes/crcandy

    # Save script
    zgen save
fi




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
bindkey "\eOA" up-line-or-history
bindkey '\e[B' down-line-or-history
bindkey '\eOB' down-line-or-history

# If .zshrc.local exists, source it
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Send to paste service
sprunge() { curl -F "sprunge=<-" http://sprunge.us <"$1" ;}

# Send to other paste service
ix() {
    local opts
    local OPTIND
    [ -f "$HOME/.netrc" ] && opts='-n'
    while getopts ":hd:i:n:" x; do
        case $x in
            h) echo "ix [-d ID] [-i ID] [-n N] [opts]"; return;;
            d) $echo curl $opts -X DELETE ix.io/$OPTARG; return;;
            i) opts="$opts -X PUT"; local id="$OPTARG";;
            n) opts="$opts -F read:1=$OPTARG";;
        esac
    done
    shift $(($OPTIND - 1))
    [ -t 0 ] && {
        local filename="$1"
        shift
        [ "$filename" ] && {
        curl $opts -F f:1=@"$filename" $* ix.io/$id
        return
        }
        echo "^C to cancel, ^D to send."
    }
    curl $opts -F f:1='<-' $* ix.io/$id
}
