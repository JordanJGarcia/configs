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
set smartindent

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
