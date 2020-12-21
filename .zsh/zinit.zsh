### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

zinit lucid as"completion" for \
  OMZP::fd/_fd \
  OMZP::rust/_rust \
  OMZP::pass/_pass \
  OMZP::redis-cli/_redis-cli \
  OMZP::cargo/_cargo \
  OMZP::github/_hub \
  OMZP::extract/_extract \
  OMZP::gem/_gem \
  OMZP::bundler/_bundler \
  OMZP::pip/_pip \
  OMZP::gradle/_gradle \
  OMZP::laravel/_artisan \

zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZL::theme-and-appearance.zsh

zinit lucid wait for\
  sbin posva/catimg \

GIT_COMPLETE=/usr/share/zsh/functions/Completion/Unix/_git

zinit lucid wait for \
  OMZP::alias-finder \
  OMZP::bgnotify \
  OMZP::bundler \
  OMZP::command-not-found \
  OMZP::composer \
  OMZP::copybuffer \
  OMZP::copydir \
  OMZP::copyfile \
  OMZP::cp \
  OMZP::debian \
  OMZP::dircycle \
  OMZP::encode64 \
  OMZP::extract \
  OMZP::fancy-ctrl-z \
  atload"unalias o" OMZP::fasd \
  OMZP::fzf \
  OMZP::gem \
  OMZP::git \
  OMZP::git-extras \
  OMZP::github \
  OMZP::gitignore \
  OMZP::golang \
  OMZP::gradle \
  OMZP::jump \
  OMZP::kubectl \
  OMZP::laravel \
  OMZP::laravel5 \
  OMZP::minikube \
  OMZP::mosh \
  OMZP::npm \
  OMZP::pip \
  OMZP::ruby \
  OMZP::sudo \
  OMZP::systemd \
  OMZP::taskwarrior \
  OMZP::tmux \
  OMZP::ubuntu \
  OMZP::yarn \
  OMZP::zsh_reload \
  atload"compdef _git-add forgit::add;
    compdef _git-reset forgit::reset::head;
    compdef _git-diff forgit::diff;
    compdef _git-rebase forgit::rebase" src"$GIT_COMPLETE" wfxr/forgit \
  Tarrasch/zsh-bd \
  atclone'./zplug.zsh' g-plane/zsh-yarn-autocompletions \
  zsh-users/zsh-completions \
  MichaelAquilina/zsh-you-should-use \
  memark/zsh-dotnet-completion \
  # greymd/tmux-xpanes \

zinit ice as"program" pick"$ZPFX/sdkman/bin/sdk" id-as'sdkman' run-atpull \
    atclone"wget 'https://get.sdkman.io/?rcupdate=false' -O scr.sh; SDKMAN_DIR=$ZPFX/sdkman bash scr.sh" \
    atpull"SDKMAN_DIR=$ZPFX/sdkman sdk selfupdate" \
    atinit"export SDKMAN_DIR=$ZPFX/sdkman; source $ZPFX/sdkman/bin/sdkman-init.sh"
zinit light zdharma/null

zinit ice as"command" wait lucid \
    atinit"export PYTHONPATH=$ZPFX/lib/python3.8/site-packages/" \
    atclone"PYTHONPATH=$ZPFX/lib/python3.8/site-packages/ \
    python3 setup.py --quiet install --prefix $ZPFX" \
    atpull'%atclone' test'0' \
    pick"$ZPFX/bin/asciinema"
zinit load asciinema/asciinema.git

zinit light-mode lucid for \
  OMZP::magic-enter \
  atinit"zicompinit; zicdreplay" zdharma/fast-syntax-highlighting \
  zsh-users/zsh-history-substring-search \
  atload="!enable-fzf-tab" Aloxaf/fzf-tab \
  atload"!_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \


