let mapleader = ","

" ----------------------------------------------
" Setup basic Vim behaviour
" ----------------------------------------------

set number                " Line numbers
set scrolloff=3           " More context around cursor
set shiftwidth=2          " Number of spaces to autoformat tabs to
set wildmode=list:longest " Shell-like behaviour for command autocompletion

" Search options
set ignorecase
set smartcase

let g:ackprg = 'ag --nogroup --nocolor --column'

" ----------------------------------------------
" Command Shortcuts
" ----------------------------------------------

" ,sw to strip whitespace off the ends
nmap <silent> <Leader>sw :call StripTrailingWhitespace()<CR>

" Ignores files in any VCS or tmp directory
set wildignore+=tmp/*,*.so,*.swp,*.zip

" ----------------------------------------------
"  Set the git gutter colors to be the same as the number column
" ----------------------------------------------
hi clear SignColumn

"-" ,] to toggle the tags sidebar
"-nmap <Leader>] :TagbarToggle<CR>
" Set the Gutter to show all the time, avoiding the column 'pop' when saving
set signcolumn=yes

set noswapfile

let g:fzf_preview_window = []
execute("set rtp+=" . system("dirname $(dirname $(readlink -f $(which fzf)))"))
