MAGIC_ENTER_GIT_COMMAND="gst -s"
MAGIC_ENTER_OTHER_COMMAND="ls"
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
  history-search-forward
  history-search-backward
  history-beginning-search-forward
  history-beginning-search-backward
  history-substring-search-up
  history-substring-search-down
  up-line-or-beginning-search
  down-line-or-beginning-search
  up-line-or-history
  down-line-or-history
  magic-enter
  bracketed-paste
  accept-line
  copy-earlier-word
)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC='true'

function bgnotify_formatted { ## args: (exit_status, command, elapsed_seconds)
  local elapsed="$(( $3 % 60 ))s"
  (( $3 >= 60 )) && elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
  (( $3 >= 3600 )) && elapsed="$(( $3 / 3600 ))h $elapsed"
  local title
  if [[ $1 == 0 ]]; then
    title="\"$2\" Completed"
  else
    title="\"$2\" Failed($1)"
  fi
  local body="Took $elapsed"
  bgnotify "$title" "$body"
}

export ZSH_THEME=''
DISABLE_AUTO_UPDATE="true"

export MCFLY_INTERFACE_VIEW=BOTTOM
export MCFLY_FUZZY=true
