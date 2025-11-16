
source $HOME/.zsh/envs.zsh
source $HOME/.zsh/config.zsh
source $HOME/.zsh/spaceship.zsh
source $HOME/.zsh/dotbins.zsh
source $HOME/.zsh/plugin-settings.zsh
source $HOME/.zsh/sheldon.zsh
# source $HOME/.zsh/zinit.zsh
source $HOME/.zsh/paths.zsh
source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/tab.zsh
source $HOME/.zsh/zoxide.zsh
source $HOME/.zsh/flirt.zsh
source $HOME/.zsh/atuin.zsh

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

export RPS1="%{$reset_color%}"
if [[ "$TERM" == "dumb" ]]; then
  setopt No_zle
  PROMPT='%n@%M %/
  >>'
  alias ls='ls -F'
fi

if [[ ! -z "$PRESENT" ]]; then
  PROMPT="$ "
fi

function {
  local pfunction_glob='^([_.]*|prompt_*_setup|README*|*~)(-.N:t)'
  # https://github.com/sorin-ionescu/prezto/blob/9ae279e25ad4afed2c069cf537b9984474afe5a4/init.zsh
  # Add functions to $fpath.
  fpath=($HOME/.zsh/functions(-/FN) $fpath)
  local pfunction

  # Extended globbing is needed for listing autoloadable function directories.
  setopt LOCAL_OPTIONS EXTENDED_GLOB

  # Load Prezto functions.
  for pfunction in $HOME/.zsh/functions/$~pfunction_glob; do
    autoload -Uz "$pfunction"
  done
}
