## TODO

* Need to manually set core excludesfile? (git config --global core.excludesfile ~/.gitignore\_global)
* Interactive prompt style, and use ruby/python
* Add more to install.sh
* Use thoughtbot's dotfile install approach? rcm + .dotfile.local overrides: https://github.com/thoughtbot/dotfiles
* Take ideas from thoughtbot's vimrc, etc

## Installation

Prerequisites:

```
brew install the_silver_searcher
````

Symlink bashrc/vimrc and install vim plugins:

```
./install.sh
```

Configurable:

* Copy .gitconfig and modify (e.g. email)
Other:
* Copy .ssh.config.template to ~/.ssh/config
* Copy .bashrc.local.template to ~/.bashrc.local

Optional:

* Create ~/.pgpass and `chmod 600 ~/.pgpass`
* Symlink .psqlrc
* Symlink .eslintrc (or .jshintrc)
* Symlink coffeelint.json
