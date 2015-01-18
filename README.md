## TODO

* Use thoughtbot's dotfile install approach? rcm + .dotfile.local overrides: https://github.com/thoughtbot/dotfiles
* Take ideas from thoughtbot's vimrc, etc

## Installation

* Symlink .bashrc
* Symlink .bashrc\_rvm (if using rvm)
* Symlink .vimrc
* Symlink .gitconfig (or copy and edit)
* Symlink .jshintrc (optional)
* Install vundle: https://github.com/gmarik/Vundle.vim
* Configure .ssh/config to prevent ssh broken pipe errors:
    ```
    Host *
        ServerAliveInterval 300
    ```
