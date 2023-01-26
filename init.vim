
" These options and commands enable some very useful features in Vim, that
" no user should have to live without.

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype off

" Enable syntax highlighting
syntax on

" Relative number lines
set relativenumber 

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"Autocompletion plugin from git
Plugin 'ycm-core/YouCompleteMe'

"Git plugin, ironically also from git
Plugin 'tpope/vim-fugitive'

"vim-tmux-navigator, smart navigation between vim and tmux panes
Plugin 'christoomey/vim-tmux-navigator'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"------------------------------------------------------------

"Fix python3 interpreter
let g:python3_host_prog = '/usr/bin/python3'
let g:ycm_path_to_python_interpreter = '/usr/bin/python3'

" These are highly recommended options.

" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" set confirm
" set autowriteall

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

"------------------------------------------------------------
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
"set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
"set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

"Always wrap long lines
set wrap

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F9> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F9>

"------------------------------------------------------------

" Indentation settings according to personal preference.

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab
"set tabstop=4

"------------------------------------------------------------
" Useful mappings
"

" vim tmux navigator integrator
let mapleader = "\<Space>"

let g:tmux_navigator_no_mappings = 1
noremap <silent> <C-Left> :<C-U>TmuxNavigateLeft<cr>
noremap <silent> <C-Down> :<C-U>TmuxNavigateDown<cr>
noremap <silent> <C-Up> :<C-U>TmuxNavigateUp<cr>
noremap <silent> <C-Right> :<C-U>TmuxNavigateRight<cr>
"noremap <silent> <C-²> :<C-U>TmuxNavigatePrevious<cr>

" Reload init.vim
map :r :source $MYVIMRC

" CTRL-A  N  CTRL-A	add N to the number at or after the cursor
" CTRL-X  N  CTRL-X	subtract N from the number at or after the cursor
" mapping them to + And  - 
nnoremap + <C-a>
nnoremap - <C-x>
vnoremap + <C-a>
vnoremap - <C-x>

"Map Shift to visual mode from normal mode
nnoremap <C-S>  

" Enter -> newline without entering insert mode
nnoremap <Enter> o<Esc>0"_U

" Move lines while holding shift
" Multiple lines => select in visual mode
nnoremap <S-M-Down> :m .+2<CR>==
nnoremap <S-M-Up> :m .-2<CR>==
inoremap <S-M-Down> <Esc>:m .+1<CR>==gi
inoremap <S-M-Up> <Esc>:m .-2<CR>==gi
vnoremap <S-M-Down> :m '>+1<CR>gv=gv
vnoremap <S-M-Up> :m '<-2<CR>gv=gv

" Ctrl-o is mapped to nth older iposition in jump list
" Ctrl-i is mapped to nth newer position in jump list
" Quickly insert an empty new line without entering insert modef
" nnoremap <Leader>o o<Esc>0"_D
" nnoremap <Leader>O O<Esc>0"_D

" unnamedplus	A variant of the "unnamed" flag which uses the
" clipboard register "+" (quoteplus) instead of
" register "*" for all yank, delete, change and put
" operations which would normally go to the unnamed
" register.

" Ctrl - z is -> undo instead of stop 
nnoremap <C-z> :u <Enter>
vnoremap <C-z> <Esc> :u <Enter> <CR>==gv 
inoremap <C-z> <Esc> :u <Enter> <CR>==gi

" Normal clipboard functionality for yy, y and d
set clipboard+=unnamedplus

"nnoremap <C-c> yy
"nnoremap <C-v> p
"inoremap <C-c> <Esc> yy <CR>==gi
"inoremap <C-v> <Esc> p <CR>==gi
"vnoremap <C-c> y 
"vnoremap <C-v> p 

" C-x -> Escape
" inoremap <C-x> <Esc>
" vnoremap <C-x> <Esc>

" C-s => Save
nnoremap <C-s> :write! <Enter>
inoremap <C-s> <Esc> :write! <Enter> <CR>==gi
vnoremap <C-s> <Esc> :write! <Enter> <CR>==gv

" C-q => Quit
nnoremap <C-q> :q! <Enter>
inoremap <C-q> <Esc> :q! <Enter> <CR>==gi
vnoremap <C-q> <Esc> :q! <Enter> <CR>==gv

" C-w => Save and quit
" nnoremap <C-w> :wq<CR>
