#!/bin/sh
# Kicks off the full `yadm bootstrap` process

# Step 1 - clone the yadm repo
yadm clone --bootstrap https://github.com/jerdog/jerdog-dotfiles.git

# Step 2 - cleanup the yadm install
## setup homebrew zsh as the default shell
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)

## delete yadm and run 'brew install yadm' again to get yadm setup correctly
sudo rm /usr/local/bin/yadm
brew install yadm

## Final notes:
echo "Things to do after yadm is installed:"
echo "1. Install the following apps manually:"
echo "-Logitech Options+ - https://www.logitech.com/en-us/options-plus"