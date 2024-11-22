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
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_EXIT_CODE_SHOW='true'

function {
  if (( ! ${+commands[starship]} )); then
    print -P "%F{red}You must install starship.%f"
    return 1
  fi

  local starship_cache="$HOME/.cache/starship-init-cache"
  if [[ "$commands[starship]" -nt "$starship_cache" || ! -s "$starship_cache" ]]; then
    starship init zsh --print-full-init >| "$starship_cache"
  fi
  source "$starship_cache"
}

