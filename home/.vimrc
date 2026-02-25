filetype plugin indent on

" set default shell
set shell=/bin/bash

" turn on syntax highlighting
syntax on

" show cursor location
set cursorline

" allow command auto-completion
" and have it behave similar to Bash completion
set wildmenu
set wildmode=list:longest

" set tab expansion/spacing
set shiftwidth=4
set tabstop=4
set expandtab
set smarttab
set nosmartindent

" set search preferences
hi Search cterm=NONE ctermfg=DarkGrey ctermbg=yellow
set incsearch
set hlsearch
set showmatch

" Do not wrap lines
set nowrap

" Set the number of commands to save in history
set history=100

" set spellcheck
" set spell

" set line numbers
" set number

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" add NERDTree
call plug#begin()
  Plug 'preservim/nerdtree'
call plug#end()

" Start NERDTree and leave the cursor in it.
autocmd VimEnter * NERDTree

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
