export ZSH="$HOME/.local/share/sheldon/repos/github.com/ohmyzsh/ohmyzsh"

plugins=(alias-finder bgnotify rust extract docker-compose command-not-found copybuffer copyfile git github direnv dircycle encode64 fancy-ctrl-z fzf magic-enter)

eval "$(sheldon source)"
