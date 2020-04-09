# dotfiles 

## Installation

- Install [YADM](https://yadm.io)
- `yadm clone --bootstrap https://github.com/mattstratton/dotfiles.git`

## Description

Here's what is the bootstrap is doing:

- Install zsh with [oh-my-zsh](https://ohmyz.sh/) as a plugin manager
- Install all the packages/apps from `.Brewfile` using [Homebrew](https://brew.sh)

## What remains to do

- Set zsh as your default shell

```bash
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)
```

- Install the VSCode extension `Settings Sync` to sync VSCode