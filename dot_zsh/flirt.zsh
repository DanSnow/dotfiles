# Source this to get flirt support in ZSH.

# I have no idea what I'm doing.
flirt-widget() {
  LBUFFER="${LBUFFER}$(flirt -x)"
  local ret=$?
  zle reset-prompt
  return $ret
}

zle -N flirt-widget
bindkey '^s' flirt-widget
