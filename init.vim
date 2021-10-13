" set background=dark
" performance options
" set ttyfast
" set lazyredraw
" enable mouse
set mouse=a
" set termguicolors
" if &term =~# '^screen'
"     let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"     let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" endif
" colorscheme srcery
colorscheme gruvbox
" tab to spaces
set tabstop=4 shiftwidth=4 expandtab
" tab format
autocmd Filetype eruby setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype yml setlocal ts=2 sts=2 sw=2
autocmd Filetype yaml setlocal ts=2 sts=2 sw=2
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype blade setlocal ts=2 sts=2 sw=2
autocmd Filetype json setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript.jsx setlocal ts=2 sts=2 sw=2

autocmd BufNewFile,BufRead *.hcl set ft=terraform
autocmd BufNewFile,BufRead *.DockerFile set ft=dockerfile
autocmd BufNewFile,BufRead *.es.conf set ft=nginx

augroup filetypedetect
au BufNewFile,BufRead *.xt  setf xt
augroup END

" allow to use backspace always in insert mode
set backspace=indent,eol,start
set autoindent
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
" split options: create splits below and right by default
set splitbelow
set splitright
" remove esc delay to return to visual mode quickly
set timeoutlen=1000 ttimeoutlen=0
" set font for mvim
set guifont=Meslo\ LG\ M\ for\ Powerline:h12
" do not save swap and tmp files
set noswapfile
set nobackup
set nowritebackup
" hightlight column 81
set colorcolumn=81
" show tabs
" set nolist " hide special characters
set list
set listchars=tab:▸\ 
" show autocomplete options on bottom bar
set wildmenu
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" set omnifunc=syntaxcomplete#Complete
autocmd FileType php setlocal omnifunc=phpactor#Complete
" Do not open split window with doc when using Omnicompletion
set completeopt-=preview

" show buffer numbers
" let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" autosave and autoload views to save codefoldings
" source ~/dotfiles/views.vim
" Function to close all buffers except the current one
source ~/dotfiles/buffers.vim
" source ~/dotfiles/coc.vim

if has("persistent_undo")
    set undodir=/tmp/
    set undofile
endif

" tree view
let g:netrw_liststyle = 3

" fit quickfix height
" au FileType qf call AdjustWindowHeight(1, 3)
" function! AdjustWindowHeight(minheight, maxheight)
"     let l = 1
"     let n_lines = 0
"     let w_width = winwidth(0)
"     while l <= line('$')
"         " number to float for division
"         let l_len = strlen(getline(l)) + 0.0
"         let line_width = l_len/w_width
"         let n_lines += float2nr(ceil(line_width))
"         let l += 1
"     endw
"     exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
" endfunction

" open quickfix results in a new tab
set switchbuf+=usetab,newtab

" ----------------------------------------------------------------------------
"
"                              Codelinters config
"
" ----------------------------------------------------------------------------

let g:ycm_python_interpreter_path = '/usr/bin/python3'
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ale_python_pylint_executable = 'pylint'

let g:ale_linters = {
\   'php': ['phpcs', 'phpmd', 'php'],
\   'python': ['pylint'],
\   'tex': ['chktex'],
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\   'html': ['htmlhint'],
\   'typescript': ['tsuquyomi'],
\}
let g:phpcs_max_output=50
let g:ale_sign_error = 'x'
let g:ale_sign_warning = '⚠'
let g:ale_open_list = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_php_phpcs_standard = "PSR12"
let g:ale_echo_cursor = 1
let g:ale_lint_on_enter = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

nnoremap <leader>a :ALEDetail<cr>

let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" ----------------------------------------------------------------------------
"
"                                   Eyecandy
"
" ----------------------------------------------------------------------------

" to start airline
set laststatus=2

"""""" End Eye candy """"""

" ----------------------------------------------------------------------------
"
"                                   Shortcuts
"
" ----------------------------------------------------------------------------
"
" nerdtree
map <Leader>1 <plug>NERDTreeTabsToggle<CR>
" nmap <Leader>1 :CocCommand explorer<CR>

" tagbar
nmap <Leader>2 :TagbarToggle<CR>
" fzf files
map <C-p> :Files<CR>
" multicursor shortcuts
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'
" move lines with Control key
let g:move_key_modifier = 'C'
" move parameters
map <S-h> :SidewaysLeft<CR>
map <S-l> :SidewaysRight<CR>
" PHPDOC config
map <Leader>d :call PhpDoc()<CR>
" JSDOC config
map <Leader>j :JsDoc<CR>
" ultisnips
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"
" use namespace plugin with <leader>e
autocmd FileType php inoremap <Leader>e <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>e :call PhpExpandClass()<CR>
" phpmanual
let g:php_manual_online_search_shortcut = '<F1>'

" undotree
nnoremap <leader>u :UndotreeToggle<cr>

" Close remaining buffers
nnoremap <F2> :Buffo<cr>
nnoremap <F3> :noh<cr>
nnoremap <F4> :ALEDisable<cr>

" Navigate through buffers
nnoremap <tab> :bn<cr>
nnoremap <S-tab> :bp<cr>


" User Alt-] to execute PhpactorGotoDefinition
nnoremap <A-]> :PhpactorGotoDefinition<cr>
nnoremap <C-LeftMouse> :PhpactorGotoDefinition<cr>
nnoremap <A-F12> :PhpactorFindReferences<cr>

" show in nerdtree the current file
command Show NERDTreeFind

" remove blank spaces

" format json
command JsonBeautify %!python -m json.tool
command XMLBeautify %!xmllint --format %
" run script to make blockmayus = esc
" map <Leader>e :!xmodmap ~/.speedswapper<CR>

