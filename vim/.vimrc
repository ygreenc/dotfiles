" vim: spell filetype=vim:
set nocompatible
filetype off

" Functions definition {{{
" Strip whitespace {{{
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" }}}

" Shell command {{{
function! s:RunShellCommand(cmdline)
    botright new

    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nowrap
    setlocal filetype=shell
    setlocal syntax=shell

    call setline(1, a:cmdline)
    call setline(2, substitute(a:cmdline, '.', '=', 'g'))
    execute 'silent $read !' . escape(a:cmdline, '%#')
    setlocal nomodifiable
    1
endfunction

command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
" }}}
" }}}

" Load user Pre-Configuration {{{
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif
" }}}

" Plugins {{{ 
" Requirements {{{ 
    set nocompatible
    set background=dark
" }}}

" Setup vim-plug {{{
    call plug#begin("~/.vim/bundle")
" }}}

" Bundle Dependencies

" Vim utility functions {{{
    Plug 'tomtom/tlib_vim'
    Plug 'MarcWeber/vim-addon-mw-utils'
" }}}

" ACK Bundle setup {{{
    if executable('ack')
        Plug 'mileszs/ack.vim'
    endif
" }}}
" Color schemes {{{
    Plug 'spf13/vim-colors'
    Plug 'flazz/vim-colorschemes'
" }}}

" Quote and tags (surroundings) {{{
" https://github.com/tpope/vim-surround
    Plug 'tpope/vim-surround'
" }}}

" Automatically close pair-characters {{{
" https://github.com/spf13/vim-autoclose
    Plug 'spf13/vim-autoclose'
    let g:autoclose_vim_commentmode=1 " Do not autoclose '"' in vimscript
" }}}

" Sublime-like Multiple selections {{{
" https://github.com/terryma/vim-multiple-cursors
    Plug 'kristijanhusak/vim-multiple-cursors'
" }}}

" Buffer list in statusline {{{
" https://github.com/bling/vim-bufferline
    Plug 'bling/vim-bufferline'
    let g:bufferline_active_buffer_left = ''
    let g:bufferline_active_buffer_right = ''
" }}}

" Lighline: Statusline-light {{{
" https://github.com/itchyny/lightline.vim
    Plug 'itchyny/lightline.vim'
    set laststatus=2

    let g:lightline = {
        \ 'active': {
        \   'left': [ [ 'mode', 'paste'], [ 'filename' ], [ 'bufferline' ], [ 'syntastic' ] ],
        \ },
        \ 'separator': { 'left': '', 'right': '' },
        \ 'subseparator': { 'left': '', 'right': '' },
        \ 'component': {
        \   'bufferline': '%{bufferline#refresh_status()}%{g:bufferline_status_info.before}%#TabLineSel#%{g:bufferline_status_info.current}%#LightLineLeft_active_3#%{g:bufferline_status_info.after}',
        \ },
        \ 'component_function': {
        \   'filename': 'LightLineFilename'
        \ },
        \ 'component_expand': {
        \   'syntastic': 'SyntasticStatuslineFlag',
        \ },
        \ 'component_type': {
        \   'syntastic': 'error',
        \ }
    \ }

    function! LightLineModified()
        return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
    endfunction

    function! LightLineReadonly()
        return &ft !~? 'help' && &readonly ? 'RO' : ''
    endfunction

    function! LightLineFilename()
      let fname = expand('%:t')
      return fname == 'ControlP' ? g:lightline.ctrlp_item :
            \ fname == '__Tagbar__' ? g:lightline.fname :
            \ fname =~ '__Gundo\|NERD_tree' ? '' :
            \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
            \ &ft == 'unite' ? unite#get_status_string() :
            \ &ft == 'vimshell' ? vimshell#get_status_string() :
            \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
            \ ('' != fname ? fname : '[No Name]') .
            \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
    endfunction
    let g:unite_force_overwrite_statusline = 0
" }}}

" EasyMotion, Vim motion with highlighting {{{
" https://github.com/Lokaltog/vim-easymotion
    Plug 'Lokaltog/vim-easymotion'
" }}}

" NERDCommenter: Comments helper {{{
" https://github.com/scrooloose/nerdcommenter
    Plug 'scrooloose/nerdcommenter'
" }}} 

" UndoTree {{{
" https://github.com/mbbill/undotree
    Plug 'mbbill/undotree'
    let g:undotree_SetFocusWhenToggle=1
