set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
luafile $HOME/.config/nvim/private.lua
luafile $HOME/.config/nvim/public.lua
