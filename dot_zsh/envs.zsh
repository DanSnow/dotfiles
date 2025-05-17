export ANDROID_HOME="$HOME/sdk/android-sdk"
export GOPATH="$HOME/go"
export SCALA_HOME="/usr/local/scala"
export WASMTIME_HOME="$HOME/.wasmtime"
#export BROWSER="vivaldi"
export EDITOR="avim"
export GCC_COLORS="auto"
export ELECTRON_TRASH='gio'
export SKIM_DEFAULT_COMMAND='fd --type f'
export MANPAGER="sh -c 'sed -e s/.\\\\x08//g | bat -l man -p'"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export COLORTERM=truecolor
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_CONFIG_HOME="$HOME/.config"
export GDK_BACKEND=wayland
export COMPOSE_BAKE=true

# number of lines kept in history
export HISTSIZE=10000
# # number of lines saved in the history after logout
export SAVEHIST=10000
# # location of history
export HISTFILE=~/.zhistory

export HISTCONTROL="ignoredups ignorespace"

#set LANG
if [[ "$TERM" =~ "^xterm" ]]; then
  export LANG='zh_TW.utf8'
  export LC_ALL='zh_TW.utf8'
  export LANGUAGE='zh_TW:en'
else
  export LANG='en_US.utf8'
  export LC_ALL='en_US.utf8'
  export LANGUAGE='en'
fi

export RUSTC_WRAPPER='sccache'
