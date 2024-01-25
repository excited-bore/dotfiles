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

" Relative number lines
set relativenumber 

" Enable Omnicomplete features
set omnifunc=syntaxcomplete#Complete

"https://vim.fandom.com/wiki/GNU/Linux_clipboard_copy/paste_with_xclip
"The 'a' and 'A' options enables copying selected text to system clipboard 
set guioptions=aAimrLT

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

"Always wrap long lines
set wrap

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
set virtualedit=all    

" COC settings 

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

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

"Tmux has problems with nvim colors if we dont supply it with true colors
"https://unix.stackexchange.com/questions/251847/clear-to-end-of-line-uses-the-wrong-background-color-in-tmux/252078#252078
if (has("termguicolors"))
    set termguicolors
endif 


"Fix python3 interpreter
let g:python3_host_prog = '/usr/bin/python3'
let g:ycm_path_to_python_interpreter = '/usr/bin/python3'
                                                             

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

let g:pluginInstallPath=expand('~/.vim/plugins')
source $HOME/.config/nvim/plug_lazy_adapter.vim

if !has('nvim')
    call plug#begin(g:pluginInstallPath)
endif
"call plug#begin(g:pluginInstallPath)
"Vim plugins point to githubs wich is very nice and just fucking cool

" Autocomplete engine (Conquer of completions)
"https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
            \'coc-html',
            \'coc-css',
            \'coc-tsserver',
            \'coc-json',
            \'coc-clangd',
            \'coc-clang-format-style-options',
            \'coc-cmake',
            \'coc-python',
            \'coc-sh',
            \'coc-fzf-preview',
            \'coc-git',
            \'coc-vimlsp',
            \'coc-webview',
            \'coc-markdown-preview-enhanced'
            \]

" Totally independent OS52 clipboard
Plugin 'ojroques/vim-oscyank', {'branch': 'main'}

" Devicons
Plugin 'ryanoasis/vim-devicons'

" Ranger integration
Plugin 'francoiscabrol/ranger.vim'
Plugin 'rbgrouleff/bclose.vim'
let g:ranger_replace_netrw = 1
let g:ranger_map_keys = 0
let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'

"" Fuzzy finder plugin
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim' 

"" Fuzzy finder preview   
Plugin 'yuki-yano/fzf-preview.vim', { 'branch': 'release/remote' }

"" Plugin for git
Plugin 'tpope/vim-fugitive'

"vim-tmux-navigator, smart navigation between vim and tmux panes
Plugin 'christoomey/vim-tmux-navigator'

" Sudo write
Plugin 'tpope/vim-eunuch'
Plugin 'lambdalisue/suda.vim'
let g:suda_smart_edit = 1

" Give passwords prompts in vim
"Plugin 'lambdalisue/askpass.vim'
" Dependency for askpass, Deno
"Plugin 'vim-denops/denops.vim'

" Nerd commenter
Plugin 'preservim/nerdcommenter'

"vim-kitty-navigator, Same thing for panes but with vim and kitty
"Plugin 'knubie/vim-kitty-navigator'
function! AfterLoadKittyVim()
    call system('(cd ~/.vim/plugins/vim-kitty-navigator && cp -f ./*.py ~/.config/kitty/)')
endf

"Plugin 'NikoKS/kitty-vim-tmux-navigator', { 'build': 'cd ~/.vim/plugins/kitty-vim-tmux-navigator && cp -f ./*.py ~/.config/kitty/'}


Plugin 'excited-bore/vim-tmux-kitty-navigator', { 'build' : 'cd ~/.vim/plugins/vim-tmux-kitty-navigator && cp -f ./pass_keys.py ~/.config/kitty/;'}

" Minimap to keep track of where in file
Plugin 'wfxr/minimap.vim'
let g:minimap_width = 10
let g:minimap_highlight_range = 1
let g:minimap_enable_highlight_colorgroup = 1
"let g:minimap_auto_start = 1
let g:minimap_git_colors = 1
let g:minimap_auto_start_win_enter = 1

" Self documenting vim wiki
Plugin 'vimwiki/vimwiki'

" Nice and cool themey
Plugin 'morhetz/gruvbox'

" Nice and cool status bar thingy
Plugin 'vim-airline/vim-airline'

" Vim lua plugin
" Plugin 'svermeulen/vimpeccable'

"" All of your Plugins must be added before the following line
if !has('nvim')
    call plug#end()
else
    source $HOME/.config/nvim/init.lua.vim
    lua require("lazy")
endif
"call plug#end()

 "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)

" Ranger

"" Gruvbox things
let g:gruvbox_italic=1
colorscheme gruvbox

"Add tab 
nnoremap <Tab>   i<tab><esc><right>
"Visual mode 
vnoremap <Tab>   >gv
vnoremap <S-Tab> <gv 


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
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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

"Ranger F2
nnoremap <silent><F2>   :RangerWorkingDirectory<CR>
inoremap <silent><F2>   <Esc>:RangerWorkingDirectory<CR>
vnoremap <silent><F2>   <Esc>:RangerWorkingDirectory<CR>

" Git files F3
nnoremap <F3>   :FzfPreviewGitActions<CR>
inoremap <F3>   <Esc>:FzfPreviewGitActions<CR>a
vnoremap <F3>   :FzfPreviewGitActions<CR>gv

" Git status F4
nnoremap <F4>   :FzfPreviewChanges<CR>
inoremap <F4>   <Esc>:FzfPreviewChanges<CR>a
vnoremap <F4>   :FzfPreviewChanges<CR>gv

" Reload .vimrc/init.vim F5
nnoremap <F5> :source $MYVIMRC<CR>
inoremap <F5> <esc>:source $MYVIMRC<CR>a
vnoremap <F5> :source $MYVIMRC<CR>gv

" Edit .vimrc/init.vim F6
nnoremap <F6> :e $MYVIMRC<CR>
inoremap <F6> <esc>:e $MYVIMRC<CR>a
vnoremap <F6> :e $MYVIMRC<CR>gv

" Checkout Files in current dir F7
nnoremap <F7> :FzfPreviewDirectoryFiles<CR>
inoremap <F7> <esc>:FzfPreviewDirectoryFiles<CR>a
vnoremap <F7> :FzfPreviewDirectoryFiles<CR>gv

" Checkout Git Files in current dir F7
nnoremap <S-F7> :FzfPreviewGitFiles<CR>
inoremap <S-F7> <esc>:FzfPreviewGitFiles<CR>a
vnoremap <S-F7> :FzfPreviewGitFiles<CR>gv 


" Leader key Fzf-Preview F7
nmap <leader>f [fzf-p]
xmap <leader>f [fzf-p]

nnoremap <silent> [fzf-p]p     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> [fzf-p]b     :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> [fzf-p]o     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-r> :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          [fzf-p]gr    "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>



"Buffers and panes

"List buffers
nnoremap <silent><C-w>b :<C-u>CocCommand fzf-preview.AllBuffers<CR> 
inoremap <silent><C-w>b <C-\><C-o><C-u>CocCommand fzf-preview.AllBuffers<CR>
vnoremap <silent><C-w>b <esc>:<C-u>CocCommand fzf-preview.AllBuffers<CR>gv

" Open next buffer
nnoremap <silent><C-A-Right> :bNext<cr>
inoremap <silent><C-A-Right> <C-\><C-o>:bNext<cr>
vnoremap <silent><C-A-Right> <esc>:bNext<cr>

" Open previous buffer
nnoremap <silent><C-A-Left> :bprevious<cr>
inoremap <silent><C-A-Left> <C-\><C-o>:bprevious<cr>
vnoremap <silent><C-A-Left> <esc>:bprevious<cr>

" Open Horizontal buffer
nnoremap <silent><C-w>h :split<cr>
inoremap <silent><C-w>h <C-\><C-o>:split<cr>
vnoremap <silent><C-w>h <esc>:split<cr>gv

"" Open Vertical buffer
"nnoremap <S-A-Down> :vertical sb
"inoremap <S-A-Down> <C-\><C-o>:vertical sb
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

"function! TmuxKittyNavigate(direction)
"    if empty($TMUX)  
"        execute "KittyNavigate" .. a:direction 
"    else
"         if a:direction == "Left"
"            let dir = "left"
"        elseif a:direction == "Right"
"            let dir = "right"
"        elseif a:direction == "Up"
"            let dir = "top"
"        elseif a:direction == "Down"
"            let dir = "bottom"
"        endif
"        let isLast = system('tmux display-message -p -F "#{pane_at_' .. dir .. '}"')
"        if isLast == 1
"            execute "KittyNavigate" .. a:direction
"        else
"            execute "TmuxNavigate" .. a:direction 
"        endif
"    endif
"endfunction
"command -nargs=+ TmuxKittyNavigate call TmuxKittyNavigate(<f-args>)


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
    " if this window isn't the last on screen, just close pane
    if winbufnr(2) != -1
         close!
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
inoremap <C-r> <C-\><C-o>:redo<CR>a
vnoremap <C-r> <Esc>:redo<CR>gv 

" Ctrl - Z is -> Undo instead of stop 
nnoremap <C-z> u
inoremap <C-z> <C-\><C-o>:u<CR>
vnoremap <C-z> u 

" Ctrl - E is -> Set to edit file in buffer  
nnoremap <C-e> :e ./
inoremap <C-e> <C-\><C-o>:e ./
vnoremap <C-e> :e ./

" t => : (open cmdline)
nnoremap t :
vnoremap t :

" T => : (open cmdline)
nnoremap T :terminal 
vnoremap T :terminal 

" Ctrl - T is -> :
nnoremap <C-t> :
inoremap <C-t> <C-\><C-o>:
vnoremap <C-t> : 

"Alt - M is -> Minimap 
nnoremap <silent><M-m> <esc>:MinimapToggle<CR>:MinimapUpdateHighlight<cr>
inoremap <silent><M-m> <C-\><C-o>:MinimapToggle<CR>:MinimapUpdateHighlight<cr>
vnoremap <silent><M-m> <esc>:MinimapToggle<CR>:MinimapUpdateHighlight<cr>

" Alt - C is -> CocCommand 
nnoremap <M-c> :CocCommand 
inoremap <M-c> <C-\><C-o>:CocCommand 
vnoremap <M-c> :CocCommand 

" Leader (\) - m is -> CocCommand markdown-preview-enhanced.openPreview
nnoremap <leader>m :CocCommand markdown-preview-enhanced.openPreview<cr>
inoremap <leader>m <C-\><C-o>:CocCommand markdown-preview-enhanced.openPreview<cr> 
vnoremap <leader>m :CocCommand markdown-preview-enhanced.openPreview<cr>gv


" Visual mode remaps
vnoremap [      di[]<Esc>hp<Esc> 
vnoremap {      di{}<Esc>hp<Esc> 
vnoremap (      di()<Esc>hp<Esc> 
vnoremap <      di<><Esc>hp<Esc>
vnoremap `      di``<Esc>hp<Esc>
vnoremap '      di''<Esc>hp<Esc>


" Easy multiblock commenting
vnoremap <expr> #   (visualmode() == "\<C-V>" ? ':norm i#<cr>gv' : 'c##<Esc>hp<Esc>')
vnoremap <expr> //   (visualmode() == "\<C-V>" ? ':norm i//<cr>gv' : 'c/*<enter><esc>pi<enter>*/<enter><Esc>')
vnoremap <expr> --   (visualmode() == "\<C-V>" ? ':norm i--<cr>gv' : 'c--[[<enter><esc>pi<enter>--]]<enter><Esc>')
vnoremap <expr> "   (visualmode() == "\<C-V>" ? ':norm "<cr>gv' : 'c""<Esc>hp<Esc>')
vnoremap <expr> '   (visualmode() == "\<C-V>" ? ":norm i'<cr>gv" : "c''<Esc>hp<Esc>")
vnoremap <expr> !   (visualmode() == "\<C-V>" ? ':norm i#<cr>gv' : 'c!!<Esc>hp<Esc>')

" Moving up and down will always recenter 
" Move up/down 1 paragraph => Ctrl+Arrowkeys (Up-Down)
" Move up/down full page => Shift+Arrowkeys (default)
" Move to top/bottom => Ctrl+Shift+Arrowkeys
" Same for Ctrlk jk

"nnoremap <C-y> <C-y>
"nnoremap <C-e> <C-e>
"
"nnoremap <Up>   <Up>
"nnoremap <Down> <Down>
"nnoremap j      j
"nnoremap k      k
"
"inoremap <expr> <Up> mode(1) == "ic" ?  '<Up>' : '<Up><C-o>' 
"inoremap <expr> <Down> mode(1) == "ic" ?  '<Down>' : '<Down><C-o>' 
"vnoremap <Up>   <Up>
"vnoremap <Down> <Down>

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
nnoremap    K           <S-Up>
nnoremap    <C-S-K>     <S-Up>
"nnoremap    <S-Down>    <S-Down>
nnoremap    J           <S-Down>
nnoremap    <C-S-J>     <S-Down>
"inoremap    <S-Up>      <S-Up><C-o>
"inoremap    <S-Down>    <S-Down><C-o>
inoremap    <C-S-J>     <S-Down><C-o>
inoremap    <C-S-K>     <S-Up><C-o>
"vnoremap    <S-Up>      <S-Up>gv
"vnoremap    <S-Down>    <C-d>gv
vnoremap    <C-S-J>     <S-J>gv
vnoremap    <C-S-K>     <S-K>gv

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
nnoremap <C-Right>  E
"nnoremap <S-Right>  E
nnoremap <C-Left>   B
"nnoremap <S-Left>   B
inoremap <C-Right>  <C-\><C-o>E
"inoremap <S-Right>  <C-\><C-o>E
inoremap <C-Left>   <C-\><C-o>B
"inoremap <S-Left>   <C-\><C-o>B
vnoremap <C-Right>  E
"vnoremap <S-Right>  E
vnoremap <C-Left>   B
"vnoremap <S-Left>   B


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

function! LastCheckI()
    if col(".") == col("$") || col('$') == 1 
        return 1
    else
        return 0
    endif
endfunction 

nnoremap <expr> <A-Left>    (col(".") ==? 1 ? '<Up>0' : '0')
nnoremap <expr> <A-right>   LastCheck() ? '<Down>$<Right>' : '$<Right>'
inoremap <expr> <A-Left>    (col('.') ==? 1 ? '<Up><C-\><C-o>0' : '<C-\><C-o>0')
inoremap <expr> <A-Right>   LastCheckI() ? '<C-o><Down><C-\><C-o>$<Right>' : '<C-\><C-o>$<Right>'
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
nnoremap <BackSpace>    i<BackSpace><right><esc>
inoremap <expr> <Backspace>    (mode() ==# 'R' && col('.') ==? 1 ? '<Esc>i<Backspace><Right><Esc>R' : mode() ==# 'R' ? '<Esc>a<BackSpace><Right><Esc>R' : '<BackSpace>')
vnoremap <Backspace>    <Delete>
" Ctrl-Backspace => Delete appended 'word'
" Alt-BackSpace => Delete line 
" Shift-Backspace => Delete stuff forwards
nnoremap <expr> <C-Backspace>  (col(".") ==? 1 ? '<BackSpace>' : 'dge')
inoremap <expr> <C-Backspace>  (col(".") ==? 1 ? '<BackSpace>' : '<Esc>dgei')
nnoremap <A-Backspace>      dd<Up>$
inoremap <A-Backspace>      <Esc>dd<Up>$a
nnoremap <C-S-backspace>      <Delete>
inoremap <C-S-backspace>      <Delete>


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

nnoremap <C-²> ~
inoremap <C-²> <Esc>~a

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

" Ctrl - f => Find
"Line search with Ripgrep 
nnoremap <silent><C-f> :FzfPreviewLines<cr>
inoremap <silent><C-f> <C-\><C-o>:FzfPreviewLines<cr>
vnoremap <silent><C-f> y<Esc>:FzfPreviewLines --add-fzf-arg=--query="<C-r>=expand('<cword>')<CR>"<CR>

" Ctrl-Shift-f => Find in all loaded buffer (even non-files(?))
"Line search in loaded buffer
nnoremap <silent><M-f> :FzfPreviewBufferLines<cr>
inoremap <silent><M-f> <C-\><C-o>:FzfPreviewBufferLines<cr>
vnoremap <silent><M-f> y<Esc>:FzfPreviewBufferLines --add-fzf-arg=--query="<C-r>=expand('<cword>')<CR>"<CR>

" Ctrl - H => Find and replace
" For thos from visual code or smth, Ctrl-h can be finnicky in terminals
" Because that keycombo generates the exact keycode for Backspace, for
" compatibility reasons (but not in some terminal emulators, like kitty f.ex")

" C-h => Global search
nnoremap <C-h> :%s,,,gc<Left><Left><Left><Left>
inoremap <C-h> <C-\><C-o>:%s,,,gc<Left><Left><Left><Left>
vnoremap <C-h> y:%s,<C-r>",,gc<Left><Left><Left>
cnoremap <C-h> <C-e><C-u>nohl<CR>:<Esc>

" Different seperator for Ctrl+Shift+h
nnoremap <M-h> :%s///gc<Left><Left><Left><Left>
inoremap <M-h> <C-\><C-o>:%s///gc<Left><Left><Left><Left>
vnoremap <M-h> y:%s/<C-r>"//gc<Left><Left><Left>
cnoremap <M-h> <C-e><C-u>nohl<CR>:<Esc>


nnoremap y "+^y
nnoremap yy "+^yg_
nnoremap Y "+^Y
nnoremap YY "+^Yg_
vnoremap y "+y
"vnoremap yy "+^yg_
vnoremap Y "+Y
"vnoremap YY "+^Yg_

vnoremap d c
vnoremap D C

nnoremap c "+y
nnoremap cc "0yg_
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

nnoremap <A-d> cc
vnoremap <A-d> c
inoremap <A-d> <Esc>cc

"" Normal mode => whole line
"" Insert mode => word
"" visual => by selection
"" Best register no register
"" https://stackoverflow.com/questions/22598644/vim-copy-non-linewise-without-leading-or-trailing-spaces

"nnoremap <C-c>  "+^yg_ 
nnoremap <silent><C-c> <Plug>OSCYankOperator_
nnoremap <silent><C-v> "+Pl
nnoremap <C-d>  (col(".") ==? 1 ? '<C-\><C-o>daw' : '<C-\><C-o>diw')

""" Copy inner word except when on first line (copy a word)
"inoremap <expr> <C-c>   (col(".") ==? 1 ? '<C-\><C-o>"+yaw' : '<C-\><C-o>"+yiw')
"" Copy entire line
inoremap <silent><C-c>   <C-\><C-o><Plug>OSCYankOperator_
"" Paste with P if at beginning of line
inoremap <silent> <C-v> <C-\><C-o>"+P
"" Cut with a word instead of inner word if at beginning of line
inoremap <expr> <C-d>   (col(".") ==? 1 ? '<C-\><C-o>daw' : '<C-\><C-o>diw')

"vnoremap <C-c>  "+y
vnoremap <C-c> <Plug>OSCYankVisual
vnoremap <silent> <C-v> "+Pl
vnoremap <C-d>  "*d 

cnoremap <C-c> <C-f>
cnoremap <C-v>  <C-r><C-o>"


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
