# Solve nautilus open in terminal
if readlink -f /usr/bin/x-terminal-emulator | grep -v gnome > /dev/null; then
  if ps -o cmd= -p $(ps -o ppid= -p $$) | grep -q gnome; then
    nohup x-terminal-emulator &> /dev/null &
    wait $!
    exit
  fi
fi

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte-2.91.sh
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
source /home/snow/.config/broot/launcher/bash/br
source "$HOME/.cargo/env"
source "$HOME/.zsh/init.zsh"

clear
dedup_path
