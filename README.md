## TODO

* Use thoughtbot's dotfile install approach? rcm + .dotfile.local overrides: https://github.com/thoughtbot/dotfiles
* Take ideas from thoughtbot's vimrc, etc

## Installation

* Symlink .bashrc
* Symlink .bashrc\_rvm (if using rvm)
* Symlink .vimrc
* Symlink .gitconfig

* Set git email: `git config --global user.email <email>`

* Symlink .gitignore\_global
* May need to run `git config --global core.excludesfile ~/.gitignore_global`?

* Symlink .jshintrc (optional)
* Symlink coffeelint.json (optional)

* Install vundle: https://github.com/gmarik/Vundle.vim

* Copy .ssh.config.template to ~/.ssh/config
* Copy .bashrc.local.template to ~/.bashrc.local
* Create ~/.pgpass and `chmod 600 ~/.pgpass`
