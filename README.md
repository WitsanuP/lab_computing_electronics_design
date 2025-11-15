# how to sim 
hspice -i [file].sp -o [file].lis

# addition in vim maping : add this line and using F5 to sim
nnoremap <F5> :w<CR>:!hspice -i % -o %<.lis<CR>

# check error
grep -i error [file].lis



# my .vimrc
- set number
- set relativenumber

- set tabstop=4
- set shiftwidth=4
- set softtabstop=4
- set expandtab


