# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  node          # Node.js section
  ruby          # Ruby section
  elixir        # Elixir section
  swift         # Swift section
  golang        # Go section
  php           # PHP section
  rust          # Rust section
  venv          # virtualenv section
  pyenv         # Pyenv section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_EXIT_CODE_SHOW='true'
export ZSH_THEME="spaceship"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

MAGIC_ENTER_GIT_COMMAND="git status"
MAGIC_ENTER_OTHER_COMMAND="lsd -F"

plugins=(git git-extras fd cp
  command-not-found ruby gitignore
  zsh_reload gem bundler encode64 pip jump
  cargo gradle golang pass redis-cli systemd ubuntu rust tmux yarn laravel laravel5
  bower npm composer magic-enter history-substring-search zsh-completions)

export RPS1="%{$reset_color%}"
source "$ZSH/oh-my-zsh.sh"

# Customize to your needs...
bindkey -e
export KEYTIMEOUT=2

autoload -U compinit promptinit zcalc zsh-mime-setup zmv
compinit
promptinit
zsh-mime-setup

export ANDROID_HOME="$HOME/sdk/android-sdk"
export GOPATH="$HOME/go"
export SCALA_HOME="/usr/local/scala"

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$SCALA_HOME/bin"
export PATH="$PATH:$(yarn global bin)"

export BROWSER="vivaldi"
export GCC_COLORS="auto"
export ELECTRON_TRASH='gio'
export SKIM_DEFAULT_COMMAND='fd --type f'
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Setup zsh-autosuggestions
# source ~/.zsh-autosuggestions/autosuggestions.zsh
#
# # # Enable autosuggestions automatically
# zle-line-init() {
#   zle autosuggest-start
# }
# zle -N zle-line-init

# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive)
# bindkey '^T' autosuggest-toggle


# number of lines kept in history
export HISTSIZE=10000
# # number of lines saved in the history after logout
export SAVEHIST=10000
# # location of history
export HISTFILE=~/.zhistory
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

# setopt VI

unsetopt nomatch

# only fools wouldn't do this ;-)
export EDITOR="vim"


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

#autoload -U compinit
#compinit

# Completion caching
# zstyle ':completion::complete:*' use-cache on
# zstyle ':completion::complete:*' cache-path .zcache
#zstyle ':completion:*:cd:*' ignore-parents parent pwd

#Completion Options
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

# Path Expansion
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

zstyle ':completion:*:*:*:default' menu yes select
zstyle ':completion:*:*:default' force-list always

# [ -f '/etc/DIR_COLORS' ] && eval "$(dircolors -b '/etc/DIR_COLORS')"
eval "$(dircolors)"
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:processes' command "ps -au $USER"

# Group matches and Describe
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'

user-complete(){
    if [[ -n $BUFFER ]] ; then
        zle expand-or-complete
    else
        BUFFER="cd "
        zle end-of-line
        zle expand-or-complete
    fi }
zle -N user-complete
bindkey "\t" user-complete

zmodload zsh/terminfo
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

alias ls='lsd -F'
alias ll='lsd -lF'
alias l='lsd -lF'
alias la='lsd -laF'
alias lt='lsd --tree'
alias grep='grep --color=auto'
alias cls='clear'
alias ch='clear && cd'
alias :q='exit' # because I often mis-type :p
alias tmux='TERM=xterm-256color tmux'
alias gr='[ ! -z `git rev-parse --show-toplevel`  ] && cd `git rev-parse --show-toplevel || pwd`'
alias rm='trash'
alias ipy="ipython3"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [[ "$TERM" == "dumb" ]]; then
  setopt No_zle
  PROMPT='%n@%M %/
  >>'
  alias ls='ls -F'
fi

export HISTCONTROL="ignoredups ignorespace"

#set LANG
if [[ "$TERM" =~ "^xterm" ]]; then
  export LANG='zh_TW.utf8'
  export LC_ALL='zh_TW.utf8'
  export LANGUAGE='zh_TW:en'
else
  export LANG='en_US.utf8'
  export LC_ALL='en_US.utf8'
  export LANGUAGE='en'
fi

function mp42mp3 {
  parallel ffmpeg -i "{}" -vn "{.}.mp3" ::: "$@"
}

function o {
  xdg-open "$1" > /dev/null 2>&1 &!
}

function present {
  PRESENT=1 zsh
}

function calc {
  zcalc -e "$*"
}

if [[ ! -z "$PRESENT" ]]; then
  PROMPT="$ "
fi

source "$HOME/.cargo/env"

cls

# BEGIN Ruboto setup
# source ~/.rubotorc
# END Ruboto setup

autoload -U bashcompinit && bashcompinit

source <(gopass completion bash)


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/snow/.sdkman"
[[ -s "/home/snow/.sdkman/bin/sdkman-init.sh" ]] && source "/home/snow/.sdkman/bin/sdkman-init.sh"
