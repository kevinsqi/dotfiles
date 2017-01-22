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

# git stuff
cp $DOTFILE_DIR/.gitignore ~/.gitignore
git config --global core.excludesfile ~/.gitignore_global

# install vim plugins
if [ ! -d "~/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +BundleInstall +qall
fi
