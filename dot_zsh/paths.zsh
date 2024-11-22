function prepend_path() {
  local x="$1"
  # always prepend path
  PATH="$x:$PATH"
}

function append_path() {
  local x="$1"
  case ":$PATH:" in
    *":$x:"*) :;;
    *) PATH="$PATH:$x";;
  esac
}

function dedup_path() {
  # https://unix.stackexchange.com/questions/40749/remove-duplicate-path-entries-with-awk-command
  if [ -n "$PATH" ]; then
    old_PATH=$PATH:; PATH=
    while [ -n "$old_PATH" ]; do
      x=${old_PATH%%:*}       # the first remaining entry
      case $PATH: in
        *:"$x":*) ;;          # already there
        *) PATH=$PATH:$x;;    # not there yet
      esac
      old_PATH=${old_PATH#*:}
    done
    PATH=${PATH#:}
    unset old_PATH x
  fi
}


prepend_path "$WASMTIME_HOME/bin"
prepend_path "$HOME/.local/bin"
prepend_path "$HOME/.local/share/ponyup/bin"
prepend_path "$HOME/bin"
prepend_path "$BUN_INSTALL/bin"
append_path "$HOME/go/bin"
append_path "$HOME/sdk/android-sdk/tools"
append_path "$HOME/.deno/bin"
append_path "$HOME/.moon/bin"
