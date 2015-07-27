set nocompatible              " be iMproved, required
filetype off                  " required
syntax enable
colorscheme monokai
set tabstop=4
set shiftwidth=4
set smarttab
" enable mouse
set mouse=a
" hightlight current line
set cursorline
set relativenumber
set number
" incremental search
set incsearch
" hightlight search
set hlsearch
" show commands
set showcmd

" save temp files in different path
set dir=~/.vimswap//,/var/tmp//,/tmp//

" powerline (installed with pip)
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
set laststatus=2

"shortcuts
map <Leader>1 :NERDTreeToggle<CR>
nmap <Leader>2 :TagbarToggle<CR>
" run script to make blockmayus = esc
map <Leader>e :!xmodmap ~/.speedswapper<CR>
map <Leader>c :!ctags-exuberant .<CR>

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

" multicursor shortcuts
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" tabgar autofocus and close on select
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_show_linenumbers = 2

" close Nerdtree on open
let NERDTreeQuitOnOpen = 1

" move lines with Control key
let g:move_key_modifier = 'C'

" show code coverage on load (default = 0)
" let g:phpqa_codecoverage_autorun = 1

" don't run messdetector on save (default = 1)
" let g:phpqa_messdetector_autorun = 0

" don't run codesniffer on save (default = 1)
" let g:phpqa_codesniffer_autorun = 0

" stop at breakpoints on debugging
" let g:dbgPavimBreakAtEntry = 1

" Ctrlp options
let g:ctrlp_working_path_mode = 'c'
let g:ctrlp_by_filename = 1
set wildignore+=*/tmp/*,*/plugins/*,*/vendor/*,*/storage/*,*/demo/*,*/plantillas/*

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')


" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Search files
Plugin 'https://github.com/kien/ctrlp.vim.git'
" File tree
Plugin 'https://github.com/scrooloose/nerdtree.git'
" git integration. Show git info on nerdtree
Plugin 'https://github.com/Xuyuanp/nerdtree-git-plugin.git'
" git integration. Shows line state on margin.
Plugin 'airblade/vim-gitgutter'
" git integration. Git commands.
Plugin 'https://github.com/tpope/vim-fugitive.git'
" emmet plugin for html
Plugin 'mattn/emmet-vim'
" multiple cursors
Plugin 'https://github.com/terryma/vim-multiple-cursors.git'
" show functions and vars on current file
Plugin 'https://github.com/majutsushi/tagbar.git'
" plugin for snippets
Plugin 'tomtom/tlib_vim' " snipmate dependecy
Plugin 'MarcWeber/vim-addon-mw-utils' " snipmate dependecy
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'https://github.com/bonsaiben/bootstrap-snippets.git'
" comment lines with gcc command
Plugin 'https://github.com/tomtom/tcomment_vim.git'
" match tags with %
Plugin 'https://github.com/tmhedberg/matchit.git'
" Surround text objects
Plugin 'https://github.com/tpope/vim-surround.git'
" Move in a file with <leader> <leader> w
Plugin 'easymotion/vim-easymotion'
" Move line with ctrl[j,k]
Plugin 'https://github.com/matze/vim-move.git'
" PHP integration
" Plugin 'https://github.com/joonty/vim-phpqa.git'
" Repeat commands with '.' for surround plugin (among others)
Plugin 'https://github.com/tpope/vim-repeat.git'
" Silver searcher
Plugin 'https://github.com/rking/ag.vim.git'
" Debuger
" Plugin 'https://github.com/joonty/vdebug.git'
" Hightlight html tags
Plugin 'https://github.com/gregsexton/MatchTag.git'
" Linters
Plugin 'https://github.com/scrooloose/syntastic.git'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
:
