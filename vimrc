set nocompatible              " be iMproved, required
filetype off                  " required
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
" hightlight column 121
set colorcolumn=121
" show tabs
set list
set listchars=tab:▸\ 

" to start airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
" powerline theme
let g:airline_theme='powerlineish'

"shortcuts
map <Leader>1 <plug>NERDTreeTabsToggle<CR>
nmap <Leader>2 :TagbarToggle<CR>

" run script to make blockmayus = esc
" map <Leader>e :!xmodmap ~/.speedswapper<CR>

" exhuberant-ctags
" map <Leader>t :!ctags --languages=PHP -R .<CR>
" patched exhuberant-ctags with PHP namespaces
map <Leader>t :!ctags -R --fields=+aS --languages=php .<CR>
" codesniffer
map <Leader>c :SyntasticCheck phpcs<CR>
" mess detector
map <Leader>m :SyntasticCheck phpmd<CR>
" deadcode detector
map <Leader>n :SyntasticCheck phpdcd<CR>

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
" let NERDTreeQuitOnOpen = 1

" show line numbers on NerdTree
let NERDTreeShowLineNumbers = 1
let NERDTreeShowHidden = 1

" move lines with Control key
let g:move_key_modifier = 'C'

" stop at breakpoints on debugging
" let g:dbgPavimBreakAtEntry = 1

" Ctrlp options
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_by_filename = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 1
let g:ctrlp_regexp = 1

" Syntastic options
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_php_checkers = ['php', 'phpmd', 'phpdcd']
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_aggregate_errors = 1

" PHPDOC config
map <Leader>d :call PhpDoc()<CR>

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" Execute 'UltiSnipsAddFiletypes php' if necessary
let g:UltiSnipsSnippetsDir="~/.vim/bundle/vim-snippets/UltiSnips"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"

" Do not open split window with doc when using Omnicompletion
set completeopt-=preview

" use namespace plugin with <leader>e
function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
autocmd FileType php inoremap <Leader>e <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>e :call PhpExpandClass()<CR>

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

" File tree (nerdtree)
Plugin 'https://github.com/scrooloose/nerdtree.git'
" nerdtree on all tabs
Bundle 'jistr/vim-nerdtree-tabs'

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
Bundle 'vexxor/phpdoc.vim'

" autocomplete namespaces
Bundle 'arnaud-lb/vim-php-namespace'

" refactor tool
Plugin 'adoy/vim-php-refactoring-toolbox'

" airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" tmux airline
Bundle 'edkolev/tmuxline.vim'

" blade syntax
Plugin 'jwalton512/vim-blade'

" php complete
Plugin 'shawncplus/phpcomplete.vim'

" youCompleteMe
" Plugin 'Valloric/YouCompleteMe'

" show whitespaces at the end of the lines
Plugin 'ntpeters/vim-better-whitespace'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
syntax enable
:
