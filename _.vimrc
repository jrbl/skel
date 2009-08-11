" .vimrc                                                        -*- vimrc -*-
"
" TODO:
"   * Find some way to colorize tabs.
"

"""""""""""""""""""""""""""
" Feature settings
"""""""""""""""""""""""""""

" General
set nocp               " No compatability for VI
set aw                 " autowrite (ie auto save)
set patchmode=.orig    " Keep 1st version of files around
set backup             " Always make backup files

" Display
set ruler              " Show (row,col) 
set scrolloff=3        " We keep 3 lines when scrolling  
set showcmd            " Show command in status line
set ttyfast            " Smoother changes
set title              " display vim info in window titlebar (in x)
set icon               " display a mini-icon in our window (in x)
set equalalways        " keep multiple buffers the same size
set ead=both           " same size horiz. and vert.

" Editing
set hid                " When we open a new file, keep old ones around
set backspace=2        " Makes backspace DTRT in Insert mode
set nowrap             " No line wrap

" Syntax highlighting 
set background=dark    " Makes colors brighter on dark terminals
syntax on              " Make everything colorful and WONDERFUL!!
filetype plugin on     " Special filetype processing (via vim or my own)

" Searching commands
set is                 " Incremental search
set noignorecase       " Don't ignore case when searching
set magic              " Makes pattern syntax a little more intuitive
set hls                " Turns on highlighting while searching

" Programming
set sm                 " Show matching ()'s []'s {}'s
set ai                 " Autoindents
set cin                " Autoindents C code
set tabstop=4          " Tabs are 4 spaces long
set shiftwidth=4       " autoindent tabs are 4 spaces too
set et                 " Tabs are converted to space characters
set diffopt=iwhite     " whitespace-insensitive vdiffs

"""""""""""""""""""""""""""
" Command Mappings
"""""""""""""""""""""""""""
" Spell Checking with aspell
" Obsolete.  See :help for vim's builtin spelling checker.
map _s :w!<CR>:!aspell check %<CR>:e! %<CR>

" Word counts
" I'd be surprised if this weren't obsolete too.  Even if it's not, it
" would be better expressed as a macro.
map _w :w!<CR>:!wc %<CR>

" Pass the word under the pointer to dict.org's 'dict' client
map _d "zyawnmz:read !dict z<CR>`z5dd

" Pass the word under the pointer to uchicago's ARTFL Roget's Thesaurus (1911)
map _t "zyawnmz:read !lynx -dump -hiddenlinks=ignore -nolist -nolog -nopause -noredir -nostatus http://machaut.uchicago.edu/cgi-bin/ROGET.sh?word=z<CR>`z12dd

" re-indent the current file, and re-read it
map _i :w!<CR>:!indent %<CR>:e! %<CR>

" Get svn diffs for against the current buffer.  see also
" http://www.vim.org/tips/tip.php?tip_id=1282
map _v :new<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg

" Abbreviation mappings.  See chapter 24 in the manual.
iab glinux GNU/Linux
iab teh the

"""""""""""""""""""""""""""
" Autocommand settings
"""""""""""""""""""""""""""

" Make comments be Light Cyan
autocmd  BufReadPre * :hi Comment ctermfg=LightCyan
"autocmd  BufReadPre * :hi Comment ctermfg=Gray

" When using mutt make the textwidth 76 cols;
" also set some text-formatting options
autocmd BufRead  mutt*[0-9]             set tw=76
autocmd BufRead  mutt*[0-9]             set noautoindent
autocmd BufRead  mutt*[0-9]             set nocindent
autocmd BufRead  mutt*[0-9]             set ignorecase
autocmd BufRead  pico*[0-9]             set tw=76
autocmd BufRead  pico*[0-9]             set noautoindent
autocmd BufRead  pico*[0-9]             set nocindent
autocmd BufRead  mutt*[0-9]             set ignorecase

" Text files have a text width of 78 characters
autocmd BufNewFile *.txt                set tw=78 noai nocindent 
autocmd BufRead    *.txt                set tw=78 noai nocindent 

" Tex files are like text files, but for tex
autocmd BufNewFile *.tex                set tw=78 noai nocindent 
autocmd BufRead    *.tex                set tw=78 noai nocindent 

" Free Writing Exercises are mostly, but not entirely, like text files
autocmd BufNewFile *.fwe     set tw=78 noai nocindent 
autocmd BufRead    *.fwe     set tw=78 noai nocindent 
autocmd BufRead    *.fwe     G

" Correctly indent Subversion commit messages
autocmd BufNewFile svn-commit.tmp       set tw=78 nocindent noai

" Automatically chmod +x Shell, Perl, and Python scripts
autocmd BufWritePost   *.sh             !chmod 700 %
autocmd BufWritePost   *.pl             !chmod 700 %
autocmd BufWritePost   *.plx            !chmod 700 %
autocmd BufWritePost   *.py             !chmod 700 %

