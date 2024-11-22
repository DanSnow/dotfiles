(( $+functions[compdef] )) && {
  # zsh word mode completion
  _zoxide_zsh_word_complete() {
    [ "$1" ] && local _zoxide_cur="$1"
    [ -z "$_zoxide_cur" ] && local _zoxide_cur="${words[CURRENT]}"
    local fnd="$(echo "${_zoxide_cur//,/ }" | sed 's/^[ ]*//' )"
    zoxide query -l "$fnd" 2>> "/dev/null" | \
      while read -r line; do
        compadd -U -V zoxide "$line"
      done
    # compstate[insert]=menu # no expand
  }
  _zoxide_zsh_word_complete_trigger() {
    local _zoxide_cur="${words[CURRENT]}"
    _zoxide_zsh_word_complete $_zoxide_cur
  }
  # define zle widgets
  zle -C zoxide-complete complete-word _generic
  zstyle ':completion:zoxide-complete:*' completer _zoxide_zsh_word_complete
  zstyle ':completion:zoxide-complete:*' menu-select
}

(( $+functions[compdef] )) && {
  # enable word mode completion
  orig_comp="$(zstyle -L ':completion:\*' completer 2>> "/dev/null")"
  if [ "$orig_comp" ]; then
    case $orig_comp in
      *_zoxide_zsh_word_complete_trigger*);;
      *) eval "$orig_comp _zoxide_zsh_word_complete_trigger";;
    esac
  else
    zstyle ':completion:*' completer _complete _zoxide_zsh_word_complete_trigger
  fi
  unset orig_comp
}

function z {
  __zoxide_z "$@"
}

function j {
  __zoxide_zi "$@"
}
