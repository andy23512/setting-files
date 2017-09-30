" #########################################################################
" Vundle

" follow https://github.com/VundleVim/Vundle.vim to setup
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
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
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-repeat'
Plugin 'vim-scripts/taglist.vim'
Plugin 'tpope/vim-haml'
Plugin 'scrooloose/nerdtree'
Plugin 'posva/vim-vue'
Plugin 'Raimondi/delimitMate'
Plugin 'leafgarland/typescript-vim'
Plugin 'HerringtonDarkholme/yats.vim'
Plugin 'Quramy/tsuquyomi'
Plugin 'Valloric/YouCompleteMe'
Plugin 'Quramy/vim-js-pretty-template'
Plugin 'vim-syntastic/syntastic'
Plugin 'burnettk/vim-angular'

call vundle#end()            " required
filetype plugin indent on    " required

colorscheme default
" #########################################################################
" color term

" If no screen, use color term
if ($TERM == "vt100")
  set t_Co=8
  set t_AF=[1;3%p1%dm
  set t_AB=[4%p1%dm
endif
set t_Co=8
set t_AF=[1;3%p1%dm
set t_AB=[4%p1%dm

" #########################################################################

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

" #########################################################################
" settings

syntax on
set nocompatible " nocompatible with vi
set nowrap
set wildmenu " completion menu at command mode
set ruler " show current line and column position
set incsearch " immediate search
set modelines=1 " enable modeline
set noexpandtab
set shiftwidth=4
set tabstop=4
set bs=2		" allow backspacing over everything in insert mode
set nosmartindent
set noai			" always set autoindenting on
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
set showmatch " show the match { ( <
set mouse=c " disable mouse
set backup		" keep a backup file
set backupcopy=yes " for brunch
set backupdir=~/tmp,.,/var/tmp/vi,/tmp
set directory=~/tmp,/var/tmp/vi,/tmp,.
set undodir=~/tmp

" VIM 6.0, We're using VIM on ntucs? Solaris, my own build
if version >= 600
  set nohlsearch " no highlight search
  set foldmethod=marker " no auto folding
  set foldlevel=1
  set encoding=utf-8
  set fileencodings=utf-8,big5,ucs-bom,latin1
  set termencoding=utf-8
else
  set fileencoding=taiwan
endif

" settings based on filetype
au BufNewFile,BufRead *.less set filetype=less
au BufNewFile,BufRead *.py setl softtabstop=4 shiftwidth=4 expandtab fdm=marker
au BufNewFile,BufRead *.jade,*.json,*.js,*.styl,*.pug,*.ls,*sass,*.html,*.ts setl softtabstop=2 shiftwidth=2 expandtab

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

" comment color
hi Comment ctermfg = LightMagenta

" special command
command Nanoha 0read !head ~/nanoha
command P set paste
command NP set nopaste

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
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=3
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

" nerdtree
let NERDTreeIgnore=['\~$', '\.map']
let NERDTreeMapOpenSplit='s'
map <C-n> :NERDTreeToggle<CR>
au VimEnter * NERDTree
if @% =~# 'nanoha' || @% =~# 'COMMIT_EDITMSG' || &diff
  au VimEnter * NERDTreeClose
endif

" typescript
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" wildignore
set wildignore+=*.a,*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.DS_Store,.git,.hg,.svn
set wildignore+=*~,*.swp,*.tmp
set wildignore+=*.map



" YouComplateMe
if !exists("g:ycm_semantic_triggers")
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers['typescript'] = ['re!\w*[^"]+.']
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1

" vim-js-pretty-template
call jspretmpl#register_tag('styles: \[', 'css')
autocmd FileType typescript JsPreTmpl html
autocmd FileType typescript syn clear foldBraces

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*%f

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi']
" vue
autocmd BufNewFile,BufEnter *.vue setfiletype vue
autocmd FileType vue setlocal autoindent expandtab shiftwidth=2 softtabstop=2 commentstring=//\ %s comments=://
      \ | syntax include @PUG syntax/pug.vim | unlet b:current_syntax
      \ | syntax include @JS syntax/ls.vim | unlet b:current_syntax
      \ | syntax include @SASS syntax/stylus.vim | unlet b:current_syntax
      \ | syntax region vueTemplate matchgroup=vueTag start=/^<template.*>$/ end='</template>' contains=@PUG keepend
      \ | syntax region vueScript matchgroup=vueTag start=/^<script.*>$/ end='</script>' contains=@JS keepend
      \ | syntax region vueStyle matchgroup=vueTag start=/^<style.*>$/ end='</style>' contains=@SASS keepend
      \ | syntax match htmlArg /v-text\|v-html\|v-if\|v-show\|v-else\|v-for\|v-on\|v-bind\|v-model\|v-pre\|v-cloak\|v-once/ contained
      \ | syntax keyword htmlArg contained key ref slot
      \ | syntax keyword htmlTagName contained component transition transition-group keep-alive slot
      \ | syntax sync fromstart
highlight vueTag ctermfg=Blue


" vi:et:sw=2:ts=2:sts=2
