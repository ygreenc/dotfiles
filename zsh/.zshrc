# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Ensure zgen exists
ZGENDIR=${ZGENDIR:-${HOME}/.config/zsh/zgen}
if [[ ! -f "$ZGENDIR/zgen.zsh" ]]; then
    git clone https://github.com/tarjoilija/zgen.git "$ZGENDIR"
fi

# Change default Antigen configuration directory
source "${HOME}/.config/zsh/zgen/zgen.zsh"

# Configure default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# Disable zsh auto update
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

# Create an init script if non-existent
if ! zgen saved; then
    echo "Creating a zgen save"

    # Use oh-my-zsh as base
    zgen oh-my-zsh

    # Load my modules
    # If .zshrc.local exists, source it
    [[ -f ~/.zshrc.bundles ]] && source ~/.zshrc.bundles

    # Dev
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/gnu-utils
    # PHP
    zgen oh-my-zsh plugins/composer
    # Python
    #zgen oh-my-zsh plugins/pip
    #zgen oh-my-zsh plugins/virtualenv
    # System
    zgen oh-my-zsh plugins/systemd
    zgen oh-my-zsh plugins/themes
    #zgen oh-my-zsh plugins/vi-mode
    zgen oh-my-zsh plugins/kubectl

    zgen load zsh-users/zsh-completions
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load digitalocean/doctl
    zgen load romkatv/powerlevel10k powerlevel10k

    # Apply theme
    #zgen oh-my-zsh themes/af-magic

    # Save script
    zgen save
fi

# Keep large history
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000

# Append to history file instead of truncating
setopt INC_APPEND_HISTORY_TIME

# Automatically cd to directory
setopt AUTO_CD

# Treat #~^ as pattern
setopt EXTENDED_GLOB

# Display an error if pattern has no matches
setopt NOMATCH

# Prefix timestamp to command in history file
setopt EXTENDED_HISTORY

# When trimming histfile, remove duplicate first
setopt HIST_EXPIRE_DUPS_FIRST

# When searching history, don't display duplicates
setopt HIST_FIND_NO_DUPS

# Allow comments even in shell
setopt INTERACTIVE_COMMENTS

# Try to correct spelling of commands
setopt CORRECT

# Automatically list choices on an ambiguous completion
setopt AUTO_LIST

# When word contains glob pattern, list through values
setopt GLOB_COMPLETE

# If a pattern for filename generation is badly formed, print an error message
setopt BAD_PATTERN

# Disable terminal bell
unsetopt BEEP NOTIFY

# Change timeout on ESC keypress
export KEYTIMEOUT=1

# vi-style bindings
bindkey -v

# Fix up/down arrow history (put cursor at end of line)
bindkey '\e[A' up-line-or-history
bindkey "\eOA" up-line-or-history
bindkey '\e[B' down-line-or-history
bindkey '\eOB' down-line-or-history

# v in Command mode will open the command in $EDITOR
bindkey -M vicmd v edit-command-line

# If .zshrc.local exists, source it
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Send to paste service
sprunge() { curl -F "sprunge=<-" http://sprunge.us <"$1" ;}

# Grab current tmux layout
tmux-current-layout () { tmux list-windows -F "#{window_active} #{window_layout}" | grep "^1" | cut -d " " -f 2 }

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

transfer() { 
    # check arguments
    if [ $# -eq 0 ]; 
    then 
        echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi

    # get temporarily filename, output is written to this file show progress can be showed
    tmpfile=$( mktemp -t transferXXX )
    
    # upload stdin or file
    file=$1

    if tty -s; 
    then 
        basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g') 

        if [ ! -e $file ];
        then
            echo "File $file doesn't exists."
            return 1
        fi
        
        if [ -d $file ];
        then
            # zip directory and transfer
            zipfile=$( mktemp -t transferXXX.zip )
            cd $(dirname $file) && zip -r -q - $(basename $file) >> $zipfile
            curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> $tmpfile
            rm -f $zipfile
        else
            # transfer file
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> $tmpfile
        fi
    else 
        # transfer pipe
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> $tmpfile
    fi
   
    # cat output link
    cat $tmpfile

    # cleanup
    rm -f $tmpfile
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
