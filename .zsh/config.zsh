bindkey -e
export KEYTIMEOUT=2

autoload -U compinit promptinit zcalc zsh-mime-setup zmv
# compinit
# promptinit
zsh-mime-setup

# # append command to history file once executed
setopt INC_APPEND_HISTORY

# Now we can pipe to multiple outputs!
setopt MULTIOS

# Spell check commands!  (Sometimes annoying)
setopt CORRECT

# This makes cd=pushd
setopt AUTO_PUSHD

# This will use named dirs when possible
setopt AUTO_NAME_DIRS

# If we have a glob this will expand it
setopt GLOB_COMPLETE
setopt PUSHD_MINUS

# No more annoying pushd messages...
# setopt PUSHD_SILENT

# blank pushd goes to home
setopt PUSHD_TO_HOME

# this will ignore multiple directories for the stack.  Useful?  I dunno.
setopt PUSHD_IGNORE_DUPS

# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
setopt RM_STAR_WAIT

# use magic (this is default, but it can't hurt!)
setopt ZLE

setopt NO_HUP

setopt PROMPT_SUBST

# setopt VI

unsetopt nomatch

# only fools wouldn't do this ;-)

setopt IGNORE_EOF

# If I could disable Ctrl-s completely I would!
setopt NO_FLOW_CONTROL


#Disable core dumps
limit coredumpsize 0

bindkey "\e[3~" delete-char

# A word
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

# why would you type 'cd dir' if you could just type 'dir'?
setopt AUTO_CD

setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE

# bindkey -M menuselect '\C-?' undo

# eval "$(dircolors)"
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist

#Completion Options
# zstyle ':completion:*:match:*' original only
# zstyle ':completion::prefix-1:*' completer _complete
# zstyle ':completion:predict:*' completer _complete
# zstyle ':completion:incremental:*' completer _complete _correct
# zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate _fasd_zsh_word_complete_trigger

# smartcase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Path Expansion
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

# zstyle ':completion:*:*:*:default' menu yes select
zstyle ':completion:*:*:*:default' menu select search
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:processes' command "ps -au $USER"

# Group matches and Describe
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
# zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:descriptions' format $'[%d]'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

function set_win_title(){
  echo -ne "\033]0; zsh: $(basename "$PWD") \007"
}

precmd_functions+=(set_win_title)
