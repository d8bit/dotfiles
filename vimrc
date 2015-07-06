syntax enable
colorscheme monokai
set tabstop=4
set shiftwidth=4
set smarttab
set mouse=a
set cursorline
set relativenumber
set number
set nocompatible              " be iMproved, required
filetype off                  " required

"save temp files in other path
set dir=~/.vimswap//,/var/tmp//,/tmp//

"airline (status bar)
let g:airline_powerline_fonts = 1
set laststatus=2

"shortcuts
map <F2> :NERDTreeToggle<CR>
nmap <F3> :TagbarToggle<CR>

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

"multicursor shortcuts
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

"tabgar autofocus
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1

"move lines with control key
let g:move_key_modifier = 'C'

" Show code coverage on load (default = 0)
let g:phpqa_codecoverage_autorun = 1

" Don't run messdetector on save (default = 1)
let g:phpqa_messdetector_autorun = 0

" Don't run codesniffer on save (default = 1)
let g:phpqa_codesniffer_autorun = 0


"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')


" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'https://github.com/kien/ctrlp.vim.git'
Plugin 'https://github.com/scrooloose/nerdtree.git'
Plugin 'https://github.com/Xuyuanp/nerdtree-git-plugin.git'
Plugin 'airblade/vim-gitgutter'
Plugin 'mattn/emmet-vim'
Plugin 'https://github.com/terryma/vim-multiple-cursors.git'
Plugin 'https://github.com/tpope/vim-fugitive.git'
Plugin 'https://github.com/majutsushi/tagbar.git'
Plugin 'https://github.com/bling/vim-airline.git'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'https://github.com/tomtom/tcomment_vim.git'
Plugin 'https://github.com/tmhedberg/matchit.git'
Plugin 'https://github.com/tpope/vim-surround.git'
Plugin 'easymotion/vim-easymotion'
Plugin 'https://github.com/matze/vim-move.git'
Plugin 'https://github.com/Raimondi/delimitMate.git'
Plugin 'https://github.com/joonty/vim-phpqa.git'
Plugin 'https://github.com/tpope/vim-repeat.git'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
:
