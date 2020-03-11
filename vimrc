" #########################################################################
" language

lang en_US
set encoding=utf-8
" #########################################################################
" minpac

packadd minpac

call minpac#init()

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

" Add other plugins here.
call minpac#add('HerringtonDarkholme/yats.vim')
call minpac#add('MaxMEllon/vim-jsx-pretty')
call minpac#add('Quramy/tsuquyomi')
call minpac#add('Valloric/YouCompleteMe')
call minpac#add('airblade/vim-gitgutter')
call minpac#add('burnettk/vim-angular')
call minpac#add('digitaltoad/vim-pug')
call minpac#add('gkz/vim-ls')
call minpac#add('isRuslan/vim-es6')
call minpac#add('jparise/vim-graphql')
call minpac#add('klen/python-mode')
call minpac#add('leafgarland/typescript-vim')
call minpac#add('mkitt/tabline.vim')
call minpac#add('nathanaelkane/vim-indent-guides')
call minpac#add('ntpeters/vim-better-whitespace')
call minpac#add('othree/yajs.vim')
call minpac#add('posva/vim-vue')
call minpac#add('styled-components/vim-styled-components')
call minpac#add('tpope/vim-git')
call minpac#add('tpope/vim-haml')
call minpac#add('vim-jp/syntax-vim-ex')
call minpac#add('vim-syntastic/syntastic')
call minpac#add('wavded/vim-stylus')

" Load the plugins right now. (optional)
packloadall

hi link stylusProperty cssVisualProp

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
" default vimrc files

if filereadable($VIMRUNTIME . "/vimrc_example.vim")
  so $VIMRUNTIME/vimrc_example.vim
endif
if filereadable($VIMRUNTIME . "/macros/matchit.vim")
  so $VIMRUNTIME/macros/matchit.vim
endif

" #########################################################################
" settings

syntax on
set backup		" keep a backup file
set backupcopy=yes " for brunch
set backupdir=~/tmp,.,/var/tmp/vi,/tmp
set bs=2		" allow backspacing over everything in insert mode
set directory=~/tmp,/var/tmp/vi,/tmp,.
set incsearch " immediate search
set modelines=1 " enable modeline
set mouse=c " disable mouse
set noai			" always set autoindenting on
set nocompatible " nocompatible with vi
set noexpandtab
set nosmartindent
set nowrap
set redrawtime=10000
set ruler " show current line and column position
set shiftwidth=4
set showmatch " show the match { ( <
set spell
set spellfile=$HOME/Cloud/MEGAsync/vim/spell/en.utf-8.add
set spelllang=en
set tabstop=4
set undodir=~/tmp
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
set wildignore+=*.a,*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=*.map
set wildignore+=*~,*.swp,*.tmp
set wildignore+=.DS_Store,.git,.hg,.svn
set wildmenu " completion menu at command mode

" VIM 6.0, We're using VIM on ntucs? Solaris, my own build
if version >= 600
  set encoding=utf-8
  set fileencodings=utf-8,big5,ucs-bom,latin1
  set foldlevel=1
  set foldmethod=marker " no auto folding
  set nohlsearch " no highlight search
  set termencoding=utf-8
else
  set fileencoding=taiwan
endif

" settings based on filetype
au BufNewFile,BufRead *.jade,*.json,*.js,*.styl,*.pug,*.ls,*.sass,*.html,*.ts,*.yml,*.yaml setl softtabstop=2 shiftwidth=2 expandtab
au BufNewFile,BufRead *.less set filetype=less
au BufNewFile,BufRead *.py setl softtabstop=4 shiftwidth=4 expandtab fdm=marker

" #########################################################################
" key mapping

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

" Sort hot key
xnoremap <silent> s :sort<CR>
xnoremap <silent> S :sort!<CR>

" faster up down
map <C-UP> 5gk
map <C-DOWN> 5gj

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

" #########################################################################
" color

" comment color
hi Comment ctermfg = LightMagenta
" Pmenu color
hi Pmenu ctermfg = white

" #########################################################################
" command

function Nanoha()
  :1read !head ~/nanoha
  :1
  :join 1
endfunction

" special command
command Na exec Nanoha()
command Nanoha exec Nanoha()
command P set paste
command NP set nopaste

" #########################################################################
" paste in tmux

function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" #########################################################################
" plugin options

" python_mode options
let g:pymode_python = 'python3'
let g:pymode_lint_ignore = ['E501', 'W601', 'W391'] " ignore line length error
let g:pep8_ignore = 'E501,W601' " ignore line length error
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion = 0
let g:pymode_lint_on_write = 1

" vim-indent-guides
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=5
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=3
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
IndentGuidesEnable

" typescript
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" YouComplateMe
if !exists("g:ycm_semantic_triggers")
  let g:ycm_semantic_triggers = {}
endif
" let g:ycm_semantic_triggers['typescript'] = ['re!\w*[^"]+.']
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_max_diagnostics_to_display = 30
let g:ycm_auto_trigger = 1
let g:ycm_max_num_candidates = 50
let g:ycm_filetype_whitelist = {"*": 1}
let g:ycm_filetype_blacklist = {
      \ 'tagbar': 1,
      \ 'notes': 1,
      \ 'markdown': 1,
      \ 'netrw': 1,
      \ 'unite': 1,
      \ 'text': 1,
      \ 'vimwiki': 1,
      \ 'pandoc': 1,
      \ 'infolog': 1,
      \ 'mail': 1
      \}
let g:ycm_filter_diagnostics = {}
let g:ycm_filetype_specific_completion_to_disable = {
      \ 'gitcommit': 1
      \}
let g:ycm_complete_in_comments = 0
let ycm_disable_signature_help = 1
set completeopt-=preview

" syntastic
set laststatus=2
set statusline=%f\ %h%w%m%r\ 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi']
let g:syntastic_python_checkers=['pylint']
let g:syntastic_python_pylint_args = '-d R0903,E1101,E501,W601,C0301'

" vue
autocmd BufNewFile,BufEnter *.vue setfiletype vue
autocmd FileType vue setlocal autoindent expandtab shiftwidth=2 softtabstop=2 commentstring=//\ %s comments=://
      \ | syntax include @PUG syntax/pug.vim | unlet b:current_syntax
      \ | syntax include @JS syntax/javascript.vim | unlet b:current_syntax
      \ | syntax include @SASS syntax/stylus.vim | unlet b:current_syntax
      \ | syntax region vueTemplate matchgroup=vueTag start=/^<template.*>$/ end='</template>' contains=@PUG keepend
      \ | syntax region vueScript matchgroup=vueTag start=/^<script.*>$/ end='</script>' contains=@JS keepend
      \ | syntax region vueStyle matchgroup=vueTag start=/^<style.*>$/ end='</style>' contains=@SASS keepend
      \ | syntax match htmlArg /v-text\|v-html\|v-if\|v-show\|v-else\|v-for\|v-on\|v-bind\|v-model\|v-pre\|v-cloak\|v-once/ contained
      \ | syntax keyword htmlArg contained key ref slot
      \ | syntax keyword htmlTagName contained component transition transition-group keep-alive slot
      \ | syntax sync fromstart
highlight vueTag ctermfg=Blue

" vim-jsx-pretty
highlight link jsxTagName Statement
highlight link jsxPunct Function
highlight link jsxCloseString jsxTag

" yajs
highlight link javascriptImport Special
highlight link javascriptExport Special

" vi:et:sw=2:ts=2:sts=2
