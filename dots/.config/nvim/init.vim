set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set guicursor=
set inccommand=nosplit

lua require('gruvbox-config')
lua require('lsp-config')
lua require('treesitter-config')
lua require('telescope-config')
lua require('Comment').setup()
