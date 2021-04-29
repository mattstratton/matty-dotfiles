# dotfiles  
(inspired by @mattstratton)
## Prerequisites
- Make sure you have signed into the Apple Store so that [mas](https://github.com/mas-cli/mas) will work
- XCode Command Line Utils need to be installed (`xcode-select —install`)


## Installation

- Install [YADM](https://yadm.io)
```bash
sudo mkdir /usr/local/bin && sudo curl -fLo /usr/local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm && sudo chmod a+x /usr/local/bin/yadm
```
- `yadm clone --bootstrap https://github.com/jerdog/jerdog-dotfiles.git`

## Description

Here's what the `bootstrap` file for `yadm` is doing:

- Install `zsh` with [oh-my-zsh](https://ohmyz.sh/) as a plugin manager
- Install [Homebrew](https://brew.sh) and then all of the packages/apps from `Brewfile`

## Manual things to do after

- Set the homebrew zsh as the default shell

```bash
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)
```

- Install the VSCode extension [Syncing](https://marketplace.visualstudio.com/items?itemName=nonoroazoro.syncing) to sync VSCode
- Delete `/usr/local/bin/yadm` and run `brew bundle` again to get `yadm` set up in homebrew properly
