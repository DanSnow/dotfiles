# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Features

- **Encryption**: Sensitive data encrypted with [age](https://github.com/FiloSottile/age)
- **Modern CLI Tools**: Rust-based replacements for traditional Unix tools
- **Modular ZSH**: 15+ separate modules for maintainable shell configuration
- **Multi-language Dev**: Go, Rust, Scala, Android, .NET environments configured

## Structure

```
.
├── dot_zsh/              # ZSH configuration modules
│   ├── init.zsh          # Entry point, sources all modules
│   ├── aliases.zsh       # Command aliases
│   ├── config.zsh        # ZSH options and completion
│   ├── envs.zsh          # Environment variables
│   └── ...               # Additional modules
├── dot_config/           # Tool configurations
│   ├── ghostty/          # Terminal emulator
│   ├── lazygit/          # Git TUI
│   ├── mise/             # Runtime version manager
│   ├── starship.toml     # Prompt configuration
│   └── ...               # 17+ tool configs
├── bin/                  # Custom scripts
├── dot_zshrc             # ZSH main config
├── dot_zshenv            # ZSH environment
└── dot_gitconfig         # Git configuration
```

## Key Tools

| Category | Tools |
|----------|-------|
| Shell | zsh, starship, sheldon |
| File Management | lsd, fd, bat, yazi |
| Search | ripgrep, fzf, zoxide |
| Version Control | git, lazygit, jujutsu (jj) |
| Containers | lazydocker |
| Runtime Management | mise |
| Editor | neovim (avim) |

## Installation

```bash
# Install chezmoi and apply dotfiles
chezmoi init --apply <repo-url>

# Or if chezmoi is already installed
chezmoi init <repo-url>
chezmoi apply
```

## Usage

```bash
# Update dotfiles from source
chezmoi update

# Edit a managed file
chezmoi edit <file>

# See what would change
chezmoi diff

# Apply changes
chezmoi apply
```

## Requirements

- chezmoi
- age (for encryption)
