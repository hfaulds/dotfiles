let g:solarized_termcolors=256

let mapleader = ","

" ----------------------------------------------
" Setup basic Vim behaviour
" ----------------------------------------------

syntax on

set number          " Line numbers
set scrolloff=3     " More context around cursor
set shiftwidth=2    " Number of spaces to autoformat tabs to
set tabstop=2       " Number of spaces to display tabs as
set wildmode=list:longest " Shell-like behaviour for command autocompletion

" Search options
set ignorecase
set smartcase

let g:ackprg = 'ag --nogroup --nocolor --column'
noremap <Leader>a :Ack! -w <cword><cr>

" ----------------------------------------------
" Command Shortcuts
" ----------------------------------------------

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
" Setup Misc Vim Behaviours
" ----------------------------------------------

autocmd FileType go set noexpandtab
autocmd FileType ruby set expandtab
autocmd FileType eruby set expandtab
autocmd FileType proto set expandtab
autocmd FileType json set expandtab

" Treat scss files as css
au BufRead,BufNewFile *.scss set filetype=css

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

function! s:go_guru_scope_from_git_root()
  let gitroot = system("git rev-parse --show-toplevel | tr -d '\n'")
  let pattern = escape(go#util#gopath() . "/src/", '\ /')
  return substitute(gitroot, pattern, "", "") . "/... -vendor/"
endfunction

au FileType go silent exe "GoGuruScope " . s:go_guru_scope_from_git_root()

let g:go_bin_path = "/usr/local/bin/go"
let $GOPATH = $HOME."/go"
