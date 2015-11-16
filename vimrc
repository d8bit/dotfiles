set nocompatible              " be iMproved, required
filetype off                  " required
syntax enable
colorscheme monokai
" tab to spaces
set tabstop=4 shiftwidth=4 expandtab
set autoindent
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
" split options
set splitbelow
set splitright
" remove esc delay to return to visual mode quickly
set timeoutlen=1000 ttimeoutlen=0
" set font for mvim
set guifont=Meslo\ LG\ M\ for\ Powerline:h12

" save temp files in a different path
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
" map <Leader>e :!xmodmap ~/.speedswapper<CR>

map <Leader>t :!ctags --languages=PHP -R .<CR>
map <Leader>c :SyntasticCheck phpcs<CR>
map <Leader>m :SyntasticCheck phpmd<CR>

" hide php variables on Tagbar
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

" show line numbers on NerdTree
let NERDTreeShowLineNumbers=1

" move lines with Control key
let g:move_key_modifier = 'C'

" stop at breakpoints on debugging
" let g:dbgPavimBreakAtEntry = 1

" Ctrlp options
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_match_window = 'max:20,results:20'

" Syntastic options
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_php_checkers = ['php', 'phpmd'] " removed phpcs and phpmd to execute manually
let g:syntastic_aggregate_errors = 1

" PHPDOC config
let g:pdv_template_dir = $HOME ."/.vim/bundle/pdv/templates_snip"
nnoremap <buffer> <C-b> :call pdv#DocumentWithSnip()<CR>

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsSnippetsDir="~/.vim/bundle/vim-snippets/UltiSnips"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" Do not open split window with doc when using Omnicompletion
set completeopt-=preview

" BUNDLE
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

" plugins for snippets
Plugin 'https://github.com/SirVer/ultisnips.git'
Plugin 'honza/vim-snippets'

" comment lines with gcc command
Plugin 'https://github.com/tomtom/tcomment_vim.git'

" match tags with %
Plugin 'https://github.com/tmhedberg/matchit.git'

" surround text objects
Plugin 'https://github.com/tpope/vim-surround.git'

" move line with ctrl[j,k]
Plugin 'https://github.com/matze/vim-move.git'

" repeat commands with '.' for surround plugin (among others)
Plugin 'https://github.com/tpope/vim-repeat.git'

" silver searcher
Plugin 'https://github.com/rking/ag.vim.git'

" debuger
" plugin 'https://github.com/joonty/vdebug.git'

" hightlight html tags
Plugin 'https://github.com/gregsexton/MatchTag.git'

" code linter
Plugin 'https://github.com/scrooloose/syntastic.git'

" auto-close
Plugin 'https://github.com/jiangmiao/auto-pairs.git'

" generate phpdoc
Plugin 'https://github.com/tobyS/pdv.git'
Plugin 'https://github.com/tobyS/vmustache.git' " phpdoc dependency

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
:
