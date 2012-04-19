" .vimrc                                                        -*- vimrc -*-
"
" TODO:
"   * Find some way to colorize tabs.
" To look up a particular setting, use, e.g.:
" :help 'nocp'

"""""""""""""""""""""""""""
" Feature settings
"""""""""""""""""""""""""""

" General
set nocp               " No compatability for VI
set mouse=a            " I'm generally in xterm; XXX: wrap in if for terminal
set aw                 " autowrite (ie auto save)
set patchmode=.orig    " Keep 1st version of files around
set backup             " Always make backup files

" Display
set nu                 " line numbers down the left side
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
colo evening           " a reasonable high-contrast, dark-background default

" Searching commands
set is                 " Incremental search
set magic              " Makes pattern syntax a little more intuitive
set hls                " Turns on highlighting while searching
"set noignorecase       " Don't ignore case when searching
set ignorecase         " Ignore case when searching, but...
set smartcase          " actually pay attention to case when pattern has it

" Programming
set sm                 " Show matching ()'s []'s {}'s
set ai                 " Autoindents
"set cin                " Autoindents C code (see manual for config options)
set tabstop=4          " Tabs are 4 spaces long
set shiftwidth=4       " autoindent tabs are 4 spaces too
set et                 " Tabs are converted to space characters
set diffopt=iwhite     " whitespace-insensitive vdiffs

"""""""""""""""""""""""""""
" Keystroke Mappings
"""""""""""""""""""""""""""

" Make tilde an operator like d, y or c
set top                

"Make Y = y$ not yy.  More intuative
noremap Y y$

" Pass the word under the pointer to dict.org's 'dict' client
map _d "zyawnmz:read !dict z<CR>`z5dd

" Pass the word under the pointer to uchicago's ARTFL Roget's Thesaurus (1911)
" XXX: Disabled.  Buggy performance or possibly completely broken.
"map _t "zyawnmz:read !lynx -dump -hiddenlinks=ignore -nolist -nolog -nopause -noredir -nostatus http://machaut.uchicago.edu/cgi-bin/ROGET.sh?word=z<CR>`z12dd

" Spell Checking with aspell
" XXX: Obsolete.  See *.txt autocommands below
"map _s :w!<CR>:!aspell check %<CR>:e! %<CR>

" Word counts
" XXX: Obsolete.  Use: g^g
" map _w :w!<CR>:!wc %<CR>

" re-indent the current file, and re-read it
" XXX: Obsolete.  Use: =G
"map _i :w!<CR>:!indent %<CR>:e! %<CR>

" Get svn diffs for against the current buffer.  see also
" http://www.vim.org/tips/tip.php?tip_id=1282
" XXX: srsl?  Who uses svn any more?
" map _v :new<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg

" Abbreviation mappings.  See chapter 24 in the manual.
iab glinux GNU/Linux
iab teh the

"""""""""""""""""""""""""""
" Ex mode command definitions
"""""""""""""""""""""""""""
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"""""""""""""""""""""""""""
" Autocommand settings
"""""""""""""""""""""""""""
" Only do the autocommand stuff if we're compiled with autocommand support.
if has("autocmd")

  " Enable filetype detection
  " Also load indent files, so we can do language-dependent indenting
  filetype plugin indent on

  " Declare  autocmd group so we can enable/disable these directives together
  augroup vimrcJoeAuto
  au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

    " Text files have a text width of 79 characters
    autocmd BufNewFile *.txt  setlocal tw=79 noai nocindent nonu
    autocmd BufRead    *.txt  setlocal tw=79 noai nocindent nonu
    autocmd BufEnter   *.txt  setlocal spell spelllang=en_us
    autocmd BufLeave   *.txt  setlocal nospell 
    
    " Email files for Thunderbird's 'external editor' plugin
    autocmd BufNewFile *.eml  setlocal tw=72 noai nocindent nonu
    autocmd BufRead    *.eml  setlocal tw=72 noai nocindent nonu
    autocmd BufEnter   *.eml  setlocal spell spelllang=en_us
    autocmd BufLeave   *.eml  setlocal nospell 
    " Email files for Evolutions's 'external editor' plugin
    autocmd BufNewFile /tmp/evo[0-9a-zA-Z]* setlocal tw=72 noai nocindent nonu
    autocmd BufRead /tmp/evo[0-9a-zA-Z]* setlocal tw=72 noai nocindent nonu
    autocmd BufEnter /tmp/evo[0-9a-zA-Z]* setlocal spell spelllang=en_us
    autocmd BufLeave /tmp/evo[0-9a-zA-Z]* setlocal nospell 
    
    " Tex files are like text files, but for tex instead of text
    autocmd BufNewFile *.tex  setlocal tw=79 noai nocindent nonu
    autocmd BufRead    *.tex  setlocal tw=79 noai nocindent nonu
    
    " Free Writing Exercises are mostly, but not entirely, like text files
    autocmd BufNewFile *.fwe  setlocal tw=79 noai nocindent nonu
    autocmd BufRead    *.fwe  setlocal tw=79 noai nocindent nonu
    autocmd BufRead    *.fwe  G
    
    " Correctly indent VCS commit messages
    autocmd BufNewFile svn-commit.tmp   setlocal tw=79 nocindent noai nonu
    autocmd BufNewFile COMMIT_EDITMSG   setlocal tw=79 nocindent noai nonu
    
    " Automatically chmod +x Shell & Perl
    autocmd BufWritePre   *.sh,*.pl,*.plx   setlocal ar 
    autocmd BufWritePost  *.sh,*.pl,*.plx   !chmod u+x %
    autocmd BufWritePost  *.sh,*.pl,*.plx   set ar<
    
  augroup END " vimrcJoeAuto

else

  " I don't have anything particular for when we don't have autocmd,
  " there's so much awesome in the configuration up above. :)

endif " has("autocmd")

" Make vim chdir to the directory of the file we're editing; 
" XXX: may break some plugins
if exists('+autochdir')
    set autochdir
else
    autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
endif

