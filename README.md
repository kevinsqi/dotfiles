## TODO

* Use thoughtbot's dotfile install approach? rcm + .dotfile.local overrides: https://github.com/thoughtbot/dotfiles
* Take ideas from thoughtbot's vimrc, etc

## Installation

* Symlink .bashrc
* Symlink .bashrc\_osx and .git-completion.bash and .bash\_profile (if using OSX)
* Symlink .vimrc
* Symlink .gitconfig

Git:

* Set git email: `git config --global user.email <email>`
* Symlink .gitignore\_global
* Run `git config --global core.excludesfile ~/.gitignore_global`

Optional:

* Symlink .jshintrc (optional)
* Symlink coffeelint.json (optional)

Vim:

* Install ag (see vimrc for details)
* Install vundle: https://github.com/gmarik/Vundle.vim
* In vim: `PluginInstall`

Other:

* Copy .ssh.config.template to ~/.ssh/config
* Copy .bashrc.local.template to ~/.bashrc.local
* Create ~/.pgpass and `chmod 600 ~/.pgpass`
