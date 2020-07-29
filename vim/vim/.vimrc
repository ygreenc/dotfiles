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
" Setup plugpac {{{
    call plugpac#begin()

" minpac
    Pack 'k-takata/minpac', {'type': 'opt'}
" }}}
" Vim utility functions {{{
    Pack 'tomtom/tlib_vim'
    Pack 'MarcWeber/vim-addon-mw-utils'
" }}}
" Multiple filetype definition {{{
    Pack 'sheerun/vim-polyglot'
" }}}
" Quote and tags (surroundings) {{{
" https://github.com/tpope/vim-surround
    Pack 'tpope/vim-surround'
" }}}
" Automatically close pair-characters {{{
" https://github.com/spf13/vim-autoclose
    Pack 'spf13/vim-autoclose'
    let g:autoclose_vim_commentmode=1 " Do not autoclose '"' in vimscript
" }}}
" Buffer list in statusline {{{
" https://github.com/bling/vim-bufferline
    Pack 'bling/vim-bufferline'
    let g:bufferline_active_buffer_left = ''
    let g:bufferline_active_buffer_right = ''
" }}}
" Lighline: Statusline-light {{{
" https://github.com/itchyny/lightline.vim
    Pack 'itchyny/lightline.vim'
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
            \ &ft == 'unite' ? unite() :
            \ &ft == 'vimshell' ? vimshell#get_status_string() :
            \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
            \ ('' != fname ? fname : '[No Name]') .
            \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
    endfunction
    let g:unite = 0
" }}}
" EasyMotion, Vim motion with highlighting {{{
" https://github.com/Lokaltog/vim-easymotion
    Pack 'Lokaltog/vim-easymotion'
" }}}
" NERDCommenter: Comments helper {{{
" https://github.com/scrooloose/nerdcommenter
    Pack 'scrooloose/nerdcommenter'
" }}} 
" UndoTree {{{
" https://github.com/mbbill/undotree
    Pack 'mbbill/undotree'
    let g:undotree_SetFocusWhenToggle=1
" }}}
" Better JSON support {{{
" https://github.com/elzr/vim-json
    Pack 'elzr/vim-json', { 'for': 'json' }
" }}}
" GitGutter: Git diff in gutter {{{
" https://github.com/airblade/vim-gitgutter
    Pack 'airblade/vim-gitgutter'
" }}}
" Color schemes {{{
    Pack 'jacoborus/tender'
" }}}
" docker-compose syntax {{{
" https://github.com/ekalinin/Dockerfile.vim
    Pack 'ekalinin/Dockerfile.vim'
" }}}
call plugpac#end()
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

    " UndoTree {{{
    nnoremap <Leader>u :UndotreeToggle<CR>
    " }}}

    " Strip whitespace {{{
    nnoremap <F10> :execute StripTrailingWhitespace()<Cr>
    " }}}
" }}}

" Load user configuration {{{
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
" }}}
