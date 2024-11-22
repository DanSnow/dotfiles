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

