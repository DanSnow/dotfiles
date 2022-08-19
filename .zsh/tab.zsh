user-complete () {
  if [[ -n $BUFFER ]] ; then
    # zle expand-or-complete
    zle fzf-tab-complete
  else
    BUFFER="cd "
    zle end-of-line
    # zle expand-or-complete
    zle fzf-tab-complete
  fi
}
zle -N user-complete
bindkey "\t" user-complete

function expand-dots() {
    local MATCH
    if [[ $LBUFFER =~ '\.\.\.+' ]]; then
        LBUFFER=$LBUFFER:fs%\.\.\.%../..%
    fi
}

function expand-dots-then-expand-or-complete() {
    zle expand-dots
    zle user-complete
    # zle expand-or-complete
}

function expand-dots-then-accept-line() {
    zle expand-dots
    zle accept-line
}

zle -N expand-dots
zle -N expand-dots-then-expand-or-complete
zle -N expand-dots-then-accept-line
bindkey '^I' expand-dots-then-expand-or-complete
bindkey '^R' mcfly-history-widget
# bindkey '^M' expand-dots-then-accept-line
