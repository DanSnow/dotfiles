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

zinit lucid for \
  OMZP::rust \
  OMZP::docker-compose \
  OMZP::command-not-found \
  OMZP::copybuffer \
  OMZP::copypath \
  OMZP::copyfile \
  OMZP::cp \
  OMZP::extract \
  OMZP::git \
  OMZP::git-extras \
  OMZP::github \
  OMZP::yarn \

# zinit lucid for \
#   OMZP::rust \
#   OMZP::command-not-found \
#   OMZP::copybuffer \
#   OMZP::copypath \
#   OMZP::copyfile \
#   OMZP::cp \
#   OMZP::extract \
#   OMZP::git \
#   OMZP::git-extras \
#   OMZP::github \
#   OMZP::gitignore \
#   OMZP::npm \
#   OMZP::pip \
#   OMZP::ruby \
#   OMZP::sudo \
#   OMZP::yarn \

zinit lucid wait for \
  OMZP::alias-finder \
  OMZP::bgnotify \
  OMZP::composer \
  OMZP::debian \
  OMZP::dircycle \
  OMZP::direnv \
  OMZP::docker-compose \
  OMZP::encode64 \
  OMZP::fancy-ctrl-z \
  OMZP::fzf \
  OMZP::gem \
  OMZP::golang \
  OMZP::kubectl \
  OMZP::laravel \
  OMZP::laravel5 \
  OMZP::minikube \
  OMZP::mosh \
  OMZP::systemd \
  OMZP::taskwarrior \
  OMZP::tmux \
  OMZP::ubuntu \
  Tarrasch/zsh-bd \
  atclone'./zplug.zsh' g-plane/zsh-yarn-autocompletions \
  zsh-users/zsh-completions \
  MichaelAquilina/zsh-you-should-use \
  memark/zsh-dotnet-completion \
  Cloudstek/zsh-plugin-appup \
  null from'gh' autoload'deer' atload"fpath+='\$PWD'; zle -N deer;bindkey '\ek' deer" vifon/deer \
  reegnz/jq-zsh-plugin \
  hlissner/zsh-autopair \
  macunha1/zsh-terraform \
  mellbourn/zabb \

zinit light-mode lucid for \
  OMZP::magic-enter \
  atinit"zicompinit; zicdreplay" zdharma/fast-syntax-highlighting \
  zsh-users/zsh-history-substring-search \
  atload="!enable-fzf-tab" Aloxaf/fzf-tab \
  atload"!_zsh_autosuggest_start" zsh-users/zsh-autosuggestions
