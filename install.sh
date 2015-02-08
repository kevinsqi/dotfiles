# TODO not yet tested

# TODO conditional on if .bashrc/.vimrc are files
mv ~/.bashrc ~/.bashrc.bak.`date +%Y%m%d%H%M%S`
mv ~/.vimrc ~/.vimrc.bak.`date +%Y%m%d%H%M%S`

DOTFILE_DIR="$( cd "$( dirname "$0" )" && pwd )"
ln -s $DOTFILE_DIR/.bashrc ~/.bashrc
ln -s $DOTFILE_DIR/.vimrc ~/.vimrc

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim +BundleInstall +qall
