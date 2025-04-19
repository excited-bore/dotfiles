 " lua config at 
" $HOME/.config/nvim/init.lua.vim

" highlight Visual cterm=reverse ctermbg=NONE
" These options and commands enable some very useful features in Vim, that
" no user should live without
" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc

"If you set scrollof to a very large value (999) the cursor line will always be at the middle
" set scrolloff=999

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype plugin indent on

" Enable syntax highlighting
syntax on

" Prevent flashbangs
set background=dark 

" Complete with keywords
set complete+=k

" Enable Omnicomplete features
set omnifunc=syntaxcomplete#Complete

" Better command-line completion
set wildmenu
set wildmode=longest,full
set wildoptions=fuzzy

"Enable relative number lines
set relativenumber

"https://vim.fandom.com/wiki/GNU/Linux_clipboard_copy/paste_with_xclip
"The 'a' and 'A' options enables copying selected text to system clipboard 
"set guioptions=aAimrLT

" Set shell and shell cmd flags (-l/--login, -i/--interactive - WARNING: Might break config)
"set shell=/bin/bash    
"set shellcmdflag=-i



"------------------------------------------------------------

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

" Change to directoy containing file you open
set autochdir


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

"Automatically load file changes into buffer when external sources modify the
"file your currently editing
set autoread

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

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

"https://vi.stackexchange.com/questions/37386/cursor-not-changing-to-beam-in-insert-mode-when-using-kitty-terminal
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" 'press <Enter> to continue'
set cmdheight=2

" Display line numbers on the left
set number

"Always wrap long lines and scroll line by line when wrapped
set wrap smoothscroll

" Quickly time out on keycodes, but never time out on mappings
set ttimeout ttimeoutlen=200

" Use <F9> to toggle between 'paste' and 'nopaste'
" set pastetoggle=<F9>

" unnamedplus	A variant of the "unnamed" flag which uses the
" clipboard register "+" (quoteplus) instead of
" register "*" for all yank, delete, change and put
" operations which would normally go to the unnamed
" register.
" Normal clipboard functionality for yy, y and d
"
" If vim is accessed over ssh though, be carefull for using this. Xclip can be
" troublesome so test this setting to see that this is your possible problem 
set clipboard+=unnamedplus

" Indentation settings according to personal preference.

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab
"set tabstop=4

" Ignore whitespace for vimdiff
set diffopt+=iwhite 

" Different visual block mode
" set virtualedit=all    


" Ctags
" Set tags for use with ctags
" https://stackoverflow.com/questions/11975316/vim-ctags-tag-not-found
set tags=./tags,tags;$HOME

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

"Tmux has problems with nvim colors if we dont supply it with true colors
"https://unix.stackexchange.com/questions/251847/clear-to-end-of-line-uses-the-wrong-background-color-in-tmux/252078#252078
if (has("termguicolors"))
    set termguicolors
endif 

" By far, the bashiest answer of them all :) – José Fernández Ramos
" https://stackoverflow.com/questions/8841116/vim-not-recognizing-aliases-when-in-interactive-mode

if (filereadable(expand('~/.bash_aliases')))
    let $BASH_ENV="~/.bash_aliases"
endif

" For files with EOF
au BufNewFile * set noeol

" Read gz files without opening them
" https://stackoverflow.com/questions/5396363/how-to-open-gzip-text-files-in-gvim-without-unzipping
augroup gzip
 autocmd!
 autocmd BufReadPre,FileReadPre *.gz set bin
 autocmd BufReadPost,FileReadPost   *.gz '[,']!gunzip
 autocmd BufReadPost,FileReadPost   *.gz set nobin
 autocmd BufReadPost,FileReadPost   *.gz execute ":doautocmd BufReadPost " . expand("%:r")
 autocmd BufWritePost,FileWritePost *.gz !mv <afile> <afile>:r
 autocmd BufWritePost,FileWritePost *.gz !gzip <afile>:r
 autocmd FileAppendPre      *.gz !gunzip <afile>
 autocmd FileAppendPre      *.gz !mv <afile>:r <afile>
 autocmd FileAppendPost     *.gz !mv <afile> <afile>:r
 autocmd FileAppendPost     *.gz !gzip <afile>:r
augroup END

" Netrw nerdtree like settings
" https://shapeshed.com/vim-netrw/
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END


"Fix python3 interpreter
let g:python3_host_prog = '/usr/bin/python3'
let g:ycm_path_to_python_interpreter = '/usr/bin/python3'

"Fix Ruby interpreter
"let g:ruby_host_prog = '$HOME/.gem/ruby/3.0.0/bin/neovim-ruby-host'

"autocmd CursorHold      * echo mode(1) 
"autocmd CursorHoldI     * echo mode(1)
autocmd CursorMoved     * set cul
autocmd CursorMovedI    * set cul
"autocmd InsertEnter     * set cul
"autocmd InsertLeave     * set nocul


let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if !has('nvim')
    if empty(glob(data_dir . '/autoload/plug.vim'))
      silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif

" Disable pylint            
" let g:neomake_python_enabled_makers = []

" Enable pylint
let g:neomake_python_enabled_makers = ['pylint']


"Vim plugins point to githubs wich is very nice and just fucking cool

let g:pluginInstallPath=expand('~/.vim/plugins')

if has('win32')
    source $HOME\AppData\Local\nvim\plug_lazy_adapter.vim
else
    source $HOME/.config/nvim/plug_lazy_adapter.vim
endif

if !has('nvim')
  call plug#begin(g:pluginInstallPath)
endif

" Autocomplete engine (Conquer of completions)
" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions


" Autocompletion 
if !has('nvim')
    Plugin 'prabirshrestha/vim-lsp'
    Plugin 'neoclide/coc.nvim', {'branch': 'release'}
    let g:airline#extensions#coc#show_coc_status = 1
else
    Plugin 'neovim/nvim-lspconfig'
    Plugin 'hrsh7th/cmp-nvim-lsp'
    Plugin 'hrsh7th/cmp-buffer'
    Plugin 'hrsh7th/cmp-path'
    Plugin 'hrsh7th/cmp-cmdline'
    Plugin 'hrsh7th/nvim-cmp'
endif

" Lua function as nvim functions
if has('nvim')

    " Telescope
    Plugin 'nvim-lua/popup.nvim'
    Plugin 'nvim-lua/plenary.nvim'
    Plugin 'nvim-telescope/telescope.nvim'
    "Plugin 'nvim-telescope/telescope-live-grep-args.nvim'
    Plugin 'nvim-telescope/telescope-file-browser.nvim' 
    Plugin 'nvim-telescope/telescope-media-files.nvim'
    
    " Ast-grep
    Plugin 'Marskey/telescope-sg' 

    " Oil netrw replacer and file creator on - 
    Plugin 'stevearc/oil.nvim' 
   
    "Mini + File browser
    Plugin 'echasnovski/mini.nvim'
    
    "Plugin 'echasnovski/mini.files'

    " Nice keybinds overview for nvim
    "Plugin 'folke/which-key.nvim'
    
    "Plugin "SalOrak/whaler"
 
endif


" Devicons
if !has('nvim')
    "Plugin 'vim-scripts/vim-webdevicons'
    Plugin 'ryanoasis/vim-devicons'
else
    Plugin 'echasnovski/mini.icons' 
    Plugin 'nvim-tree/nvim-web-devicons'
    " Enable Omnicomplete features
    "set omnifunc=v:"lua.vim.lsp.omnifunc
 
    " Markdown preview
    Plugin 'ellisonleao/glow.nvim'
   
    " Diff plugin
    Plugin 'sindrets/diffview.nvim'

    " Lazygit plugin
    Plugin 'kdheepak/lazygit.nvim'

    " Toggle Terminal
    Plugin 'akinsho/toggleterm.nvim'

endif

" Normal file operations
Plugin 'tpope/vim-eunuch'

" Copilot
"Plugin 'github/copilot.vim'

" Codeium (Free Copilot AI Helper) 
"Plugin 'Exafunction/codeium.vim', { 'branch': 'main' }


" Nerdtree | Left block directory tree
"Plugin 'preservim/nerdtree'

" Nerdtree git plugin
Plugin 'Xuyuanp/nerdtree-git-plugin'


" Nerdtree syntax highlighting / Laggiest plugin
"Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
"let g:NERDTreeLimitedSyntax = 1
"let g:NERDTreeHighlightCursorline = 0
let g:NERDTreeFileLines = 1


" Totally independent OS52 clipboard
Plugin 'ojroques/vim-oscyank', {'branch': 'main'}

" Color codes for pager
Plugin 'vim-scripts/AnsiEsc.vim'

" Ranger integration
"Plugin 'rbgrouleff/bclose.vim'
"Plugin 'francoiscabrol/ranger.vim'

let g:NERDTreeHijackNetrw = 0
let g:ranger_replace_netrw = 1
let g:ranger_map_keys = 0
let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'


" Fuzzy finder plugin
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
"Plugin 'junegunn/fzf.vim', { 'do': { -> fzf#install() } }

" Fuzzy finder preview
Plugin 'yuki-yano/fzf-preview.vim', { 'branch': 'release/remote' }

" Plugin for git
Plugin 'tpope/vim-fugitive'

" Zenmode style window
Plugin 'folke/zen-mode.nvim'

" Vim tmux kitty navigator
Plugin 'excited-bore/vim-tmux-kitty-navigator', { 'build': 'mkdir -p ~/.config/kitty/ && cd ~/.vim/plugins/vim-tmux-kitty-navigator && cp ./*.py ~/.config/kitty/'}

" Codeium (Free Copilot AI Helper) 
"Plugin 'Exafunction/codeium.vim', { 'branch': 'main' }

"Use sudo on file without opening with sudo (or root)
Plugin 'lambdalisue/suda.vim'
" let g:suda_smart_edit = 1
let g:suda#nopass = 1


" Give passwords prompts in vim
"Plugin 'lambdalisue/askpass.vim'
"" Dependency for askpass, Deno
"Plugin 'vim-denops/denops.vim'

" Nerd commenter
Plugin 'preservim/nerdcommenter'

" Gutentags - Automatic Ctags
Plugin 'ludovicchabant/vim-gutentags'


" Minimap to keep track of where in file
"Plugin 'wfxr/minimap.vim'
"let g:minimap_width = 10
"let g:minimap_highlight_range = 1
"let g:minimap_enable_highlight_colorgroup = 1
""let g:minimap_auto_start = 1
"let g:minimap_git_colors = 1
"let g:minimap_auto_start_win_enter = 1

" Self documenting vim wiki
"Plugin 'vimwiki/vimwiki'

" Nice and cool themey
Plugin 'morhetz/gruvbox'
let g:gruvbox_italic=1

" Nice and cool status bar thingy
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_exclude_filetypes = ['nerdtree']

" Gives tabs a nice layout as well

" Vim lua plugin
" Plugin 'svermeulen/vimpeccable'

"" All of your Plugins must be added before the following line
if !has('nvim')
    call plug#end()
else
    if has('win32')
        source $HOME\AppData\Local\nvim\init.lua.vim
    else
        source $HOME/.config/nvim/init.lua.vim
    endif
    lua require("lazy")
endif



" Post plugin load

if exists(':CocInfo')
    " https://github.com/neoclide/coc.nvim 
    " coc-lsp settings 

    " May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
    " utf-8 byte sequence
    set encoding=utf-8
    " Some servers have issues with backup files, see #649
    set nobackup
    set nowritebackup

    " Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
    " delays and poor user experience
    set updatetime=300

    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved
    set signcolumn=yes 
     
    " Use tab for trigger completion with characters ahead and navigate
    " NOTE: There's always complete item selected by default, you may want to enable
    " no select by `"suggest.noselect": true` in your configuration file
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config
    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1) :
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
    
    " Make <CR> to accept selected completion item or notify coc.nvim to format
    " <C-g>u breaks current undo, please make your own choice
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
    
    " Use <c-space> to trigger completion
    if has('nvim')
      inoremap <silent><expr> <C-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif
    
    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call ShowDocumentation()<CR>

    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction
    
    " Highlight the symbol and its references when holding the cursor
    autocmd CursorHold * silent call CocActionAsync('highlight')
    
    " Symbol renaming
    nmap <leader>rn <Plug>(coc-rename)

    " Formatting selected code
    xmap <Leader>p  <Plug>(coc-format-selected)
    nmap <Leader>p  <Plug>(coc-format-selected)
    
    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s)
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Applying code actions to the selected code block
    " Example: `<Leader>aap` for current paragraph
    xmap <Leader>a  <Plug>(coc-codeaction-selected)
    nmap <Leader>a  <Plug>(coc-codeaction-selected)

    " Remap keys for applying code actions at the cursor position
    nmap <Leader>ac  <Plug>(coc-codeaction-cursor)
    " Remap keys for apply code actions affect whole buffer
    nmap <Leader>as  <Plug>(coc-codeaction-source)
    " Apply the most preferred quickfix action to fix diagnostic on the current line
    nmap <Leader>qf  <Plug>(coc-fix-current)

    " Remap keys for applying refactor code actions
    nmap <silent> <Leader>re <Plug>(coc-codeaction-refactor)
    xmap <silent> <Leader>r  <Plug>(coc-codeaction-refactor-selected)
    nmap <silent> <Leader>r  <Plug>(coc-codeaction-refactor-selected)

    " Run the Code Lens action on the current line
    "nmap <Leader>cl  <Plug>(coc-codelens-action)

    " Map function and class text objects
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Add `:Format` command to format current buffer
    command! -nargs=0 Format :call CocActionAsync('format')

    " Add `:Fold` command to fold current buffer
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " Add `:OR` command for organize imports of the current buffer
    command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
     
    " Add (Neo)Vim's native statusline support
    " NOTE: Please see `:h coc-status` for integrations with external plugins that
    " provide custom statusline: lightline.vim, vim-airline
    "set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Mappings for CoCList
    " Show all diagnostics
    nnoremap <silent><nowait> <C-Tab>a  :<C-u>CocList diagnostics<cr>
    " Manage extensions
    nnoremap <silent><nowait> <C-Tab>e  :<C-u>CocList extensions<cr>
    " Show commands
    nnoremap <silent><nowait> <C-Tab>c  :<C-u>CocList commands<cr>
    " Find symbol of current document
    nnoremap <silent><nowait> <C-Tab>o  :<C-u>CocList outline<cr>
    " Search workspace symbols
    nnoremap <silent><nowait> <C-Tab>s  :<C-u>CocList -I symbols<cr>
    " Do default action for next item
    nnoremap <silent><nowait> <C-Tab>j  :<C-u>CocNext<CR>
    " Do default action for previous item
    nnoremap <silent><nowait> <C-Tab>k  :<C-u>CocPrev<CR>
    " Resume latest coc list        
    nnoremap <silent><nowait> <C-Tab>p  :<C-u>CocListResume<CR>
    
    " Alt - C is -> CocCommand 
    nnoremap <M-c> :CocCommand 
    inoremap <M-c> <C-\><C-o>:CocCommand 
    vnoremap <M-c> :CocCommand 

endif


if exists(':NERDTree')
    " Start NERDTree and put the cursor back in the other window.
    "autocmd VimEnter * NERDTree | wincmd p
    
    " Start NERDTree. If a file is specified, move the cursor to its window.
    "autocmd StdinReadPre * let s:std_in=1
    "autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

    " Exit Vim if NERDTree is the only window remaining in the only tab.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

    " Close the tab if NERDTree is the only window remaining in it.
    autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

     " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
    autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
        \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

     " Open the existing NERDTree on each new tab.
    autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

    nnoremap <C-n> :NERDTreeToggle<CR>
    inoremap <C-n> <C-\><C-o>:NERDTreeToggle<CR>
    vnoremap <C-n> :NERDTreeToggle<CR>
endif



"if exists(":Ranger")
"    "Ranger F2
"    nnoremap <silent><F2>   :RangerWorkingDirectory<CR>
"    inoremap <silent><F2>   <Esc>:RangerWorkingDirectory<CR>
"    vnoremap <silent><F2>   <Esc>:RangerWorkingDirectory<CR>
"
"endif



if exists(":TmuxKittyNavigateLeft")

    "Move to and from panes or pass to other program
    nnoremap <silent><C-S-Left> :<C-u>TmuxKittyNavigateLeft<cr>
    nnoremap <silent><C-S-Down> :<C-u>TmuxKittyNavigateDown<cr>
    nnoremap <silent><C-S-Up> :<C-u>TmuxKittyNavigateUp<cr>
    nnoremap <silent><C-S-Right> :<C-u>TmuxKittyNavigateRight<cr>

    inoremap <silent><C-S-Left> <esc>:<C-u>TmuxKittyNavigateLeft<cr>i
    inoremap <silent><C-S-Down> <esc>:<C-u>TmuxKittyNavigateDown<cr>i
    inoremap <silent><C-S-Up> <esc>:<C-u>TmuxKittyNavigateUp<cr>i
    inoremap <silent><C-S-Right> <esc>:<C-u>TmuxKittyNavigateRight<cr>i

    vnoremap <silent><C-S-Left> :<C-u>TmuxKittyNavigateLeft<cr>gv
    vnoremap <silent><C-S-Down> :<C-u>TmuxKittyNavigateDown<cr>gv
    vnoremap <silent><C-S-Up> :<C-u>TmuxKittyNavigateUp<cr>gv
    vnoremap <silent><C-S-Right> :<C-u>TmuxKittyNavigateRight<cr>gv 

    tnoremap <silent><C-S-Left> <C-\><C-n><cmd>TmuxKittyNavigateLeft<cr>
    tnoremap <silent><C-S-Down> <C-\><C-n><cmd>TmuxKittyNavigateDown<cr>
    tnoremap <silent><C-S-Up> <C-\><C-n><cmd>TmuxKittyNavigateUp<cr>
    tnoremap <silent><C-S-Right> <C-\><C-n><cmd>TmuxKittyNavigateRight<cr>

endif

if exists(":LazyGit")
    " Git files F3
    nnoremap <F3>   :LazyGit<CR>
    inoremap <F3>   <Esc>:LazyGit<CR>a
    vnoremap <F3>   :LazyGit<CR>gv
endif

if exists(':Toggleterm')
    " Toggleterm
    autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><C-²> <Cmd>exe v:count1 . "ToggleTerm"<CR>
endif

if exists(':MinimapToggle') 
    "Alt - M is -> Minimap 
    nnoremap <silent><M-m> <esc>:MinimapToggle<CR>:MinimapUpdateHighlight<cr>
    inoremap <silent><M-m> <C-\><C-o>:MinimapToggle<CR>:MinimapUpdateHighlight<cr>
    vnoremap <silent><M-m> <esc>:MinimapToggle<CR>:MinimapUpdateHighlight<cr>
endif

if exists(':Telescope')
    " Telescope F4
    nnoremap <F4>   :Telescope<CR>
    inoremap <F4>   <Esc>:Telescope<CR>a
    vnoremap <F4>   :Telescope<CR>gv
endif

if exists(':FzfPreview')

    " Checkout Files in current dir F7
    nnoremap <F7> :FzfPreviewDirectoryFiles<CR>
    inoremap <F7> <esc>:FzfPreviewDirectoryFiles<CR>a
    vnoremap <F7> :FzfPreviewDirectoryFiles<CR>gv

    " Checkout Git Files in current dir F7
    nnoremap <S-F7> :FzfPreviewGitFiles<CR>
    inoremap <S-F7> <esc>:FzfPreviewGitFiles<CR>a
    vnoremap <S-F7> :FzfPreviewGitFiles<CR>gv 

    "List buffers
    nnoremap <silent><C-S-Space> :<C-u>FzfPrevieimport_moduleBuffers<CR> 
    inoremap <silent><C-S-Space> <C-\><C-o><C-u>FzfPreviewAllBuffers<CR>
    vnoremap <silent><C-S-Space> <esc>:<C-u>FzfPreviewAllBuffers<CR>gv

    " Ctrl - f => Find
    nnoremap <silent><C-f> :Telescope<cr>
    inoremap <silent><C-f> <C-\><C-o>:Telescope<cr>
    vnoremap <silent><C-f> y<Esc>:Telescope<CR>gv
    
    "Line search with Ripgrep 
    "nnoremap <silent><C-f> :FzfPreviewLines<cr>
    "inoremap <silent><C-f> <C-\><C-o>:FzfPreviewLines<cr>
    "vnoremap <silent><C-f> y<Esc>:FzfPreviewLines --add-fzf-arg=--query="<C-r>=expand('<cword>')<CR>"<CR>

    " Ctrl-Shift-f => Find in all loaded buffer (even non-files(?))
    "Line search in loaded buffer
    nnoremap <silent><M-f> :FzfPreviewBufferLines<cr>
    inoremap <silent><M-f> <C-\><C-o>:FzfPreviewBufferLines<cr>
    vnoremap <silent><M-f> y<Esc>:FzfPreviewBufferLines --add-fzf-arg=--query="<C-r>=expand('<cword>')<CR>"<CR>
    
    " Leader key f fzf-preview leader key
    nmap <leader>f [fzf-p]
    xmap <leader>f [fzf-p]

    nnoremap <silent> [fzf-p]p     :<C-u>FzfPreviewFromResources project_mru git<CR>
    nnoremap <silent> [fzf-p]gs    :<C-u>FzfPreviewGitStatus<CR>
    nnoremap <silent> [fzf-p]ga    :<C-u>FzfPreviewGitActions<CR>
    nnoremap <silent> [fzf-p]b     :<C-u>FzfPreviewBuffers<CR>
    nnoremap <silent> [fzf-p]B     :<C-u>FzfPreviewAllBuffers<CR>
    nnoremap <silent> [fzf-p]o     :<C-u>FzfPreviewFromResources buffer project_mru<CR>
    nnoremap <silent> [fzf-p]<C-r> :<C-u>FzfPreviewJumps<CR>
    nnoremap <silent> [fzf-p]g;    :<C-u>FzfPreviewChanges<CR>
    nnoremap <silent> [fzf-p]/     :<C-u>FzfPreviewLines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
    nnoremap <silent> [fzf-p]*     :<C-u>FzfPreviewLines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
    nnoremap          [fzf-p]gr    :<C-u>FzfPreviewProjectGrep<Space>
    xnoremap          [fzf-p]gr    "sy:  FzfPreviewProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
    nnoremap <silent> [fzf-p]t     :<C-u>FzfPreviewBufferTags<CR>
    nnoremap <silent> [fzf-p]q     :<C-u>FzfPreviewQuickFix<CR>
    nnoremap <silent> [fzf-p]l     :<C-u>FzfPreviewLocationList<CR>
endif    


" Markdown autocmd
autocmd FileType markdown,text highlight ExtraWhitespace ctermbg=red guibg=red
autocmd FileType markdown,text match ExtraWhitespace /\s\+$/


"au filetype vimwiki silent! iunmap <buffer> <Tab>

" this is pseudo code
"let statusline = '%{&ft == "toggleterm" ? "terminal (".b:toggle_number.")" : ""}'

colorscheme gruvbox


"Add tab 
nnoremap <Tab>   i<tab><esc><right>

"Visual mode 
vnoremap <Tab>   >gv
vnoremap <S-Tab> <gv 

"nnoremap <C-S-d>    <Down>"*dd<Up>
"inoremap <expr> <C-S-d> (col(".") ==? 1 ? '<C-\><C-o>daW' : '<C-\><C-o>diW')
"vnoremap <C-S-d>    "*D

"a => Insert
"nnoremap a i
"vnoremap a i

"A => Append
"nnoremap A a
"vnoremap A a

"Ctrl-a => Toggle insert
nnoremap <C-a> i
inoremap <C-a> <esc>l
vnoremap <C-a> i


"Ctrl-Shift-a => Begin at next line
"nnoremap <C-a> o
"inoremap <C-S-a> <esc>
"vnoremap <C-S-a> o

"Alt-A => Replace (insert variant)
nnoremap <A-a> R
inoremap <A-a> <Esc>l
vnoremap <A-a> R

" Ctrl-Alt-A => Virtual Replace mode                    
" This mode differs from replace in that it plays nicely with tabs and spaces in files
nnoremap <C-A-a> gR
inoremap <C-A-a> <Esc>
vnoremap <C-A-a> <Esc>gR 

" S (instead of v) becomes \"select mode" or something
" S => visual mode
nnoremap s v
vnoremap s v
nnoremap S V
vnoremap S V

"Ctrl-Shift-s => Visual block mode
nnoremap <A-s> <C-q>
vnoremap <A-s> <C-q> 
inoremap <A-s> <C-o><C-q>

""Ctrl-Alt-S => Visual line mode
nnoremap <C-A-s> V
vnoremap <C-A-s> <Esc> 
inoremap <C-A-s> <C-o>V


" By applying the mappings this way you can pass a count to your
" mapping to open a specific window.
" For example: 2<C-t> will open terminal 2
nnoremap <silent><c-`> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-`> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
vnoremap <silent><c-`> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
tnoremap <silent><esc> <C-\><C-n>


" Reload .vimrc/init.vim F5
nnoremap <F5> :source $MYVIMRC<CR>
inoremap <F5> <esc>:source $MYVIMRC<CR>a
vnoremap <F5> :source $MYVIMRC<CR>gv

" Edit .vimrc/init.vim F6
nnoremap <F6> :e $MYVIMRC<CR>
inoremap <F6> <esc>:e $MYVIMRC<CR>a
vnoremap <F6> :e $MYVIMRC<CR>gv


" Buffers

" Open next buffer
nnoremap <silent><C-Tab> :bnext<cr>
inoremap <silent><C-Tab> <C-\><C-o>:bnext<cr>
vnoremap <silent><C-Tab> <esc>:bnext<cr>

" Open previous buffer
nnoremap <silent><C-S-Tab> :bprev<cr>
inoremap <silent><C-S-Tab> <C-\><C-o>:bprev<cr>
vnoremap <silent><C-S-Tab> <esc>:+bprev<cr>

" Open Horizontal buffer
nnoremap <silent><C-w>h :split<cr>
inoremap <silent><C-w>h <C-\><C-o>:split<cr>
vnoremap <silent><C-w>h <esc>:split<cr>gv

"" open vertical buffer
"nnoremap <s-a-down> :vertical sb
"inoremap <s-a-down> <c-\><c-o>:vertical sb
"vnoremap <S-A-Down> <esc>:vertical sb



" Choose pane
nnoremap <silent><C-S-Space> :Windows<cr>
inoremap <silent><C-S-Space> <C-\><C-o>:Windows<cr>
vnoremap <silent><C-S-Space> <esc>:Windows<cr>gv
                    
""Left pane          
"nnoremap <silent><C-S-Left> :wincmd h<cr>
"inoremap <silent><C-S-Left> <C-\><C-o>:wincmd h<cr>
"vnoremap <silent><C-S-Left> <esc>:wincmd h<cr>gv
"                    
""Right pane         
"nnoremap <silent><C-S-Right> :wincmd l<cr>
"inoremap <silent><C-S-Right> <C-\><C-o>:wincmd l<cr>
"vnoremap <silent><C-S-Right> <esc>:wincmd l<cr>gv
"                    
""Up pane            
"nnoremap <silent><C-S-Up> :wincmd k<cr>
"inoremap <silent><C-S-Up> <C-\><C-o>:wincmd k<cr>
"vnoremap <silent><C-S-Up> <esc>:wincmd k<cr>gv
"                    
""Down pane          
"nnoremap <silent><C-S-Down> :wincmd j<cr>
"inoremap <silent><C-S-Down> <C-\><C-o>:wincmd j<cr>
"vnoremap <silent><C-S-Down> <esc>:wincmd j<cr>gv 


" set


" Constantly set LastWindow
" https://stackoverflow.com/questions/7069927/in-vimscript-how-to-test-if-a-window-is-the-last-window
autocmd BufEnter * call MyLastWindow()

function! MyLastWindow()
   if &buftype=="quickfix"
      " if this window is last on screen quit without warning
      if winbufnr(2) == -1
         quit!
      endif
   endif
endfunction
            

function! CloseWindow()
    " https://stackoverflow.com/questions/7069927/in-vimscript-how-to-test-if-a-window-is-the-last-window
    " if this window isn't the last on screen, just quit pane
    if winbufnr(2) != -1
        quit
    " then we look at tabs
    elseif tabpagenr() != 1
        tabclose
    " if the amount of open buffers is still more then 1, close buffer
    elseif len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
        bd!
    " otherwise, close without warning
    else
        quit!
    endif
endfunction


" Ctrl - S => Write / Save
nnoremap <C-s> :write!<CR>
inoremap <C-s> <C-\><C-o>:write!<CR>
vnoremap <C-s> <Esc>:write!<CR>gv

" Ctrl - Q => Quit
nnoremap <silent><C-q> :call CloseWindow()<Enter>
inoremap <silent><C-q> <Esc>:call CloseWindow()<CR>
vnoremap <silent><C-q> <Esc>:call CloseWindow()<CR>

" Ctrl - R is -> Redo (universal) :
nnoremap <C-r> :redo<CR>
inoremap <C-r> <C-\><C-o>:redo<CR>
vnoremap <C-r> <Esc>:redo<CR>gv 

" Ctrl - Z is -> Undo instead of stop 
nnoremap <C-z> u
inoremap <C-z> <C-\><C-o>:u<CR>
vnoremap <C-z> u 

" Ctrl - E is -> Set to edit file in buffer  
nnoremap <C-e> :e 
inoremap <C-e> <C-\><C-o>:e 
vnoremap <C-e> y:e<C-r>"

" - Open current directory using netrw (or alternative)
if !has('nvim')
    nnoremap <silent><A-e> :e ./<CR>
    inoremap <silent><A-e> <C-\><C-o>:e ./<CR>
else
    nnoremap <silent><A-e> :lua require('mini.files').open() <CR>
    inoremap <silent><A-e> <C-\><C-o>:lua require('mini.files').open() <CR>
endif

"if exists(':Telescope')
"    nnoremap <silent><C-e> :Telescope find_files no_ignore=true prompt_prefix=🔍<cr>
"    inoremap <silent><C-e> <C-\><C-o>:Telescope find_files no_ignore=true prompt_prefix=🔍<cr>
"    vnoremap <silent><C-e> y<Esc>:Telescope find_files no_ignore=true prompt_prefix=🔍<CR>gv
"endif 

" t => : (open cmdline)
nnoremap t :
vnoremap t :

" T => : (open cmdline)
nnoremap T :! 
vnoremap T :! 

" Ctrl - T is -> :
"nnoremap <C-t> :tab sb 1<Cr>
"inoremap <C-t> <C-\><C-o>:tab sb 1<Cr>
"vnoremap <C-t> :tab sb 1<Cr>


" Leader (\) - m is -> markdown preview
nnoremap <leader>m :Glow<cr><esc>
inoremap <leader>m <C-\><C-o>:Glow<cr><esc> 
vnoremap <leader>m :Glow<cr><esc>gv


" Visual mode remaps
vnoremap <space>   di  <Esc>hpgvl 
vnoremap [         di[]<Esc>hpgvl 
vnoremap {         di{}<Esc>hpgvl 
vnoremap (         di()<Esc>hpgvl 
vnoremap <         di<><Esc>hpgvl
vnoremap `         di``<Esc>hpgvl
vnoremap '         di''<Esc>hpgvl


" Easy multiblock commenting
vnoremap <expr> #   (visualmode() == "\<C-V>" ? ':norm i#<cr>gv' : 'c##<Esc>hpgv')
vnoremap <expr> //   (visualmode() == "\<C-V>" ? ':norm i//<cr>gv' : 'c/*<enter><esc>pi<enter>*/<enter><esc>gv')
vnoremap <expr> --   (visualmode() == "\<C-V>" ? ':norm i--<cr>gv' : 'c--[[<enter><esc>pi<enter>--]]<enter><Esc>gv')
vnoremap <expr> "   (visualmode() == "\<C-V>" ? ':norm "<cr>gv' : 'c""<Esc>hpgv')
vnoremap <expr> '   (visualmode() == "\<C-V>" ? ":norm i'<cr>gv" : "c''<Esc>hpgv")
vnoremap <expr> !   (visualmode() == "\<C-V>" ? ':norm i#<cr>gv' : 'c!!<Esc>hpgv')

" Moving up and down will always recenter 
" Move up/down 1 paragraph => Ctrl+Arrowkeys (Up-Down)
" Move up/down full page => Shift+Arrowkeys (default)
" Move to top/bottom => Ctrl+Shift+Arrowkeys
" Same for Ctrlk jk

"nnoremap <C-y> <C-y>
"nnoremap <C-e> <C-e>

" Moving up/down doesn't skip moving through wrapped lines (soft lines)
nnoremap <expr> <Up> (getline(".")[col(".")-1] != ""  ? 'g<Up>' : '<Up>')
nnoremap <expr> <Down> (getline(".")[col(".")-1] != "" ? 'g<Down>' : '<Down>')
nnoremap <expr> k (getline(".")[col(".")-1] != "" ? 'gk' : 'k')
nnoremap <expr> j (getline(".")[col(".")-1] != "" ? 'gj' : 'j')
inoremap <expr> <Up> (getline(".")[col(".")-1] != "" ? '<C-o>g<Up>' : '<Up>')
inoremap <expr> <Down> (getline(".")[col(".")-1] != "" ? '<C-o>g<Down>' : '<Down>')
vnoremap <expr> <Up> (getline(".")[col(".")-1] != "" ? 'g<Up>' : '<Up>')
vnoremap <expr> <Down> (getline(".")[col(".")-1] != "" ? 'g<Down>' : '<Down>')
vnoremap <expr> k (getline(".")[col(".")-1] != "" ? 'gk' : 'k')
vnoremap <expr> j (getline(".")[col(".")-1] != "" ? 'gj' : 'j')



nnoremap    <C-Up> {
"nnoremap    <C-K> {
nnoremap    <C-Down> }
"nnoremap    <C-J> }
inoremap    <C-Up> <C-\><C-o>{<C-\><C-o>
"inoremap    <C-K> <C-\><C-o>{<C-\><C-o>
inoremap    <C-Down> <C-\><C-o>}<C-\><C-o>
"inoremap    <C-J> <C-\><C-o>}<C-\><C-o>
vnoremap    <C-Up> {
vnoremap    <C-Down> }
"vnoremap    <C-J> }
"vnoremap    <C-K> }


" Both K and Ctrl Shift K go one page up in normal mode
"nnoremap    <S-Up>      <PageUp>
"nnoremap    K           <S-Up>
"nnoremap    <C-S-K>     <S-Up>
"nnoremap    <S-Down>    <S-Down>
"nnoremap    J           <S-Down>
"nnoremap    <C-S-J>     <S-Down>
"inoremap    <S-Up>      <S-Up><C-o>
"inoremap    <S-Down>    <S-Down><C-o>
"inoremap    <C-S-J>     <S-Down><C-o>
"inoremap    <C-S-K>     <S-Up><C-o>
"vnoremap    <S-Up>      <S-Up>gv
"vnoremap    <S-Down>    <C-d>gv
"vnoremap    <C-S-J>     <S-J>gv
"vnoremap    <C-S-K>     <S-K>gv

" https://vim.fandom.com/wiki/Moving_lines_up_or_down#Mappings%20to%20move%20lines
" Move lines while holding Alt
" Multiple lines => select in visual mode
nnoremap    <A-Down> :m .+1<CR>
nnoremap    <A-Up>   :m .-2<CR>
inoremap    <A-Down> <Esc>:m .+1<CR>a
inoremap    <A-Up>   <Esc>:m .-2<CR>a
vnoremap    <A-Down> :m '>+1<CR>gv
vnoremap    <A-Up>   :m '<-2<CR>gv

nnoremap    <A-J> :m .+1<CR>
nnoremap    <A-K>   :m .-2<CR>
inoremap    <A-J> <Esc>:m .+1<CR>a
inoremap    <A-K>   <Esc>:m .-2<CR>a
vnoremap    <A-J> :m '>+1<CR>gv
vnoremap    <A-K>   :m '<-2<CR>gv

" Move one 'word' Left/Right (cursor at end) => Ctrl+Left/Right
" Move one space seperated word (cursor at end) => Shift+Left/Right
" Move to beginning/end / cycle lines => Alt+Left/Right
nnoremap <C-Left>   Bh
"nnoremap <S-Left>   B
nnoremap <C-Right>  El
"nnoremap <S-Right>  E
inoremap <C-Left>   <C-\><C-o>B<C-\><C-o>h
"inoremap <S-Left>   <C-\><C-o>B
inoremap <C-Right>  <C-\><C-o>E<C-\><C-o>l
"inoremap <S-Right>  <C-\><C-o>E
vnoremap <C-Left>   Bh
"vnoremap <S-Left>   B
vnoremap <C-Right>  El
"vnoremap <S-Right>  E


" 0 => beginning of 'column'
" ^ => First non blank character in line
" nnoremap <A-Right> 0

" If at beginning already, go to beginning previous line
" Else, go up
" Same for End of line, only you go down

function! LastCheck()
    if col(".") == col("$") || col('$') == 1 
        return 1
    else
        return 0
    endif
endfunction 

nnoremap <expr> <A-Left>    (col(".") ==? 1 ? '<Up>0' : '0')
nnoremap <expr> <A-right>   LastCheck() ? '<Down>$<Right>' : '$<Right>'
inoremap <expr> <A-Left>    (col('.') ==? 1 ? '<Up><C-\><C-o>0' : '<C-\><C-o>0')
inoremap <expr> <A-Right>   LastCheck() ? '<C-o><Down><C-\><C-o>$<Right>' : '<C-\><C-o>$<Right>'
vnoremap <expr> <A-Left>    (col(".") ==? 1 ? '<Up>0' : '0')
vnoremap <expr> <A-Right>   LastCheck() ? '<Down>$<Right>' : '$<Right>'

" Space for normal mode"
nnoremap <space> i<space><esc><Right>

" Delete for normal mode
nnoremap <Delete> i<Delete><Esc>

" Enter -> newline without entering insert mode
nnoremap <Enter> i<Enter><Esc>

" Ctrl-enter -> Start at a new line 
nnoremap <C-Enter>      o<esc>
inoremap <C-Enter>      <Esc>o
vnoremap <C-Enter>      o<esc><enter>gv

" Alt-enter -> Insert line at current lineposition 
nnoremap <A-Enter>      0i<enter><up><esc>
inoremap <A-Enter>      <Esc>0i<enter>
vnoremap <A-Enter>      <Esc>`<i<Enter><Esc>gv


" BackSpace -> backspace no leave normal mode
nnoremap <expr><BackSpace>    (col(".") ==? 1 ? 'i<BackSpace><esc>' : '"_dh')
inoremap <expr> <Backspace>    (mode() ==# 'R' && col('.') ==? 1 ? '<esc>"_dhR' : mode() ==# 'R' ? '<esc>"_dhR' : '<BackSpace>')
vnoremap <Backspace>   "_d
" Ctrl-Backspace => Delete appended 'word'
" Alt-BackSpace => Delete line 
" Shift-Backspace => Delete stuff forwards
nnoremap <expr> <C-Backspace>  (col(".") ==? 1 ? '<BackSpace>' : 'h"_dge')
inoremap <expr> <C-Backspace>  (col(".") ==? 1 ? '<BackSpace>' : '<esc>"_dgei')
nnoremap <A-Backspace>      "_dd<Up>$
inoremap <A-Backspace>      <Esc>"_dd<Up>$a


" ctrl-a  n  ctrl-a	add n to the number at or after the cursor
" ctrl-x  n  ctrl-x	subtract n from the number at or after the cursor
" mapping them to + and  - 
nnoremap + <C-a>
nnoremap - <C-x>
vnoremap + <C-a>gv
vnoremap - <C-x>gv
inoremap <A-+> <C-a>
inoremap <A--> <C-x>
"879++++++++++++++++++++++124

" Swap case insert
nnoremap ² ~

"nnoremap <C-²> ~
"inoremap <C-²> <Esc>~a

" Toggle highlight => Ctrl+l
" https://stackoverflow.com/questions/9054780/how-to-toggle-vims-search-highlight-visibility-without-disabling-it
let hlstate=0
nnoremap <silent> <C-l> :if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<cr>
inoremap <silent> <C-l> <C-\><C-o>:if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<cr>
vnoremap <silent> <C-l> <Esc>:if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<cr>gv

" Set backspace key to
set t_kb=^?
" Set Delete key to
set t_kD=^[[3~


nnoremap / /\c
vnoremap / y/\c<C-r>0

" Ctrl - f => Find
" Don't forget: Enter, not escape
"nnoremap <C-f> /
"inoremap <C-f> <Esc>/
"vnoremap <C-f> /

" Shift F backwards search mode
"nnoremap F ?

"Also Ctrl-Shift-F => Backward search
" But this conflicts with kitty 'move window forward'
"nnoremap <C-S-F> ?


" Ctrl - H => Find and replace
" For thos from visual code or smth, Ctrl-h can be finnicky in terminals
" Because that keycombo generates the exact keycode for Backspace, for
" compatibility reasons (but not in some terminal emulators, like kitty f.ex")

" Esc => Undo highlight
nnoremap <silent><Esc> :nohl<CR>
cnoremap <silent><Esc> <Esc>:nohl<CR>

" C-h => Local search and replace
nnoremap <C-h> :.,$s,,,gc<Left><Left><Left><Left>
inoremap <C-h> <C-\><C-o>:.,$s,,,gc<Left><Left><Left><Left>
vnoremap <C-h> y:.,$s,<C-r>",,gc<Left><Left><Left>
cnoremap <C-h> <C-e><C-u>nohl<CR>:<Esc>

" Alt-h => Global search and replace
nnoremap <M-h> :%s,,,gc<Left><Left><Left><Left>
inoremap <M-h> <C-\><C-o>:%s,,,gc<Left><Left><Left><Left>
vnoremap <M-h> y:%s,<C-r>",,gc<Left><Left><Left>
cnoremap <M-h> <C-e><C-u>nohl<CR>:<Esc>

if has('x11')
    nnoremap y "+^y
    nnoremap yy "+^yg_
    nnoremap Y "+^Y
    nnoremap YY "+^Yg_
    vnoremap y "+y
    "vnoremap yy "+^yg_
    vnoremap Y "+Y
    "vnoremap YY "+^Yg_
 
    nnoremap c "+y
    nnoremap cc "+0yg_
    nnoremap C "+Y
    nnoremap CC "+0Yg_
    vnoremap c "+y
    vnoremap cc "+0yg_
    vnoremap C "+Y
    vnoremap CC "+0Yg_

    nnoremap v "+p
    nnoremap V "+P
    vnoremap v "+p  
    vnoremap V "+P

    nnoremap p "+p
    nnoremap P o<esc>"+P
    vnoremap p "+p  
    vnoremap P o<esc>"+P
   
    " Copy entire line
    nnoremap <silent> <C-c> "+yy
    "nnoremap <silent> <C-c> <Plug>OSCYankOperator_
    "" Paste with P if at beginning of line
    nnoremap <silent> <C-v> "+P
    "inoremap <silent> <C-c>   <C-\><C-o>^<C-\><C-o><Plug>OSCYankOperator_
    nnoremap <C-d>  (col(".") ==? 1 ? '"+daw' : '"+diw') 
    
    inoremap <silent> <C-c> <C-\><C-o>^<C-\><C-o>"+yy
    inoremap <silent> <C-v> <C-\><C-o>"+P
    inoremap <expr> <C-d>   (col(".") ==? 1 ? '<C-\><C-o>"+daw' : '<C-\><C-o>"+diw')
     

    "vnoremap <silent> <C-c> <Plug>OSCYankVisual
    vnoremap <silent> <C-c> "+yy
    vnoremap <silent> <C-v> "+Pl
    vnoremap <C-d>  "+d 
 
else
    nnoremap y "*^y
    nnoremap yy "*^yg_
    nnoremap Y "*^Y
    nnoremap YY "*^Yg_
    vnoremap y "*y
    "vnoremap yy "+^yg_
    vnoremap Y "*Y
    "vnoremap YY "+^Yg_

    nnoremap c "*y
    nnoremap cc "*0yg_
    nnoremap C "*Y
    nnoremap CC "*0Yg_
    vnoremap c "*y
    vnoremap cc "*0yg_
    vnoremap C "*Y
    vnoremap CC "*0Yg_

    nnoremap v "*p
    nnoremap V "*P
    vnoremap v "*p  
    vnoremap V "*P

    nnoremap p "*p
    nnoremap P o<esc>"*P
    vnoremap p "*p  
    vnoremap P o<esc>"*P
    
     " Copy entire line
    nnoremap <silent> <C-c> "*yy
    "nnoremap <silent> <C-c> <Plug>OSCYankOperator_
    
    "" Paste with P if at beginning of line
    nnoremap <silent> <C-v> "*P
    "inoremap <silent> <C-c>   <C-\><C-o>^<C-\><C-o><Plug>OSCYankOperator_
    
    "nnoremap <C-c>  "+^yg_ 
    nnoremap <C-d>  (col(".") ==? 1 ? '"*daw' : '"*diw') 

    inoremap <silent> <C-c> <C-\><C-o>^<C-\><C-o>"*yy
    inoremap <silent> <C-v> <C-\><C-o>"*P
    "" Cut with a word instead of inner word if at beginning of line
    inoremap <expr> <C-d>   (col(".") ==? 1 ? '<C-\><C-o>"*daw' : '<C-\><C-o>"*diw')
   

    "vnoremap <silent> <C-c> <Plug>OSCYankVisual
    vnoremap <silent> <C-c> "*yy
    vnoremap <silent> <C-v> "*Pl
    vnoremap <C-d>  "*d 
 
endif

nnoremap d "_d
nnoremap D "_D

vnoremap d "_c
vnoremap D "_C


nnoremap <A-d> cc
vnoremap <A-d> c
inoremap <A-d> <Esc>cc



""" Copy inner word except when on first line (copy a word)
"inoremap <expr> <C-c>   (col(".") ==? 1 ? '<C-\><C-o>"+yaw' : '<C-\><C-o>"+yiw')

"vnoremap <C-c>  "+y

"" Normal mode => whole line
"" Insert mode => word
"" visual => by selection
"" Best register no register
"" https://stackoverflow.com/questions/22598644/vim-copy-non-linewise-without-leading-or-trailing-spaces

if (!has('nvim') && !has('clipboard_working'))
    " In the event that the clipboard isn't working, it's quite likely that
    " the + and * registers will not be distinct from the unnamed register. In
    " this case, a:event.regname will always be '' (empty string). However, it
    " can be the case that `has('clipboard_working')` is false, yet `+` is
    " still distinct, so we want to check them all.
    let s:VimOSCYankPostRegisters = ['', '+', '*']
    function! s:VimOSCYankPostCallback(event)
        if a:event.operator == 'y' && index(s:VimOSCYankPostRegisters, a:event.regname) != -1
            call OSCYankRegister(a:event.regname)
        endif
    endfunction
    augroup VimOSCYankPost
        autocmd!
        autocmd TextYankPost * call s:VimOSCYankPostCallback(v:event)
    augroup END
endif


vnoremap w iW
vnoremap W aW


"cnoremap <C-c> <C-f>
"cnoremap <C-v> <C-r><C-o>"
