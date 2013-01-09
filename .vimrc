" Pathogen
call pathogen#infect()

" Match XML tags using % with matchit
runtime macros/matchit.vim

" set background=dark
set ignorecase 
set smartcase
set title
set scrolloff=3
set ruler

" Enable mouse
" set mouse=a

" Intuitive backspacing in insert mode
set backspace=indent,eol,start
 
" File-type highlighting and configuration.
" Run :filetype (without args) to see what you may have
" to turn on yourself, or just set them all to be sure.
syntax on
filetype on
filetype plugin on
filetype indent on
 
" Highlight search terms dynamically as they are typed
set hlsearch
set incsearch

" Ruby 2-space tabs
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2
set autoindent

autocmd FileType html setlocal shiftwidth=2 tabstop=2 expandtab softtabstop=2 autoindent

" Press F2 in insert mode to paste text with proper indentation
nnoremap <F2> :set invpaste ?<CR>
set pastetoggle=<F2>
set showmode

" Make 'ga' split the current tab and then navigate to tab under the cursor (depends on vim-rails 'gf' command)
map ga :tab split<Enter>gf

" Set backup directory
" set swapfile
" set dir=~/backup/vim

" Increase tab maximum. I'm a wild man.
set tabpagemax=60

" Tab completion
set wildmode=longest,list
" set wildmode=longest,list,full
" set wildmenu

" Line numbers (:set nonu[mber] to remove for terminal copy/paste)
set number
highlight LineNr ctermfg=grey ctermbg=darkgrey
