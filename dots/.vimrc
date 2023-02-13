" plugins {{{
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Plug 'morhetz/gruvbox'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'chriskempson/base16-vim'
Plug 'lervag/vimtex'
Plug 'airblade/vim-gitgutter'
Plug 'szw/vim-maximizer'
Plug 'ARM9/arm-syntax-vim'
Plug 'godlygeek/tabular'

" completion plugins
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

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

" {{{ coc

" coc jsonc support
autocmd FileType json syntax match Comment +\/\/.\+$+

" Configuration for coc.nvim from https://scalameta.org/metals/docs/editors/vim.html

" If hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Toggle panel with Tree Views
nnoremap <silent> <space>t :<C-u>CocCommand metals.tvp<CR>
" Toggle Tree View 'metalsPackages'
nnoremap <silent> <space>tp :<C-u>CocCommand metals.tvp metalsPackages<CR>
" Toggle Tree View 'metalsCompile'
nnoremap <silent> <space>tc :<C-u>CocCommand metals.tvp metalsCompile<CR>
" Toggle Tree View 'metalsBuild'
nnoremap <silent> <space>tb :<C-u>CocCommand metals.tvp metalsBuild<CR>
" Reveal current current class (trait or object) in Tree View 'metalsPackages'
nnoremap <silent> <space>tf :<C-u>CocCommand metals.revealInTreeView metalsPackages<CR>

" }}}

" coqtail
autocmd FileType coq nnoremap <C-l> <cmd>CoqToLine<cr>
autocmd FileType coq inoremap <C-l> <cmd>CoqToLine<cr>

" treesitter
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" }}}

" set* {{{

syntax on
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
