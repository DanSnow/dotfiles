alias ls='lsd -F --group-dirs=first'
alias ll='lsd -lF'
alias l='lsd -lF'
alias la='lsd -laF'
alias lt='lsd --tree'
alias grep='grep --color=auto'
alias gui='gitui'
alias cls='clear'
alias df='df -h -x squashfs -x tmpfs -x devtmpfs'
alias tmux='TERM=xterm-256color tmux'
alias rm='trash'
alias did="vim +'normal Go' +'r!env LC_ALL=C date' ~/did"
alias idea='eureka'
alias wine=wine-stable
alias rtv='EDITOR=vim RTV_PAGER="bat --paging=always -l=md -p" BROWSER="vivaldi --password-store=gnome" rtv'
alias ytdl='youtube-dl'
alias gadl='gallery-dl'
alias code='codium'
alias fm='ranger'
alias ipy="ipython3 --no-confirm-exit"
alias m='mpv --no-vid'
alias t='x-terminal-emulator'
alias ddg='BROWSER=w3m ddgr'
alias gup='git pull --rebase --autostash'
alias gcjour='git commit -m "[$(date +"%Y-%m-%d")] DanSnow"'
alias gl1d='glol --since="1 day"'
alias b='br -I'
alias e="$EDITOR"
alias tmp="cd $HOME/Tmp"
alias oa='a -e xdg-open'
alias calc='noglob calc'

if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
  alias cbc="wl-copy"
  alias cbp="wl-paste"
else
  function cbc {
    if [[ $# > 0 ]]; then
      echo "$@" | xsel -b
    else
      cat - | xsel -b
    fi
  }
  alias cbp='xsel -bo'
fi

# File Download
if (( $+commands[curl] )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
elif (( $+commands[wget] )); then
  alias get='wget --continue --progress=bar --timestamping'
fi