" }}}

" Tabular: Aligning text {{{
" https://github.com/godlygeek/tabular
    Plug 'godlygeek/tabular'
" }}}

" Tagbar: Class outline {{{
" http://majutsushi.github.io/tagbar
    Plug 'majutsushi/tagbar'
" }}}

" YouCompleteMe: Code-completion engine{{{
" http://valloric.github.io/YouCompleteMe/"
	if (v:version < 703)
		let g:disable_ycm = 1
	endif
	if !exists('g:disable_ycm')
		Plug 'Valloric/YouCompleteMe', { 'do': 'python install.py'}
		let g:ycm_collect_identifiers_from_tags_files = 1
	endif
" }}}

" VimShell: Shell written in vimscript {{{
" https://github.com/Shougo/vimshell.vim
    Plug 'Shougo/vimshell'
" }}}

" UltiSnips: Snippets auto-complete {{{
    if v:version > 703
        Plug 'SirVer/ultisnips'
        Plug 'honza/vim-snippets'
    endif
" }}}

" Ansible syntax {{{
" https://twitter.com/garrynewman/status/684745966260490240
    Plug 'chase/vim-ansible-yaml'
" }}}

" Split window horizontally {{{
    let g:UltiSnipsEditSplit="vertical"
" }}}

" Twig Syntax Highlighting {{{
" https://github.com/beyondwords/vim-twig
    Plug 'beyondwords/vim-twig'
" }}}

" HTML-AutoCloseTag: Automatically close html tags {{{
" https://github.com/amirh/HTML-AutoCloseTag
    Plug 'amirh/HTML-AutoCloseTag'
" }}}

" HTML Color preview {{{
" https://github.com/gorodinskiy/vim-coloresque
    Plug 'gorodinskiy/vim-coloresque'
" }}}

" Better JSON support {{{
" https://github.com/elzr/vim-json
    Plug 'elzr/vim-json', { 'for': 'json' }
" }}}

" GitGutter: Git diff in gutter {{{
" https://github.com/airblade/vim-gitgutter
    Plug 'airblade/vim-gitgutter'
" }}}

" Unite: Buffer helper {{{
    Plug 'shougo/unite.vim'
" }}}

" vimfiler: A powerful file explorer implemented in Vim script {{{
" https://github.com/Shougo/vimfiler.vim
    Plug 'shougo/vimfiler.vim'
" }}}

" Vimproc: Interactive cli exec {{{
" *Requirements of async search unite.vim
" https://github.com/Shougo/vimproc.vim
    Plug 'shougo/vimproc.vim', {'do': 'make'}
" }}}

" autotag: Automatically update ctags {{{
" https://github.com/craigemery/vim-autotag
    Plug 'https://github.com/craigemery/vim-autotag.git'
" }}}

" i3 Vim Syntax {{{
" https://github.com/PotatoesMaster/i3-vim-syntax
Plug 'potatoesmaster/i3-vim-syntax'
" }}}

" Syntastic {{{
" https://github.com/scrooloose/syntastic
Plug 'scrooloose/syntastic'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open =1
let g:syntastic_check_on_wq = 0
let g:syntastic_php_checkers = ['php']
" }}}

" SuperTab {{{
" https://github.com/ervandew/supertab
Plug 'ervandew/supertab'
" }}}
call plug#end()
" }}}

" General Settings {{{
filetype plugin indent on " Detect file types
syntax on                 " Syntax highlighting
set mouse=""              " I don't want no stinking mouse
scriptencoding utf-8      " Set encoding to utf-8

set history=1000          " Increase history size
set spell                 " Enable Spell-check
set hidden                " Enable buffer switch without saving
set iskeyword-=.          " '.' represents a word
set iskeyword-=#          " '#' represents a word
set iskeyword-=-          " '-' represents a word

set backspace=indent,eol,start " What to delete on backspace
set foldenable                 " Auto-fold
set hlsearch                   " Highlight search term
set ignorecase                 " Default search is case-insensitive
set incsearch                  " Search as you type
set linespace=0                " No extra space between rows
set nu                         " Line numbering
set scrolljump=5               " Jump 5 lines when cursor leave screen
set scrolloff=3                " Minimum lines above or below cursor
set shortmess+=aoOtT           " Abbreviate messages
set showmatch                  " Show matching brackets/parenthesis
set smartcase                  " When uppercase detected, search case-sensitive
set whichwrap=b,s,h,l,<,>,[,]  " Cursor + backspace + default wrap
set wildmenu                   " Display menu instead of auto-complete
set wildmode=list:longest,full " Tab completion order
set winminheight=0             " Window can be any size

