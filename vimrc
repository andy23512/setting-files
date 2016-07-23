" follow https://github.com/VundleVim/Vundle.vim to setup
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'AutoComplPop'
Plugin 'airblade/vim-gitgutter'
Plugin 'digitaltoad/vim-pug'
Plugin 'gkz/vim-ls'
Plugin 'wavded/vim-stylus'
Plugin 'CSSMinister'
Plugin 'klen/python-mode'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'othree/yajs.vim'
Plugin 'tpope/vim-commentary'
Plugin 'vim-scripts/taglist.vim'

call vundle#end()            " required
filetype plugin indent on    " required

colorscheme default

" If no screen, use color term
if ($TERM == "vt100")
  " ref: :help color, search for Tera Term Pro settings or ETerm settings
  " TeraTermPro
  "set t_Co=16
  "set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{32}%+5;%;%dm
  "set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{22}%+1;%;%dm
  " Eterm
  "set t_Co=16
  "set t_AF=[%?%p1%{8}%<%t3%p1%d%e%p1%{22}%+%d;1%;m
  "set t_AB=[%?%p1%{8}%<%t4%p1%d%e%p1%{32}%+%d;1%;m
  " xterm-color / screen
  set t_Co=8
  set t_AF=[1;3%p1%dm
  set t_AB=[4%p1%dm
endif
set t_Co=8
set t_AF=[1;3%p1%dm
set t_AB=[4%p1%dm
if filereadable($VIMRUNTIME . "/vimrc_example.vim")
  so $VIMRUNTIME/vimrc_example.vim
endif
if filereadable($VIMRUNTIME . "/macros/matchit.vim")
  so $VIMRUNTIME/macros/matchit.vim
endif
" flist support
if filereadable("~/vim/flistmaps.vim")
  so ~/vim/flistmaps.vim
endif
if filereadable(expand("hints"))
  au BufNewFile,BufReadPost *.c,*.C,*.cpp,*.CPP,*.cxx  so hints
endif

syntax on
set noexpandtab
set nocompatible
set nowrap
set wildmenu
set backupdir=~/tmp,.,/var/tmp/vi,/tmp
set directory=~/tmp,/var/tmp/vi,/tmp,.
set undodir=~/tmp
set backup		" keep a backup file
set backupcopy=yes " for brunch
"set textwidth=78
set shiftwidth=4
set tabstop=4
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
set showmatch
set mouse=c
set nf=octal,hex,alpha

"set background=dark	" another is 'light'

" VIM 6.0, We're using VIM on ntucs? Solaris, my own build
if version >= 600
  set nohlsearch
  "set foldcolumn=2
  "set foldmethod=syntax
  set foldmethod=marker
  set foldlevel=1
  "set foldtext=/^/=>
  set encoding=utf-8
  set fileencodings=utf-8,big5,ucs-bom,latin1
  set termencoding=utf-8
else
  set fileencoding=taiwan
endif

" settings based on filetype
au BufNewFile,BufRead *.less set filetype=less
au BufNewFile,BufReadPost *.ls,*.jade setl softtabstop=2 shiftwidth=2 expandtab

" Diff
nnoremap <silent> <C-G>	:diffget<CR>
nnoremap <silent> <C-P>	:diffput<CR>

" Window
nnoremap <silent> <Tab>	:wincmd w<CR>
nnoremap <silent> <C-H>	:wincmd h<CR>
nnoremap <silent> <C-J>	:wincmd j<CR>
nnoremap <silent> <C-K>	:wincmd k<CR>
nnoremap <silent> <C-L>	:wincmd l<CR>
nnoremap <silent> +	:wincmd +<CR>
nnoremap <silent> -	:wincmd -<CR>
nnoremap <silent> <	:wincmd <<CR>
nnoremap <silent> >	:wincmd ><CR>

" Num0 to line start, Num1 to line end
inoremap <Esc>Oq <Home>
inoremap <Esc>Op <End>
nnoremap <Esc>Oq <Home>
nnoremap <Esc>Op <End>

" Increment
nnoremap <C-C> <C-A>

" Sort hot key
xnoremap <silent> s :sort<CR>
xnoremap <silent> S :sort!<CR>

" IDE
"nnoremap <silent> <F5>	:cwindow<CR>
"nnoremap <silent> <F6>	:make<CR>
nnoremap <silent> <F7>	:TlistUpdate<CR>
nnoremap <silent> <F8>	:Tlist<CR>
"nnoremap <silent> <F9>	:edit .<CR>
"nnoremap <silent> <F10>	:BufExplorer<CR>

" comment color
hi Comment ctermfg = LightMagenta

" wrap
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

" special command
command Nanoha 0read !head ~/nanoha

" #########################################################################
" plugin options

" taglist options
let Tlist_Sort_Type = "order"
let Tlist_WinWidth = 30
let Tlist_Inc_Winwidth = 0
"let Tlist_Use_Right_Window = 1
runtime taglist.vim

" python_mode options
if has('python3')
  let g:pymode_python = 'python3'
elseif has('python')
  let g:pymode_python = 'python'
endif
let g:pymode_lint_ignore = 'E501,W601' " ignore line length error
let g:pep8_ignore = 'E501,W601' " ignore line length error

" vim-indent-guides
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=5
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=7
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1


" vi:et:sw=2:ts=2:sts=2
