#
# symlink dotfiles
#

# TODO conditional on if .bashrc/.vimrc are files
mv ~/.bashrc ~/.bashrc.bak.`date +%Y%m%d%H%M%S`
mv ~/.bash_profile ~/.bash_profile.bak.`date +%Y%m%d%H%M%S`
mv ~/.vimrc ~/.vimrc.bak.`date +%Y%m%d%H%M%S`

DOTFILE_DIR="$( cd "$( dirname "$0" )" && pwd )"

ln -s $DOTFILE_DIR/.bashrc ~/.bashrc
ln -s $DOTFILE_DIR/.bash_profile ~/.bash_profile
ln -s $DOTFILE_DIR/.vimrc ~/.vimrc
ln -s $DOTFILE_DIR/.gitignore_global ~/.gitignore_global
ln -s $DOTFILE_DIR ~/

# z.sh
ln -s $DOTFILE_DIR/z.sh ~/z.sh


#
# mac preferences
#

ln -s $DOTFILE_DIR/.bashrc_osx ~/.bashrc_osx
ln -s $DOTFILE_DIR/.git-completion.bash ~/.git-completion.bash

# Trackpad scrolling direction
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# show hidden files in finder
defaults write com.apple.finder AppleShowAllFiles YES && killall Finder

# show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keyboard - Key repeat (fastest)
defaults write NSGlobalDomain KeyRepeat -int 2

# Keyboard - Delay until repeat (2 notches left of short)
defaults write NSGlobalDomain InitialKeyRepeat -int 35

# Dock - minimize with scale effect
defaults write com.apple.dock mineffect -string scale && killall Dock

# Enable key repeat by holding down key (e.g. vscode)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false


#
# git
#

cp $DOTFILE_DIR/.gitignore ~/.gitignore
git config --global core.excludesfile ~/.gitignore_global

#
# vim
#

echo "\n\n\n"
echo "install.sh - vim"
echo "\n\n\n"

# upgrade vim to vim8
brew install vim

# install vim plugins
if [ ! -d "~/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +BundleInstall +qall
fi

# install black plugin with pip
# pip3 install black

# TODO: handle linux
# fd - https://github.com/sharkdp/fd#installation

#
# homebrew packages
#

echo "\n\n\n"
echo "install.sh - homebrew packages"
echo "\n\n\n"

brew install \
  fd \
  fzf \
  the_silver_searcher \
  webp \
  wget \
  yarn \
  httpie \

brew cask install \
  sublime-text \
  iterm2 \
  visual-studio-code \
  1password \
  gifox \

# fzf installation
$(brew --prefix)/opt/fzf/install

# optional, long homebrew packages
# brew install postgresql
# brew install awscli
# brew install terraform

#
# iTerm2 config
#

# Specify preferences config directory
# (assumes presence of ~/dotfiles symlink)
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/dotfiles/iterm2_profile"

# Use config from directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true


#
# mac app store apps
#

echo "\n\n\n"
echo "install.sh - installing mac app store apps"
echo "\n\n\n"

brew install mas

echo "Sign in to App Store to install apps with mas. Press enter to continue:"
open -a "app store"
read _

mas install 441258766  # Magnet
mas install 961632517  # Be Focused Pro


#
# Non-scriptable preferences
#

echo "\n\n\n"
echo "install.sh complete! Here are some non-scriptable preferences to configure."

echo "\n"
echo "Magnet:"
echo "    Preferences -> Remove 'Up' shortcut"
echo "    Preferences -> Rebind 'Maximize' to control + option + up"
echo "    Preferences -> Enable 'Launch at login'"
echo "    Preferences -> Disable 'Snap windows by dragging'"

echo "\n"
echo "1Password:"
echo "    Preferences -> Keyboard shortcuts -> Disable 'Fill Login or Show 1Password' (cmd + \ conflicts with Google Docs)"