set list
set listchars=tab:>\ ,trail:•,extends:#,nbsp:. " Replace special chars in list mode
" }}}

" Temporary files directories {{{
" Double slash prevents name collision
    " Backup {{{
    set backupdir=~/.vim/backup
    set backupdir+=~/.vim-backup
    set backupdir+=.
    set backup
    set writebackup
    " }}}

    " Swap {{{
    set directory=./.vim-swap//
    set directory+=~/.vim/swap//
    set directory+=.
    " }}}

    " Undo {{{
    if has("persistent_undo")
        set undodir=~/.vim/undo//
        set undofile
    endif 
    " }}}
" }}}

" Formatting {{{
set nowrap            " No line wrapping
set autoindent        " Indent according to previous line
set shiftwidth=4      " Use 4-spaces indent
set expandtab         " Tabs are spaces, No thank you tabs
set tabstop=4         " Indentation is 4 columns
set softtabstop=4     " Backspace delete indent
set nojoinspaces      " Don't include space after join
set splitright        " vsplit to the right of current
set splitbelow        " hsplit below current
set pastetoggle=<F12> " Sane indentation on paste
" }}}

" Autocommands {{{
    " Remove trailing whitespace"{{{
    augroup trailing_whitespace
        autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> | call StripTrailingWhitespace()
    augroup END
    " }}}

    " Markdown filetype {{{
    augroup filetype_md
        autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    augroup END
    " }}}

    " Vim filetype {{{
    augroup filetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker
    augroup END
    " }}}

" }}}

" Vim UI {{{
set showmode            " Display active mode
set cursorline          " Highlight current line

if !has('gui_running')
  set t_Co=256
endif
" }}}

" Fix Shift mistakes {{{
if has("user_commands")
    command! -bang -nargs=* -complete=file E  e<bang> <args>
    command! -bang -nargs=* -complete=file W  w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ QW<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q  q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif
" }}}

" Keymappings {{{
    " Leader key {{{
    let mapleader = ','
    " }}}

    " Return to normal mode {{{
    inoremap jk <esc>
    " }}}

    " Forgot sudo? {{{
    cmap w!! w !sudo tee % >/dev/null
    " }}}

    " Edit mode helper {{{
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e   %%
    map <leader>es :sp  %%
    map <leader>ev :vsp %%
    " }}}

    " Vimfiler {{{
    map <C-e> :VimFilerExplorer -force-hide<Cr>
    " }}}

    " Tagbar {{{
    nnoremap <silent> <leader>tt :TagbarToggle<Cr>
    nnoremap <silent> <leader>to :TagbarOpenAutoClose<Cr>
    " }}}

    " UndoTree {{{
    nnoremap <Leader>u :UndotreeToggle<CR>
    " }}}

    " Remap UltiSnips for compatibility with YouCompleteMe {{{
    let g:UltiSnipsExpandTrigger       = '<C-j>'
    let g:UltiSnipsJumpForwardTrigger  = '<C-j>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
    " }}}
    
    " Strip whitespace {{{
    nnoremap <F10> :execute StripTrailingWhitespace()<Cr>
    " }}}

    " PHP Code style fix {{{
    nnoremap <F11> :!php-cs-fixer fix %<Cr>
    " }}}

    " Unite {{{
    nnoremap <leader>f :UniteWithProjectDir -start-insert file_rec/async<Cr>
    nnoremap <leader>b :Unite buffer<Cr>
    nnoremap <leader>p :Unite file_rec/git<Cr>
    nnoremap <C-p>     :Unite file_rec/git<Cr>
    " }}}

    " YouCompleteMe  {{{
    nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<Cr>
    " }}}
    
    " Multiple theme in case of eye strain   
    nnoremap <leader>1 :colorscheme obsidian<Cr>
    nnoremap <leader>2 :colorscheme Tomorrow-Night-Bright<Cr>
    nnoremap <leader>3 :colorscheme molokai<Cr>
    nnoremap <leader>4 :colorscheme badwolf<Cr>
    nnoremap <leader>5 :colorscheme skittles_berry<Cr>
" }}}

" Load user configuration {{{
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
" }}}
