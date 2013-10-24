com! AStags !ASTags

so $VIM/grep.vim
noremap <leader>a :ASgrep 
noremap <leader>g :ASgrep 
noremap <leader>w :ASgrep 

nnoremap <silent> <leader>* 0i.*
nnoremap <silent> <leader>; ^i;

vnoremap <silent> ]] /\.PROGRAM<CR>
vnoremap <silent> ][ /\.END<CR>
vnoremap <silent> [[ ?\.PROGRAM<CR>
vnoremap <silent> [] ?\.END<CR>

nnoremap <silent> y] V/\.END<CR>y:noh<CR>
nnoremap <silent> y[ ?\.PROGRAM<CR>V/\.END<CR>y:noh<CR>
