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

# z.sh
ln -s $DOTFILE_DIR/z.sh ~/z.sh


#
# mac preferences
#

ln -s $DOTFILE_DIR/.bashrc_osx ~/.bashrc_osx
ln -s $DOTFILE_DIR/.git-completion.bash ~/.git-completion.bash

# show hidden files in finder
defaults write com.apple.finder AppleShowAllFiles YES && killall Finder


#
# git
#

cp $DOTFILE_DIR/.gitignore ~/.gitignore
git config --global core.excludesfile ~/.gitignore_global

#
# vim
#

# upgrade vim to vim8
brew install vim

# install vim plugins
if [ ! -d "~/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +BundleInstall +qall
fi

#
# homebrew packages
#

brew install \
  fd \
  fzf \
  the_silver_searcher \
  webp \
  wget \
  yarn \
  httpie \

# fzf installation
$(brew --prefix)/opt/fzf/install

# optional, long homebrew packages
# brew install postgresql
# brew install awscli
# brew install terraform

# install black plugin with pip
# pip3 install black
