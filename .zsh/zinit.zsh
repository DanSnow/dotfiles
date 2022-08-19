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
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust \
    zdharma-continuum/zinit-annex-bin-gem-node
    # zinit-zsh/z-a-as-monitor \

### End of Zinit's installer chunk

zinit lucid as"completion" for \
  OMZP::fd/_fd \
  OMZP::rust/_rustc \
  OMZP::pass/_pass \
  OMZP::redis-cli/_redis-cli \
  OMZP::github/_hub \
  OMZP::extract/_extract \
  OMZP::gem/_gem \
  OMZP::bundler/_bundler \
  OMZP::pip/_pip \
  OMZP::gradle/_gradle \
  OMZP::laravel/_artisan \
  OMZP::docker-compose/_docker-compose \

zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZL::theme-and-appearance.zsh

# zinit lucid wait for\
  # sbin posva/catimg \

GIT_COMPLETE=/usr/share/zsh/functions/Completion/Unix/_git

  # atload"unalias o" OMZP::fasd \
  # wookayin/fzf-fasd \

zinit lucid wait for \
  OMZP::alias-finder \
  OMZP::bgnotify \
  OMZP::bundler \
  OMZP::rust \
  OMZP::command-not-found \
  OMZP::composer \
  OMZP::copybuffer \
  OMZP::copypath \
  OMZP::copyfile \
  OMZP::cp \
  OMZP::debian \
  OMZP::dircycle \
  OMZP::direnv \
  OMZP::docker-compose \
  OMZP::encode64 \
  OMZP::extract \
  OMZP::fancy-ctrl-z \
  atload"bindkey ^R mcfly-history-widget" OMZP::fzf \
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
  atload"compdef _git-add forgit::add;
    compdef _git-reset forgit::reset::head;
    compdef _git-diff forgit::diff;
    compdef _git-rebase forgit::rebase" src"$GIT_COMPLETE" wfxr/forgit \
  Tarrasch/zsh-bd \
  atclone'./zplug.zsh' g-plane/zsh-yarn-autocompletions \
  zsh-users/zsh-completions \
  MichaelAquilina/zsh-you-should-use \
  memark/zsh-dotnet-completion \
  Cloudstek/zsh-plugin-appup \
  null from'gh' autoload'deer' atload"fpath+='\$PWD'; zle -N deer;bindkey '\ek' deer" vifon/deer \
  reegnz/jq-zsh-plugin \
  hlissner/zsh-autopair \
  @asdf-vm/asdf \
  macunha1/zsh-terraform \
  mellbourn/zabb \
  spwhitt/nix-zsh-completions \
  chisui/zsh-nix-shell \
  as"completion" pick"contrib/completions/_ffsend" timvisee/ffsend \
  as"program" from"gh-r" mv"ffsend-* -> ffsend" pick"ffsend" id-as"ffsend-bin" timvisee/ffsend \
  as"program" from"gh-r" pick"mcfly" atpull"mcfly init zsh > $ZSH_CACHE_DIR/mcfly.zsh" atclone"%atpull" src"$ZSH_CACHE_DIR/mcfly.zsh" cantino/mcfly \
  as"program" from"gh-r" bpick"*linux-gnu.zip" pick"kn*/_kn" atpull"_kn init --shell=zsh > $ZSH_CACHE_DIR/kn.zsh" atclone"%atpull" src"$ZSH_CACHE_DIR/kn.zsh" micouy/kn \
  as"program" from"gh-r" bpick"*x86_64*linux*" mv"zoxide-*/zoxide -> zoxide" \
  pick"zoxide" atpull"zoxide init --no-aliases zsh > $ZSH_CACHE_DIR/zoxide.zsh" atclone"%atpull" src"$ZSH_CACHE_DIR/zoxide.zsh" ajeetdsouza/zoxide
  # src'fm.zsh' atclone'./fm__compile' atpull'%atclone' ddnexus/fm \
  # greymd/tmux-xpanes \

# zinit ice as "program" from"gh-r" mv"ffsend-* -> ffsend" light timvisee/ffsend

# zinit ice as"program" pick"$ZPFX/sdkman/bin/sdk" id-as'sdkman' run-atpull \
#     atclone"wget 'https://get.sdkman.io/?rcupdate=false' -O scr.sh; SDKMAN_DIR=$ZPFX/sdkman bash scr.sh" \
#     atpull"SDKMAN_DIR=$ZPFX/sdkman sdk selfupdate" \
#     atinit"export SDKMAN_DIR=$ZPFX/sdkman; source $ZPFX/sdkman/bin/sdkman-init.sh"
# zinit light zdharma/null

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
