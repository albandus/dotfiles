" Auto install vim-plug
" Source: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let mapleader="\<SPACE>"
" Reload configuration
nnoremap <C-c> :so $MYVIMRC<CR>

call plug#begin()

Plug 'https://github.com/christoomey/vim-tmux-navigator'
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-Left>  :TmuxNavigateLeft<CR>
nnoremap <silent> <C-Down>  :TmuxNavigateDown<CR>
nnoremap <silent> <C-Up>    :TmuxNavigateUp<CR>
nnoremap <silent> <C-Right> :TmuxNavigateRight<CR>

Plug 'https://github.com/plasticboy/vim-markdown'
Plug 'https://github.com/dhruvasagar/vim-table-mode'

Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/Xuyuanp/nerdtree-git-plugin'
" Ctrl+n focus Nerd tree (no open/close), only focus
map <C-n> :NERDTreeFocus<CR>
" leader+n synchronize nerd tree with current file
noremap <leader>n :NERDTreeFind<CR>

Plug 'https://github.com/junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'https://github.com/junegunn/fzf.vim'
nnoremap <C-z> :FZF<CR>

Plug 'https://github.com/preservim/nerdcommenter'

" vim-airline
Plug 'https://github.com/vim-airline/vim-airline'
" Automatically displays all buffers when there's only one tab open.
let g:airline#extensions#tabline#enabled = 1

" Highlight whitespace chars. Provide function :StripWhitespace
Plug 'https://github.com/ntpeters/vim-better-whitespace'

" Use ALE for code completion.
let g:ale_completion_autoimport = 1
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_go_golangci_lint_options = '--enable gci'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_column_always = 1
" Linters.
let g:ale_linters = {
\	'go': ['golangci-lint'],
\}
" Fixers.
let g:ale_fixers = {
\	'go': ['goimports', 'trim_whitespace', 'remove_trailing_lines'],
\	'javascript': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\	'css': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\	'html': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\	'php': ['php_cs_fixer', 'trim_whitespace', 'remove_trailing_lines'],
\}
Plug 'https://github.com/dense-analysis/ale'

call plug#end()

" Avoid folding by default
set foldlevelstart=99

" searches to middle of the screen
nnoremap n nzz
nnoremap N Nzz

"" Searching
set hlsearch   " highlight matches
set incsearch  " incremental searching
set ignorecase " searches are case insensitive...
set smartcase  " ... unless they contain at least one capital letter

" Ruler bar on
set ruler

" Improve rendering and copy paste
set lazyredraw
set ttyfast

" Make the post-search window usable again!
nnoremap <C-l> :nohlsearch<CR>
" No ex mode.
map Q <Nop>

set nowrap
set backspace=indent,eol,start
" backspace in cmd mod
nnoremap <bs> X
set number

" Copy-paste mode.
nnoremap <F8> :set  number!<CR>:NERDTreeClose<CR>

" quick access to global buffer
noremap <leader>y "+y
noremap <leader>p "+p

"""" Quick navigation in quickfix buffers.
""" nnoremap <C-n> :cnext<CR>
"""nnoremap <C-p> :cprevious<CR>
"""nnoremap <C-q> :cclose<CR>

" My custom names to force "bash" syntax detection
if exists("*SetFileTypeSH")
  " Custom syntax file associations
  au BufNewFile,BufRead .bashrc*,bashrc,bash_*,.bash_*, call SetFileTypeSH("bash")
endif

" Maximum number of changes that can be undone.
set undolevels=500

"set tabstop=4
"set shiftwidth=4
"set softtabstop=4
"set expandtab

" persistent undo
set undodir=~/.vim/undodir
set undofile

" Change bracket highlighting, make it clear to known where is the cursor
hi MatchParen cterm=underline ctermbg=none
