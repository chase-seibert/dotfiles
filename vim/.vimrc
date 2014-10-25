" pathogen
call pathogen#infect()
syntax on
filetype plugin indent on

" reload .vimrc every time it's written
au! BufWritePost $MYVIMRC source $MYVIMRC

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" save buffer when the window losses focus
au FocusLost * silent! wall
" au FocusLost * :wa
" can't set both of these, gets into a weird buffer with read errors state
set autoread

" expand tabs into tabstop spaces; use same for shifts
" 4 spaces == python standard, see: http://www.python.org/dev/peps/pep-0008/#indentation
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4  " backspace deletes 4 spaces
set autoindent  " next line starts and same indentation

set wildmenu  " show completions in a menu
set visualbell  " no beeping
"set relativenumber  " easier to type commands w/ line counts
set number

" searching
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

set wrap  " wrap automatically, but don't break words
set linebreak
" set colorcolumn=81  " show a column barier

" don't let me use arrow keys; still training myself
"nnoremap <up> <nop>
"nnoremap <down> <nop>
"nnoremap <left> <nop>
"nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" colon is too often used to require a shift
nnoremap ; :

" I never use these, that's what source control is for
set nobackup
set nowritebackup
set noswapfile

" Solarized color schema
"colorscheme solarized
colorscheme Tomorrow-Night

if (&term == "xterm")
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" tags
" sudo apt-get install exuberant-ctags
" ctags -R -o ctags .
"set tags=ctags

" Automatically cd into the directory that the file is in
"set autochdir

" Enable mouse support in console
set mouse=a

" This is totally awesome - remap jj to escape in insert mode.  You'll never
" type jj anyway, so it's great!
inoremap jj <Esc>
nnoremap JJJJ <Nop>

" show commands as you type them in the lower right
set showcmd
set laststatus=2  " always show the status line, even with a single file open

if has("gui_gtk2")
    "set guifont=Ubuntu\ Mono\ 15
    set guifont=DejaVu\ Sans\ Mono\ 13
    "set guifont=Liberation\ Mono\ 14
    "set guifont=Monospace\ 14
endif
" fonts for gvim
if has("win32")
    set guifont=Consolas:h10
endif
if has("mac")
    set guifont=Menlo\ Regular:h13
endif

" GUI toolbar disable
if has("gui_running")
    set guioptions=egmrti
    if has("gui_gtk2")
    elseif
        set transparency=5
    endif
endif

" for ctrlp
set wildignore+=*.pyc
let g:ctrlp_regexp = 1

" syntax checking
let g:syntastic_python_checker = "pyflakes"

" map normal paste combo, use the system clipboard for regular yank
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa
set clipboard=unnamedplus
if has("mac")
    set clipboard=unnamed
endif
if has("gui_gtk2")
    set clipboard=unnamedplus
endif
cmap <S-Insert>  <C-R>+  " paste into command line w/ shift-insert
xnoremap p pgvy  " paste doesn't blow away the register

" remember to run :RopeOpenProject in HearsayLabs

" map spell check toggle
nmap <silent> <leader>s :set spell!<CR>

" hide certain exts in NERDTree
let NERDTreeIgnore = ['\.pyc$']
"
" python-mode
let g:pymode_folding = 0
let g:pymode_syntax_space_errors = 0
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'pylint']
let g:pymode_lint_ignore="E121,E125,E126,E128,E501,W,E1101,E1103"
let g:pymode_lint_cwindow = 0
let g:pymode_lint_signs = 1
let g:pymode_rope_goto_definition_cmd = 'e'  " e, new or vnew

" needed to revert backspace change from OSX +python
set backspace=indent,eol,start

" opens search results in a window w/ links and highlight the matches
command! -nargs=+ Grep execute 'silent grep! -I -r -n --exclude *.json --exclude *.pyc --exclude *.po --exclude-dir external --exclude-dir virtualenv . -e <args>' | copen | execute 'silent /<args>'
" shift-control-* Greps for the word under the cursor
:nmap <leader>g :Grep <c-r>=expand("<cword>")<cr><cr>

" powerline: https://github.com/Lokaltog/powerline
"python from powerline.ext.vim import source_plugin; source_plugin()

augroup filetypedetect
    au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
    au BufWritePost *.js :JSHint
augroup END

" vim-gitgutter correct background color on gutter
highlight clear SignColumn
