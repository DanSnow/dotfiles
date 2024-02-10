#!/bin/bash

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
cargo install lsd
cargo install kn
cargo install zoxide
cargo install --locked --force xplr
cargo install fd
cargo install ripgrep
