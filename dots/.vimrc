" plugins {{{
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

Plug 'ellisonleao/gruvbox.nvim'
Plug 'chriskempson/base16-vim'
Plug 'lervag/vimtex'
Plug 'airblade/vim-gitgutter'
Plug 'szw/vim-maximizer'
Plug 'ARM9/arm-syntax-vim'
Plug 'godlygeek/tabular'
Plug 'numToStr/Comment.nvim'

" LSP Support
Plug 'neovim/nvim-lspconfig'                           " Required
" Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'} " Optional
" Plug 'williamboman/mason-lspconfig.nvim'               " Optional

" Autocompletion
Plug 'hrsh7th/nvim-cmp'     " Required
Plug 'hrsh7th/cmp-nvim-lsp' " Required
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'     " Required

Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}

Plug 'LnL7/vim-nix'
Plug 'mechatroner/rainbow_csv'

Plug 'whonore/Coqtail'

" telescope + deps
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

" Initialize plugin system
call plug#end()

" vimtex
let g:tex_flavor = 'latex'
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'hooks' : [],
    \ 'options' : [
    \   '-verbose',
    \   '-shell-escape',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

" autocmd vimenter * ++nested colorscheme gruvbox
" let g:gruvbox_contrast_dark = 'soft'

let g:gitgutter_sign_added    = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed  = '-'
let g:gitgutter_sign_modified_removed = '~-'

" arm assembly syntax highlighting
au BufNewFile,BufRead *.s,*.S set filetype=arm

" coqtail
autocmd FileType coq nnoremap <C-l> <cmd>CoqToLine<cr>
autocmd FileType coq inoremap <C-l> <cmd>CoqToLine<cr>

" telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" }}}

" set* {{{

syntax on
" prevents buggy syntax highlighting in large files
syntax sync minlines=3000
set nocompatible
filetype plugin indent on

set mouse=a

if !has('nvim')
  set ttymouse=sgr
endif

" cursor wrapping
set whichwrap=b,s,<,>,[,]

" ui
" highlight trailing whitespace
set list lcs=trail:~,extends:@,precedes:@,tab:\·\ 
set display=lastline "@@@ on wrap
set number relativenumber
"set colorcolumn=80
"set cursorline

" indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" :command tab completions
set wildmenu

set lazyredraw
set timeoutlen=1000 ttimeoutlen=0
set updatetime=100

" find (and replace) settings
set ignorecase
set smartcase
set incsearch
set nohlsearch

" change the direction of new splits
set splitbelow
set splitright

set foldnestmax=2

" leader y copies selection into "c and puts in system clipboard
vnoremap <silent><Leader>y "cy <Bar> :call system('xclip -selection clipboard', @c)<CR>

" }}}

" common typos {{{

:nnoremap q: :q
cabbrev Q q
cabbrev W w
cabbrev Wq wq

cabbrev tn     tabnew
cabbrev Tabnew tabnew
cabbrev tm     tabmove

" }}}

" theming {{{

" signcolumn?
" override the LineNr bar bg
" highlight LineNr          ctermfg=244   ctermbg=bg
" highlight CursorLineNr    ctermfg=244   ctermbg=bg
" 
" highlight GitGutterAdd    ctermfg=2     ctermbg=bg
" highlight GitGutterDelete ctermfg=1     ctermbg=bg
" highlight GitGutterChange ctermfg=3     ctermbg=bg
" highlight! link GitGutterChangeDelete GitGutterDelete
" 
" highlight NonText         ctermfg=244
" highlight ModeMsg         ctermfg=244
" " highlight ModeMsg        ctermfg=101
" 
" " disable inactive tab underline
" highlight TabLine         cterm=none    ctermfg=244 ctermbg=bg
" highlight TabLineSel      ctermfg=fg    ctermbg=bg
" highlight TabLineFill     ctermfg=bg    ctermbg=bg
" highlight Title           ctermfg=244   ctermbg=bg
" 
" highlight Search          cterm=none    ctermbg=fg  ctermfg=bg
" highlight IncSearch       cterm=reverse ctermbg=bg  ctermfg=fg
" 
" highlight WildMenu        ctermfg=bg    ctermbg=fg
" 
" highlight StatusLine      ctermfg=bg    ctermbg=fg
" "highlight StatusLine      ctermbg=fg
" "highlight StatusLine      ctermfg=236
" highlight StatusLineNC    ctermfg=bg    ctermbg=245
" "highlight StatusLineNC    ctermfg=236
" 
" "highlight Visual ctermbg=13
" "highlight Visual ctermfg=bg
" 
" highlight CocInlayHint    ctermfg=59

" }}}

" markdown {{{

" markdown to html compilation
" :command MdCompile !filename=% ; filename=${filename:0:-3} ; markdown -\o "$filename.html" %
:command MdCompile !pandoc -s -f markdown --katex -t html -o '%:r.html' --metadata title='%:t:r' %

" compile markdown on save
" autocmd BufWrite *.md :silent MdCompile

" enable and set spellcheck to english without capitalisation rules
autocmd FileType markdown set spell | set spelllang=en | set spellcapcheck=

" don't highlight katex underscores
autocmd FileType markdown syn match MarkdownIgnore "\$.*_.*\$"

" }}}

map Y yy

" on <c-w>z make current window widest and tallest possible
noremap <c-w>z <c-w>_ \| <c-w>\|

" coqtail-style bindings for tex editing
autocmd FileType tex nnoremap <C-l> <cmd>write<cr>
autocmd FileType tex inoremap <C-l> <cmd>write<cr>

" prolog syntax highlighting for asp
autocmd BufEnter,BufNew *.lp set syntax=prolog

" vim:foldmethod=marker:foldlevel=0
