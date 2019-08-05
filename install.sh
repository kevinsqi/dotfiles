# TODO conditional on if .bashrc/.vimrc are files
mv ~/.bashrc ~/.bashrc.bak.`date +%Y%m%d%H%M%S`
mv ~/.bash_profile ~/.bash_profile.bak.`date +%Y%m%d%H%M%S`
mv ~/.vimrc ~/.vimrc.bak.`date +%Y%m%d%H%M%S`

DOTFILE_DIR="$( cd "$( dirname "$0" )" && pwd )"

# symlink synced files
ln -s $DOTFILE_DIR/.bashrc ~/.bashrc
ln -s $DOTFILE_DIR/.bash_profile ~/.bash_profile
ln -s $DOTFILE_DIR/.vimrc ~/.vimrc
ln -s $DOTFILE_DIR/.gitignore_global ~/.gitignore_global

# mac-specific (TODO make conditional)
ln -s $DOTFILE_DIR/.bashrc_osx ~/.bashrc_osx
ln -s $DOTFILE_DIR/.git-completion.bash ~/.git-completion.bash

# z.sh
ln -s $DOTFILE_DIR/z.sh ~/z.sh

# git stuff
cp $DOTFILE_DIR/.gitignore ~/.gitignore
git config --global core.excludesfile ~/.gitignore_global

# upgrade vim to vim8
brew install vim --with-override-system-vi

# install black plugin with pip
pip3 install black

# install vim plugins
if [ ! -d "~/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +BundleInstall +qall
fi

# install homebrew packages
brew install
  fd \
  fzf \
  the_silver_searcher \
  webp \
  wget \
  yarn \
  httpie \

# fzf installation
$(brew --prefix)/opt/fzf/install
