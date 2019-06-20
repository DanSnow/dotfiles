#!/bin/bash

OH_MY_ZSH_URL="https://github.com/robbyrussell/oh-my-zsh.git"
SPACESHIP_THEME_URL="https://github.com/denysdovhan/spaceship-prompt.git"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  git clone "$OH_MY_ZSH_URL" ~/.oh-my-zsh
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt" ]; then
  git clone "$SPACESHIP_THEME_URL" ~/.oh-my-zsh/custom/themes/spaceship-prompt
  ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme
fi

cp .zshrc ~
