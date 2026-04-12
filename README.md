# Dotfiles

Personal dotfiles managed with [yadm](https://yadm.io/).

## What's included

| Config | File | Description |
|--------|------|-------------|
| Zsh | `.zshrc` | Shell config with zinit, powerlevel10k, zoxide, mcfly |
| Git | `.gitconfig` | Aliases, merge/rebase settings, branch helpers |
| Neovim | `.config/nvim/init.lua` | Kickstart-based config with LSP, Treesitter, Telescope, Copilot |
| Alacritty | `.alacritty.toml` | JetBrains Mono Nerd Font, Catppuccin Mocha theme |
| Homebrew | `Brewfile` | All packages and casks |
| Navi | `cheats/` | Custom cheat sheets for Heroku and Kafkacat |

## Setup on a new machine

```bash
# Install yadm
brew install yadm

# Clone dotfiles
yadm clone https://github.com/kyleboon/dotfiles.git

# Install Homebrew packages
brew bundle --file=~/.Brewfile

# Install navi cheat sheets
cd cheats && ./install.sh
```
