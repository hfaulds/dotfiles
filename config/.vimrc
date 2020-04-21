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

set rtp+=/usr/local/opt/fzf
nnoremap <leader>f :FZF<CR>

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

set hidden

execute "!bash -c 'cd ~/.vim/pack/hfaulds/start/LanguageClient-neovim.git && ./install.sh'"

" Language Client Settings
let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_virtualTextPrefix = ''
let g:LanguageClient_loggingFile =  expand('~/.local/share/nvim/LanguageClient.log')
let g:LanguageClient_serverStderr = expand('~/.local/share/nvim/LanguageServer.log')

" Language Client Language Specific Settings
let g:LanguageClient_serverCommands = {
    \ 'go': ['/Users/haydenfaulds/go/bin/gopls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'ruby': ['/usr/local/bin/solargraph', 'stdio'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ }

" Language Client Autocomplete
set completefunc=LanguageClient#complete
let g:SuperTabDefaultCompletionType = "<c-x><c-u>"

" Language Client Commands
command!                                Definition     call LanguageClient#textDocument_definition()
command!                                TypeDefinition call LanguageClient#textDocument_typeDefinition()
command! -nargs=1                       Rename         call LanguageClient#textDocument_rename({'newName': <f-args>})
command!                                Format         call LanguageClient#textDocument_formatting()
command!                                References     call LanguageClient#textDocument_references()
command!                                Info           call LanguageClient#textDocument_hover()

" Rename File Command
command! -nargs=1 -complete=file -bang  RenameFile     call RenameFile("<args>", "<bang>")
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
