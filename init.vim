" my config
set mouse=a
syntax enable
set background=dark
colorscheme monokai
" tab to spaces
set tabstop=4 shiftwidth=4 expandtab
" set autoindent
set cursorline
set relativenumber
set number
" incremental search
set incsearch
" show commands
set showcmd
" split options
set splitbelow
set splitright
" save temp files in a different path
set dir=~/.vimswap//,/var/tmp//,/tmp//
" show column 121
set colorcolumn=121
" show tabs
set list
set listchars=tab:▸\ 
" autosave and autoload views to save codefoldings
" source ~/vim/views.vim


"shortcuts
map <Leader>1 <plug>NERDTreeTabsToggle<CR>
nmap <Leader>2 :TagbarToggle<CR>
" map <F2> :lopen<CR>
" map <F3> :lclose<CR>
map <tab> za<CR>

" run script to make blockmayus = esc
" map <Leader>e :!xmodmap ~/.speedswapper<CR>

map <Leader>t :!ctags -R --fields=+aS --languages=php .<CR>
" map <Leader>c :SyntasticCheck phpcs<CR>
" map <Leader>m :SyntasticCheck phpmd<CR>

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
let NERDTreeShowLineNumbers=1

" move lines with Control key
let g:move_key_modifier = 'C'

" stop at breakpoints on debugging
let g:dbgPavimBreakAtEntry = 1
" Xdebug config
let g:vdebug_options= {
    \    "port" : 9999,
    \    "server" : '',
    \    "timeout" : 20,
    \    "on_close" : 'detach',
    \    "break_on_open" : 1,
    \    "ide_key" : '',
    \    "path_maps" : {},
    \    "debug_window_level" : 0,
    \    "debug_file_level" : 0,
    \    "debug_file" : "",
    \    "watch_window_style" : 'expanded',
    \    "marker_default" : '⬦',
    \    "marker_closed_tree" : '▸',
    \    "marker_open_tree" : '▾'
    \}

" Ctrlp options
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_by_filename = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 1
let g:ctrlp_regexp = 1

" PHPDOC config
map <Leader>d :call PhpDoc()<CR>

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsSnippetsDir="~/.config/bundle/vim-snippets/UltiSnips"
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetsDir="~/.config/bundle/vim-snippets/UltiSnips"

" do not open split window with doc when using Omnicompletion
set completeopt-=preview

" execute Neomake on save
autocmd! BufWritePost * Neomake
let g:neomake_php_enabled_makers = ['phpmd', 'php']
let g:neomake_javascript_enabled_makers = ['jshint']
" do not open error list automatically
let g:neomake_open_list = 0

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
" powerline theme
let g:airline_theme='powerlineish'


" use namespace plugin with <leader>e
function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
autocmd FileType php inoremap <Leader>e <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>e :call PhpExpandClass()<CR>

" typescript options
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi'] " You shouldn't use 'tsc' checker.

" end my config


" Note: Skip initialization for vim-tiny or vim-small.
 if 0 | endif

 if has('vim_starting')
   if &compatible
     set nocompatible               " Be iMproved
   endif

   " Required:
   set runtimepath+=~/.config/nvim/bundle/neobundle.vim/
 endif


 " Required:
 call neobundle#begin(expand('~/.config/nvim/bundle/'))

 " Let NeoBundle manage NeoBundle
 " Required:
 NeoBundleFetch 'Shougo/neobundle.vim'

 " My Bundles here:
 " Refer to |:NeoBundle-examples|.
 " Note: You don't set neobundle setting in .gvimrc!

" Async plugin
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }

" Search files
" NeoBundle 'https://github.com/kien/ctrlp.vim.git'
NeoBundle 'https://github.com/ctrlpvim/ctrlp.vim'

" File tree
NeoBundle 'https://github.com/scrooloose/nerdtree.git'

" git integration. Show git info on nerdtree
" NeoBundle 'https://github.com/Xuyuanp/nerdtree-git-plugin.git'

" git integration. Shows line state on margin.
NeoBundle 'airblade/vim-gitgutter'

" git integration. Git commands.
NeoBundle 'https://github.com/tpope/vim-fugitive.git'

" emmet plugin for html
NeoBundle 'mattn/emmet-vim'

" multiple cursors
NeoBundle 'https://github.com/terryma/vim-multiple-cursors.git'

" show functions and vars on current file
NeoBundle 'https://github.com/majutsushi/tagbar.git'

" plugins for snippets
NeoBundle 'https://github.com/SirVer/ultisnips.git'
NeoBundle 'honza/vim-snippets'

" comment lines with gcc command
NeoBundle 'https://github.com/tomtom/tcomment_vim.git'

" match tags with %
NeoBundle 'https://github.com/tmhedberg/matchit.git'

" surround text objects
NeoBundle 'https://github.com/tpope/vim-surround.git'

" move line with ctrl[j,k]
NeoBundle 'https://github.com/matze/vim-move.git'

" repeat commands with '.' for surround plugin (among others)
NeoBundle 'https://github.com/tpope/vim-repeat.git'

" silver searcher
NeoBundle 'https://github.com/rking/ag.vim.git'

" debuger
NeoBundle 'https://github.com/joonty/vdebug.git'

" hightlight html tags
NeoBundle 'https://github.com/gregsexton/MatchTag.git'

" code linter
"NeoBundle 'https://github.com/scrooloose/syntastic.git'

" auto-close
NeoBundle 'https://github.com/jiangmiao/auto-pairs.git'

" airline
NeoBundle 'bling/vim-airline'
" airline themes
NeoBundle 'vim-airline/vim-airline-themes'

" tmux airline
NeoBundle 'edkolev/tmuxline.vim'

" codelinter
NeoBundle 'benekastah/neomake'

" generate phpdoc
NeoBundle 'vexxor/phpdoc.vim'

" nerdtree icons
NeoBundle 'ryanoasis/vim-devicons'

" manage namespaces
NeoBundle 'arnaud-lb/vim-php-namespace'

" refactor tool
NeoBundle 'adoy/vim-php-refactoring-toolbox'

" show always nerdtree
NeoBundle 'jistr/vim-nerdtree-tabs'

" blade template
NeoBundle 'jwalton512/vim-blade'

" youcompleteme
" NeoBundle 'Valloric/YouCompleteMe'

" type script
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'Quramy/tsuquyomi'

" tern for javascript
NeoBundle 'ternjs/tern_for_vim'

" php man
NeoBundle 'alvan/vim-php-manual'

" show whitespaces
NeoBundle 'ntpeters/vim-better-whitespace'

" tabular plugin to format text
NeoBundle 'godlygeek/tabular'

call neobundle#end()

 " Required:
 filetype plugin indent on

 " If there are uninstalled bundles found on startup,
 " this will conveniently prompt you to install them.
 NeoBundleCheck
