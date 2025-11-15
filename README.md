# about this project
using hspice to simulation and practice 
# how to sim 
hspice -i [file].sp -o [file].lis

# how to view wave
wv [file].tr0

# addition in vim maping : add this line and using F5 to sim
nnoremap <F5> :w<CR>:!hspice -i % -o %<.lis<CR>

# check error
grep -i error [file].lis



# my .vimrc
- set number
- set relativenumber
-
- set tabstop=4
- set shiftwidth=4
- set softtabstop=4
- set expandtab
-
- nnoremap <F5> :w<CR>:!hspice -i % -o %<.lis<CR>


# file 
## .sp

- .tr0
- .mt0
- .l
- .lis


