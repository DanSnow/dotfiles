#!/usr/bin/env bash

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if chezmoi is installed
if ! command -v chezmoi &> /dev/null; then
    echo "Error: chezmoi is not installed"
    echo "Install it with: brew install chezmoi"
    exit 1
fi

echo "Adding common dotfiles to chezmoi..."

# Array of common dotfiles to add
dotfiles=(
    # Zsh
    "$HOME/.zshrc"
    "$HOME/.zsh"
    "$HOME/.zshenv"

    # Config files
    "$HOME/.config/yazi"
    "$HOME/.config/dotfiles"
    "$HOME/.config/avim"
    "$HOME/.config/jj"
    "$HOME/.config/lazygit"
    "$HOME/.config/lazydocker"
    "$HOME/.config/mise"
    "$HOME/.config/sheldon"
    "$HOME/.config/ghostty"
    "$HOME/.config/topgrade.toml"
    "$HOME/.config/starship.toml"
    "$HOME/.config/nvim"
    "$HOME/.config/git"
    "$HOME/.config/zsh"

    # Git
    "$HOME/.gitconfig"
    "$HOME/.gitignore_global"

)

# Add each dotfile if it exists
for dotfile in "${dotfiles[@]}"; do
    if [ -e "$dotfile" ]; then
        echo "Adding: $dotfile"
        chezmoi add "$dotfile"
    else
        echo "Skipping (not found): $dotfile"
    fi
done

echo ""
echo "Dumping Homebrew packages to Brewfile..."

# Dump current brew packages to Brewfile
if command -v brew &> /dev/null; then
    brew bundle dump --file=Brewfile --force
    echo "Brewfile dumped successfully."

    # Pretty print the Brewfile if the formatter exists
    if [ -f "$SCRIPT_DIR/format_brewfile.rb" ]; then
        echo "Formatting Brewfile..."
        ruby "$SCRIPT_DIR/format_brewfile.rb" Brewfile > Brewfile.tmp && mv Brewfile.tmp Brewfile
        echo "Brewfile formatted successfully."
    else
        echo "Warning: format_brewfile.rb not found at $SCRIPT_DIR/format_brewfile.rb, skipping formatting."
    fi

    # Add Brewfile to chezmoi
    chezmoi add Brewfile
    echo "Brewfile added to chezmoi."
else
    echo "Warning: brew is not installed, skipping Brewfile dump."
fi

echo ""
echo "Done! Added dotfiles to chezmoi."
echo "Run 'chezmoi status' to see what was added."
