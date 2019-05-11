set nocompatible
call pathogen#infect()
filetype plugin indent on
syntax on
"colorscheme darkermate
syntax enable
set background=dark
let g:solarized_termcolors=256
"colorscheme solarized

let mapleader = ","

" ----------------------------------------------
" Setup basic Vim behaviour
" ----------------------------------------------

set autoindent
set autowrite       " Writes on make/shell commands
set backspace=start,indent,eol
set cf              " Enable error files & error jumping.
" set cursorline
" set expandtab
set hidden          " Allow buffer switching without saving
set history=1000    " Remember a decent way back
set laststatus=2    " Always show status line.
set mousehide
set nowrap          " Line wrapping off
set number          " line numbers
set ruler           " Ruler on
set scrolloff=3     " More context around cursor
set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize
set shiftwidth=2
set smarttab
set statusline=%<%f\ %h%m%r%=%-20.(line=%l\ of\ %L,col=%c%V%)\%h%m%r%=%-40(,%n%Y%)\%P%#warningmsg#%*
set tabstop=2
set timeoutlen=500
set wildmode=list:longest " Shell-like behaviour for command autocompletion
set fillchars+=vert:\  "Set the window borders to not have | chars in them

" Search options
set hlsearch        " highlight search matches...
set incsearch       " ...as you type
set ignorecase
set smartcase

let g:ackprg = 'ag --nogroup --nocolor --column'
noremap <Leader>a :Ack! -w <cword><cr>

" ----------------------------------------------
" Command Shortcuts
" ----------------------------------------------

" make W and Q act like w and q
command! W :w
command! Q :q

" make Y consistent with C and D
nnoremap Y y$

" ,c to show hidden characters
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>c :set nolist!<CR>

" ,sw to strip whitespace off the ends
nmap <silent> <Leader>sw :call StripTrailingWhitespace()<CR>

" Ignores files in any VCS or tmp directory
set wildignore+=tmp/*,*.so,*.swp,*.zip

" F5 to reload doc
map <silent> <F5> <esc>:e %<CR>

" ----------------------------------------------
" Window split & size shortcuts
" ----------------------------------------------

" C-A-h and C-A-l to resize vertical split
map <C-A-h> :vertical resize -7<CR>
map <C-A-l> :vertical resize +7<CR>

" C-A-j and C-A-k to resize horizontal split
map <C-A-j> :resize -5<CR>
map <C-A-k> :resize +5<CR>

" C-H and C-L to jump left and right between splits
map <C-h> <C-w>h
map <C-l> <C-w>l
"
" C-J and C-K to jump down and up between splits
map <C-j> <C-w>j
map <C-k> <C-w>k


" ----------------------------------------------
" <ESC> Shortcuts
" ----------------------------------------------

imap jkl <ESC>
imap jlk <ESC>
imap kjl <ESC>
imap klj <ESC>
imap lkj <ESC>
imap ljk <ESC>
imap ;l <ESC>
imap jk <ESC>
imap kj <ESC>

" ----------------------------------------------
" Setup Misc Vim Behaviours
" ----------------------------------------------

autocmd FileType go set noexpandtab
autocmd FileType ruby set expandtab
autocmd FileType proto set expandtab
autocmd FileType json set expandtab

" Treat scss files as css
au BufRead,BufNewFile *.scss set filetype=css

" Extend % to do/end etc
runtime! plugin/matchit.vim

" Highlight trailing whitespace
highlight RedundantSpaces term=standout ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/ "\ze sets end of match so only spaces highlighted

" Jump to last cursor position when opening a file
" Don't do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal g`\""
    endif
  end
endfunction

" strip trailing whitespace<foo&bar>
"autocmd BufWritePre,FileWritePre * call StripTrailingWhitespace()
function! StripTrailingWhitespace()
	normal mz
	normal Hmy
	exec '%s/\s*$//g'
	normal 'yz<cr>
	normal `z
endfunction

" Enable wrapping when editing text documents (eg Markdown)
autocmd BufNewFile,BufRead *.md :setlocal wrap

" ----------------------------------------------
"  Set the git gutter colors to be the same as the number column
" ----------------------------------------------
hi clear SignColumn

"-" ,] to toggle the tags sidebar
"-nmap <Leader>] :TagbarToggle<CR>
" Set the Gutter to show all the time, avoiding the column 'pop' when saving
set signcolumn=yes

let &t_Co=256
set shell=/bin/zsh

:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/
set noswapfile

set rtp+=/usr/local/opt/fzf
nnoremap <leader>f :FZF<CR>
let g:syntastic_javascript_checkers = ['eslint']

" yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)

let g:syntastic_go_checkers = ['golint', 'govet']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'relativepath', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'fileformat' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'relativepath', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'fileformat' ] ]
      \ },
      \ }

nnoremap <silent> <Leader>t :!script/test<CR>

function! Test1() abort
  echom go#util#Offset(line('.'), col('.'))
endfunction

function! s:go_guru_scope_from_git_root()
  let gitroot = system("git rev-parse --show-toplevel | tr -d '\n'")
  let pattern = escape(go#util#gopath() . "/src/", '\ /')
  return substitute(gitroot, pattern, "", "") . "/... -vendor/"
endfunction

au FileType go silent exe "GoGuruScope " . s:go_guru_scope_from_git_root()

augroup syntax
	au BufNewFile,BufReadPost *.workflow so ~/.vim/syntax/workflow.vim
augroup END
au BufNewFile,BufReadPost *.workflow set filetype=workflow

"autocmd FileType ruby autocmd BufWritePre !bin/rubocop -a <afile>
