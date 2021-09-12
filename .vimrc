" https://vimhelp.org/options.txt.html

let mapleader=","
set autoindent
set autowrite
set cindent
set cursorline
set esckeys
set expandtab
set hlsearch
set ignorecase
set incsearch
set lazyredraw
set linebreak
set nocompatible
set nofoldenable
set nostartofline
set number
set ruler
set secure
set showcmd
set showmatch
set showmode
set smartcase
set smartindent
set smarttab
set title
set ttyfast
set wildmenu
set backspace=indent,eol,start
set colorcolumn=78
set encoding=utf8
set fileencoding=utf8
set foldmethod=syntax
set laststatus=2
set matchtime=10
set mouse=a
set scrolloff=5
set shiftwidth=4
set softtabstop=4
set tabstop=4
set virtualedit=block
set undodir=~/.vim
set backupdir=~/.vim
set directory=~/.vim

syntax enable
filetype plugin on
filetype indent on

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>
