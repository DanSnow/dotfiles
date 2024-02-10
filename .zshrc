# CodeWhisperer pre block. Keep at the top of this file.
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

source "$HOME/.cargo/env"
source "$HOME/.zsh/init.zsh"

# clear
dedup_path
eval "$(_kn init --shell zsh)"

tere() {
  local result=$(command tere "$@")
  [ -n "$result" ] && cd -- "$result"
}

eval "$(mise activate -s zsh)"
eval "$(zoxide init zsh)"
eval "$(navi widget zsh)"