set wildignore+=vendor/**,node_modules/**
" command Todo noautocmd vimgrep /TODO\|FIXME\|XXX/j ** | cw
command Todo noautocmd Ack //.TODO|//.FIXME|//.XXX
command JS set filetype=javascript
command PHP set filetype=php
command HTML set filetype=html

" Fzf for buffers
nnoremap <C-space> :Buffers<CR>

" spell check
nnoremap <leader>c :set spell<cr> :highlight SpellBad ctermfg=red<cr>
nnoremap <leader>C :set nospell<cr>

" ----------------------------------------------------------------------------
"
"                                    Configs
"
" ----------------------------------------------------------------------------

" close quickfix on close window
aug QFClose
    au!
    au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END

" do not jump on autopairs
let g:AutoPairsMultilineClose = 0
" typescript options
let g:tsuquyomi_disable_quickfix = 1
" Tagbar
" " hide php variables on tagbar
" let g:tagbar_type_php  = {
"   \ 'ctagstype' : 'php',
"   \ 'kinds'     : [
"           \ 'i:interfaces',
"           \ 'c:classes',
"           \ 'd:constant definitions',
"           \ 'f:functions',
"           \ 'j:javascript functions:1'
"   \ ]
" \ }
" tabgar autofocus and close on select
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_show_linenumbers = 2

" RipGrep
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

if executable('rg')
  " Use rg over grep
  set grepprg=rg\ --vimgrep
endif

" Nerdtree
" show line numbers on NerdTree
let NERDTreeShowLineNumbers = 1
let NERDTreeShowHidden = 1
" xdebug
" stop at breakpoints on debugging
let g:dbgPavimBreakAtEntry = 1
" Xdebug config
let g:vdebug_keymap = {
    \    "run" : "<F5>",
    \    "run_to_cursor" : "<F9>",
    \    "step_over" : "<F8>",
    \    "step_into" : "<F7>",
    \    "step_out" : "<F4>",
    \    "close" : "<F6>",
    \    "detach" : "",
    \    "set_breakpoint" : "<F10>",
    \    "get_context" : "<F11>",
    \    "eval_under_cursor" : "<F12>",
    \    "eval_visual" : "<Leader>e",
    \}

let g:vdebug_options= {
    \    "port" : 9000,
    \    "server" : '172.20.0.1',
    \    "timeout" : 20,
    \    "on_close" : 'detach',
    \    "break_on_open" : 0,
    \    "ide_key" : '',
    \    "path_maps" : {
    \        "/var/www/html/flip-webapp":"/home/david/dev/alterna/flip-webapp"
    \    },
    \    "debug_window_level" : 0,
    \    "debug_file_level" : 0,
    \    "debug_file" : "",
    \    "watch_window_style" : 'expanded',
    \    "marker_default" : '⬦',
    \    "marker_closed_tree" : '▸',
    \    "marker_open_tree" : '▾'
    \}

" ultisnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" Execute 'UltiSnipsAddFiletypes php' if necessary
let g:UltiSnipsSnippetsDir="~/.vim/plugged/vim-snippets/UltiSnips"
" namespace
function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
" fzf options
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'

" " Guttentags config
"
" " enable universal ctags module
" let g:gutentags_modules = ['ctags', 'gtags_cscope']
"
" " config project root markers.
" let g:gutentags_project_root = ['.git', '.root']
"
" " generate datebases in my cache directory, prevent gtags files polluting my project
" let g:gutentags_cache_dir = expand('~/.cache/tags')
" let g:gutentags_generate_on_write=1
"
" " forbid gutentags adding gtags databases
" let g:gutentags_auto_add_gtags_cscope = 0
" let g:gutentags_trace = 0

" vim sessions
let g:session_autoload = 'no' " prompt
let g:session_autosave = 'no'

" vim autosave
let g:auto_save = 0

" GitGutter
let g:gitgutter_max_signs = 200  " default value

let g:tex_flavor = 'latex'

"end my config


" Note: Skip initialization for vim-tiny or vim-small.
 if 0 | endif

 if has('vim_starting')
   if &compatible
     set nocompatible               " Be iMproved
   endif

   " Required:
   set runtimepath+=~/.vim/bundle/neobundle.vim/
 endif


 " Required:
 call neobundle#begin(expand('~/.config/nvim/bundle/'))

 " Let NeoBundle manage NeoBundle
 " Required:
 NeoBundleFetch 'Shougo/neobundle.vim'

 " My Bundles here:
 " Refer to |:NeoBundle-examples|.
 " Note: You don't set neobundle setting in .gvimrc!

" file tree (nerdtree)
NeoBundle 'https://github.com/scrooloose/nerdtree.git'
" nerdtree on all tabs
NeoBundle 'jistr/vim-nerdtree-tabs'

" git integration. Show git info on nerdtree
NeoBundle 'https://github.com/Xuyuanp/nerdtree-git-plugin.git'

" git integration. Shows line state on margin.
NeoBundle 'airblade/vim-gitgutter'

" git integration. Git commands.
NeoBundle 'https://github.com/tpope/vim-fugitive.git'
NeoBundle 'junegunn/gv.vim'

" emmet plugin for html
NeoBundle 'mattn/emmet-vim'

" multiple cursors
NeoBundle 'https://github.com/terryma/vim-multiple-cursors.git'

" show functions and vars on current file
NeoBundle 'preservim/tagbar'
NeoBundle 'liuchengxu/vista.vim'

" plugins for snippets
NeoBundle 'SirVer/ultisnips'
NeoBundle 'honza/vim-snippets'

" comment lines with gcc command
NeoBundle 'tomtom/tcomment_vim'

" match tags with %
NeoBundle 'https://github.com/tmhedberg/matchit.git'

" surround text objects
NeoBundle 'https://github.com/tpope/vim-surround.git'

" move line with ctrl[j,k]
NeoBundle 'https://github.com/matze/vim-move.git'

" repeat commands with '.' for surround plugin (among others)
NeoBundle 'https://github.com/tpope/vim-repeat.git'

" debuger
NeoBundle 'https://github.com/vim-vdebug/vdebug'

" hightlight html tags
NeoBundle 'Valloric/MatchTagAlways'

" code linter
NeoBundle 'dense-analysis/ale'

" auto-close
NeoBundle 'https://github.com/jiangmiao/auto-pairs.git'

" generate phpdoc
NeoBundle 'sumpygump/php-documentor-vim'

" generate jsdoc
NeoBundle 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'javascript.jsx','typescript'],
  \ 'do': 'make install'
\}

" autocomplete namespaces
NeoBundle 'arnaud-lb/vim-php-namespace'

" refactor tool
NeoBundle 'adoy/vim-php-refactoring-toolbox'

" vim airline
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'

" blade syntax
NeoBundle 'jwalton512/vim-blade'

" php complete
NeoBundle 'shawncplus/phpcomplete.vim'

" tern for javascript
" NeoBundle 'ternjs/tern_for_vim'
NeoBundle 'pangloss/vim-javascript'
" reactjs (jsx)
NeoBundle 'mxw/vim-jsx'

" php man (Ctrl-h for online manual, Shift-k for vim explanation)
NeoBundle 'alvan/vim-php-manual'

" python doc
NeoBundle 'fs111/pydoc.vim'

" show whitespaces at the end of the lines
NeoBundle 'ntpeters/vim-better-whitespace'

" tabular plugin to format text
NeoBundle 'godlygeek/tabular'

" switch parameters
NeoBundle 'AndrewRadev/sideways.vim'

" twig hightlight
NeoBundle 'lumiliet/vim-twig'

" editorconfig
NeoBundle 'editorconfig/editorconfig-vim'

" fuzzy finder
NeoBundle 'junegunn/fzf'
NeoBundle 'junegunn/fzf.vim'

" typescript hightlight
NeoBundle 'leafgarland/typescript-vim'

" grep integration
" NeoBundle 'grep.vim'

" comments
NeoBundle 'jeanguyomarch/vim-metacomment'

" startify
" NeoBundle 'mhinz/vim-startify'

" undo tree
NeoBundle 'mbbill/undotree'

" VueJS
NeoBundle 'posva/vim-vue'

" show colors in code
NeoBundle 'ap/vim-css-color'

" Unit Testing
NeoBundle 'janko-m/vim-test'

" Camelcase motion
NeoBundle 'vim-scripts/camelcasemotion'

" Jenkinsfile syntax
NeoBundle 'martinda/Jenkinsfile-vim-syntax'

" Ferret
NeoBundle 'wincent/ferret'

" Generate ctags. Univsersal ctags needed
" NeoBundle 'ludovicchabant/vim-gutentags'
" NeoBundle 'skywind3000/gutentags_plus'
" NeoBundle 'jsfaint/gen_tags.vim'
" NeoBundle 'universal-ctags/ctags'

" Gnu Tags
" NeoBundle 'vim-scripts/gtags.vim'

" PHP
NeoBundle 'StanAngeloff/php.vim'

" Vim sessions
NeoBundle 'xolox/vim-session'
NeoBundle 'xolox/vim-misc'

" Latex for Vim
NeoBundle 'lervag/vimtex'

" Yaml
NeoBundle 'chase/vim-ansible-yaml'

" Vim eunuch
NeoBundle 'tpope/vim-eunuch'

" Typescript
NeoBundle 'quramy/tsuquyomi'

" Autocomplete like an IDE
" NeoBundle 'neoclide/coc.nvim', {'branch': 'release'}

" Autosave
NeoBundle '907th/vim-auto-save'

" Terraform
NeoBundle 'hashivim/vim-terraform'
NeoBundle 'juliosueiras/vim-terraform-completion'
NeoBundle 'yorinasub17/vim-terragrunt'

" Dockerfile
NeoBundle 'ekalinin/dockerfile.vim'

" Nginx
NeoBundle 'chr4/nginx.vim'

" PhpActor
NeoBundle 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}

" TabNine
" NeoBundle 'zxqfl/tabnine-vim'

" devicons
" NeoBundle 'ryanoasis/vim-devicons'

call neobundle#end()

 " Required:
 filetype plugin indent on

 " If there are uninstalled bundles found on startup,
 " this will conveniently prompt you to install them.
 NeoBundleCheck
