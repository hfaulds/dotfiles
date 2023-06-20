let g:solarized_termcolors=256

let mapleader = ","

" ----------------------------------------------
" Setup basic Vim behaviour
" ----------------------------------------------

syntax on

set number                " Line numbers
set scrolloff=3           " More context around cursor
set shiftwidth=2          " Number of spaces to autoformat tabs to
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

set noswapfile

let g:fzf_preview_window = []
execute("set rtp+=" . system("dirname $(dirname $(readlink -f $(which fzf)))"))

set hidden

" File functions
function! RenameFile(name, bang)
    let l:curfile = expand("%:p")
    let l:curfile_stripped = substitute(l:curfile, " ", "\\\\ ", "g")
    let l:curfilepath = expand("%:p:h")
    let l:newname = l:curfilepath . "/" . a:name
    let l:newname = substitute(l:newname, " ", "\\\\ ", "g")
    let v:errmsg = ""

    silent! exe "saveas " . a:bang . " " . l:newname
    if v:errmsg =~# '^$\|^E329'
        if expand("%:p") !=# l:curfile && filewritable(expand("%:p"))
            silent exe "bwipe! " . l:curfile_stripped
            if delete(l:curfile)
                echoerr "Could not delete " . l:curfile
            endif
        endif
    else
        echoerr v:errmsg
    endif
endfunction

function! Mkdir()
  silent! !mkdir -p %:h
endfunction

function! Search()
  let l:term = expand("<cword>")
  exec ":Ack!" l:term
endfunction

" File commands
command! Mkdir call Mkdir()
command! -nargs=1 -complete=file -bang  RenameFile     call RenameFile("<args>", "<bang>")

" Search
command! Search call Search()
