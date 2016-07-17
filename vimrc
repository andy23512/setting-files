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
Plugin 'django.vim'
" Plugin 'klen/python-mode'
" Plugin 'CSSMinister'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'ntpeters/vim-better-whitespace'

call vundle#end()            " required
filetype plugin indent on    " required

" If no screen, use color term
if ($TERM == "vt100")
  " ref: :help color, search for Tera Term Pro settings or ETerm settings
        " TeraTermPro
	"set t_Co=16
	"set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{32}%+5;%;%dm
	"set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{22}%+1;%;%dm
	" Eterm
"        set t_Co=16
"        set t_AF=[%?%p1%{8}%<%t3%p1%d%e%p1%{22}%+%d;1%;m
"        set t_AB=[%?%p1%{8}%<%t4%p1%d%e%p1%{32}%+%d;1%;m
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
	" set foldcolumn=2
    " set foldmethod=syntax
    set foldmethod=marker
    set foldlevel=1
"    set foldtext=/^/=>
    set encoding=utf-8
    set fileencodings=utf-8,big5,ucs-bom,latin1
    set termencoding=utf-8
else
    set fileencoding=taiwan
endif
au BufNewFile,BufRead *.less set filetype=less
let Tlist_Sort_Type = "order"
let Tlist_WinWidth = 30
let Tlist_Inc_Winwidth = 0
"let Tlist_Use_Right_Window = 1
runtime taglist.vim

"set winminheight=0
"set winminwidth=0
"runtime bufexplorer.vim

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

inoremap <Esc>Oq <Home>
inoremap <Esc>Op <End>
nnoremap <Esc>Oq <Home>
nnoremap <Esc>Op <End>
nnoremap <C-C> <C-A>

xnoremap <silent> s :sort<CR>
xnoremap <silent> S :sort!<CR>

"noremap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>

" IDE
"nnoremap <silent> <F5>	:cwindow<CR>
"nnoremap <silent> <F6>	:make<CR>
"nnoremap <silent> <F7>	:TlistUpdate<CR>
"nnoremap <silent> <F8>	:Tlist<CR>
"nnoremap <silent> <F9>	:edit .<CR>
"nnoremap <silent> <F10>	:BufExplorer<CR>

hi Comment ctermfg = LightMagenta 

filetype plugin indent on
au BufNewFile,BufReadPost *.ls setl softtabstop=2 shiftwidth=2 expandtab

let g:indentLine_color_term = 005

"using python3
let g:pymode_python = 'python3'

"ignore line length error
let g:pymode_lint_ignore = 'E501,W601'
let g:pep8_ignore = 'E501,W601'

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=5
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=7
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

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

" vi:sw=4:ts=4
