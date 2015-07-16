set nocompatible              " be iMproved, required
filetype off                  " required
syntax enable
colorscheme monokai
set tabstop=4
set shiftwidth=4
set smarttab
set mouse=a
set cursorline
set relativenumber
set number
set incsearch
set hlsearch
set showcmd

"save temp files in other path
set dir=~/.vimswap//,/var/tmp//,/tmp//

"airline (status bar)
let g:airline_powerline_fonts = 1
set laststatus=2

"shortcuts
map <Leader>1 :NERDTreeToggle<CR>
nmap <Leader>2 :TagbarToggle<CR>
map <Leader>e :!xmodmap ~/.speedswapper<CR>
map <Leader>c :!ctags-exhuberat .<CR>

"hide php variables on Tagbar
let g:tagbar_type_php  = {
  \ 'ctagstype' : 'php',
  \ 'kinds'     : [
	  \ 'i:interfaces',
	  \ 'c:classes',
	  \ 'd:constant definitions',
	  \ 'f:functions',
	  \ 'j:javascript functions:1'
  \ ]
\ }

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

"multicursor shortcuts
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

"tabgar autofocus and close on select
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1

"move lines with Control key
let g:move_key_modifier = 'C'

" Show code coverage on load (default = 0)
let g:phpqa_codecoverage_autorun = 1

" Don't run messdetector on save (default = 1)
let g:phpqa_messdetector_autorun = 0

" Don't run codesniffer on save (default = 1)
let g:phpqa_codesniffer_autorun = 0

" Stop at breakpoints on debugging
" let g:dbgPavimBreakAtEntry = 1


"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')


" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" Search files
Plugin 'https://github.com/kien/ctrlp.vim.git'
" File tree
Plugin 'https://github.com/scrooloose/nerdtree.git'
" Show git info on nerdtree
Plugin 'https://github.com/Xuyuanp/nerdtree-git-plugin.git'
Plugin 'airblade/vim-gitgutter'
" Emmet plugin for html
Plugin 'mattn/emmet-vim'
" Multiple cursors
Plugin 'https://github.com/terryma/vim-multiple-cursors.git'
Plugin 'https://github.com/tpope/vim-fugitive.git'
" Show functions and vars on current file
Plugin 'https://github.com/majutsushi/tagbar.git'
" Bar info
Plugin 'https://github.com/bling/vim-airline.git'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
" Plugin for snippets
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'https://github.com/bonsaiben/bootstrap-snippets.git'
" Comment lines
Plugin 'https://github.com/tomtom/tcomment_vim.git'
" Match tags with %
Plugin 'https://github.com/tmhedberg/matchit.git'
Plugin 'https://github.com/tpope/vim-surround.git'
Plugin 'easymotion/vim-easymotion'
Plugin 'https://github.com/matze/vim-move.git'
"Plugin 'https://github.com/jiangmiao/auto-pairs.git'
Plugin 'https://github.com/joonty/vim-phpqa.git'
Plugin 'https://github.com/tpope/vim-repeat.git'
" Silver searcher
Plugin 'https://github.com/rking/ag.vim.git'
" Debuger
Plugin 'https://github.com/joonty/vdebug.git'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
:
