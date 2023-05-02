" Avoid error message lingering
"autocmd CursorHold      * echo mode(1)
"autocmd CursorHoldI     * echo mode(1)
autocmd CursorMoved     * set cul
autocmd CursorMovedI    * set cul
"autocmd InsertEnter     * set cul
"autocmd InsertLeave     * set nocul
autocmd BufEnter * call MyLastWindow()

" https://stackoverflow.com/questions/7069927/in-vimscript-how-to-test-if-a-window-is-the-last-window
function! MyLastWindow()
   if &buftype=="quickfix"
      " if this window is last on screen quit without warning
      if winbufnr(2) == -1
         quit!
      endif
   endif
endfunction


let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set runtimepath+=/usr/lib/jvm/java-17-openjdk/bin/java
call plug#begin()

"Vim plugins point to githubs wich is very nice and just fucking cool

"" Autocomplete plugin from git
"Plug 'ycm-core/YouCompleteMe'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Ranger integration
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'
let g:ranger_replace_netrw = 1
let g:ranger_map_keys = 0

"" Fuzzy finder plugin
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' 
"" Fuzzy finder preview   
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins' }

"" Git plugin
Plug 'tpope/vim-fugitive'
"
""vim-tmux-navigator, smart navigation between vim and tmux panes
"Plugin 'christoomey/vim-tmux-navigator'

"Sudo write
Plug 'tpope/vim-eunuch'
"
"" Self documenting vim wiki
Plug 'vimwiki/vimwiki'

"" Nice themey
Plug 'morhetz/gruvbox'

"" Nice status bar thingy
Plug 'vim-airline/vim-airline'

" Vim lua plugin
" Plugin 'svermeulen/vimpeccable'

"" All of your Plugins must be added before the following line
call plug#end()

 "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)


"" Gruvbox things
let g:gruvbox_italic=1
colorscheme gruvbox

if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

""" YouCompleteMe stuff

"let g:ycm_auto_hover =0
"let g:ycm_key_invoke_completion = '<C-Tab>'
"let g:ycm_key_list_stop_completion = ['<C-y>', '<Right>', '<Space>']
"let g:ycm_key_list_select_completion = ['<Tab>', '<Down>', '<C-j>']
"let g:ycm_key_list_previous_completion = ['<S-Tab>', '<Up>', '<C-k>']
"let g:ycm_enable_semantic_highlighting=1
"let g:ycm_enable_inlay_hints=1
"""let g:ycm_add_preview_to_completeopt = 1
"let g:ycm_update_diagnostics_in_insert_mode = 0
"""let g:ycm_echo_current_diagnostic = 'virtual-text'

"Add tab 
"nnoremap <tab>      i<tab><esc><right>
"Visual mode 
"vnoremap <tab>      >gv
"vnoremap <s-tab>    <gv

"nnoremap <C-Tab> i
"vnoremap <C-Tab> i
"inoremap <expr> <C-Tab> mode(1) == "ic" ?  '<Esc>a' : '<plug>(YCMComplete)'

"inoremap <Space> <C-y><Space>
"inoremap <Right> <C-y><Right>

 
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
xmap <Leader>f  <Plug>(coc-format-selected)
nmap <Leader>f  <Plug>(coc-format-selected)

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
nmap <>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <Leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <Leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <Leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <Leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <Leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <Leader>cl  <Plug>(coc-codelens-action)

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

" Remap <C-f> and <C-b> to scroll float windows/popups
"if has('nvim-0.4.0') || has('patch-8.2.0750')
"  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-Tab> <Plug>(coc-range-select)
xmap <silent> <C-Tab> <Plug>(coc-range-select)

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
nnoremap <silent><nowait> <Tab>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <Tab>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <Tab>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <Tab>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <Tab>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <Tab>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <Tab>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <Tab>p  :<C-u>CocListResume<CR>

"Ranger F2
nnoremap <F2>   :RangerWorkingDirectory<CR>
inoremap <F2>   <Esc>:RangerWorkingDirectory<CR>
vnoremap <F2>   <Esc>:RangerWorkingDirectory<CR>

" Git files F3
nnoremap <F3>   :Files /<CR>
inoremap <F3>   <Esc>:Files /<CR>
vnoremap <F3>   <Esc>:Files /<CR>

" Git files F4
nnoremap <F4>   :GFiles<CR>
inoremap <F4>   <Esc>:GFiles<CR>
vnoremap <F4>   <Esc>:GFiles<CR>

nnoremap <F6> :e $MYVIMRC<CR>
nnoremap <F5> :source $MYVIMRC<CR>
nmap <F7> [fzf-p]
xmap <F7> [fzf-p]

nnoremap <silent> [fzf-p]p     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> [fzf-p]b     :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> [fzf-p]o     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          [fzf-p]gr    "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" C-w => Write
nnoremap <C-w> :write!<CR>
inoremap <C-w> <C-\><C-o>:write!<CR>
vnoremap <C-w> <Esc>:write!<CR>gv

function! CloseWindow()
    " if this window is last on screen quit without warning
    if winbufnr(2) == -1
        quit!
    else
        close!
    endif
endfunction

" C-q => Quit
nnoremap <C-q> :call CloseWindow()<Enter>
inoremap <C-q> <Esc>:call CloseWindow()<CR>
vnoremap <C-q> <Esc>:call CloseWindow()<CR>

" Ctrl - r is -> Redo (universal) :
nnoremap <C-r> :redo<CR>
inoremap <C-r> <C-\><C-o>:redo<CR>a
vnoremap <C-r> <Esc>:redo<CR>gv 

 " Ctrl - z is -> undo instead of stop 
nnoremap <C-z> u
inoremap <C-z> <C-\><C-o>:u<CR>
vnoremap <C-z> u 




" Visual mode remaps

"inoremap [          []
vnoremap [          di[]<Esc><Left>p<Esc> 

"inoremap {          {}
vnoremap {          di{}<Esc><Left>p<Esc> 

"inoremap (          ()
vnoremap (          di()<Esc><Left>p<Esc> 

"inoremap <           <>
vnoremap >          >gv
vnoremap <          <gv
vnoremap <C-<>      di</><Esc><Left><Left>p<Esc>

vnoremap `          di``<Esc><Left>p<Esc>

"inoremap '          ' 
vnoremap '          di''<Esc><Left>p<Esc>

"inoremap "          ""
vnoremap <expr> "   visualmode() == "\<C-V>" ?  'I"<Esc>' : 'di""<Esc><Left>p<Esc>'
vnoremap <expr> #   visualmode() == "\<C-V>" ?  'I#<Esc>' : 'di##<Esc><Left>p<Esc>'

vnoremap <expr> !   visualmode() == "\<C-V>" ?  'I!<Esc>' : 'di!!<Esc><Left>p<Esc>'


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
nnoremap    <C-K> {
nnoremap    <C-Down> }
nnoremap    <C-J> }
inoremap    <C-Up> <C-\><C-o>{<C-\><C-o>
inoremap    <C-K> <C-\><C-o>{<C-\><C-o>
inoremap    <C-Down> <C-\><C-o>}<C-\><C-o>
inoremap    <C-J> <C-\><C-o>}<C-\><C-o>
vnoremap    <C-Up> {
vnoremap    <C-Down> {
vnoremap    <C-J> }
vnoremap    <C-K> }


" Both K and Ctrl Shift K go one page up in normal mode
nnoremap    <S-Up>      <PageUp>
nnoremap    K           <S-Up>
nnoremap    <C-S-K>     <S-Up>
nnoremap    <S-Down>    <S-Down>
nnoremap    J           <S-Down>
nnoremap    <C-S-J>     <S-Down>
inoremap    <S-Up>      <S-Up><C-o>
inoremap    <S-Down>    <S-Down><C-o>
inoremap    <C-S-J>     <S-Down><C-o>
inoremap    <C-S-K>     <S-Up><C-o>
vnoremap    <S-Up>      <S-Up>gv
vnoremap    <S-Down>    <C-d>gv
vnoremap    <C-S-J>     <S-J>gv
vnoremap    <C-S-K>     <S-K>gv

nnoremap    <C-S-Up>    1G
nnoremap    <C-S-Down>  G
inoremap    <C-S-Up>    <C-o>1Gi
inoremap    <C-S-Down>  <C-o>Gi
vnoremap    <C-S-Up>    1G
vnoremap    <C-S-Down>  G

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
nnoremap <C-Right>  e
nnoremap <S-Right>  E
nnoremap <C-Left>   b
nnoremap <S-Left>   B
inoremap <C-Right>  <C-\><C-o>e
inoremap <S-Right>  <C-\><C-o>E
inoremap <C-Left>   <C-\><C-o>b
inoremap <S-Left>   <C-\><C-o>B
vnoremap <C-Right>  e
vnoremap <S-Right>  E
vnoremap <C-Left>   b
vnoremap <S-Left>   B


" 0 => beginning of 'column'
" ^ => First non blank character in line
" nnoremap <A-Right> 0

" If at beginning already, go to beginning previous line
" Else, go up
" Same for End of line, only you go down

function! LastCheck()
    if col(".") == col("$")-1 || col('$') == 1
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
nnoremap <expr> <A-right>   LastCheck() ? '<Down>$' : '$' 
inoremap <expr> <A-Left>    (col('.') ==? 1 ? '<Up><C-\><C-o>0' : '<C-\><C-o>0')
inoremap <expr> <A-Right>   LastCheckI() ? '<C-o><Down><C-\><C-o>$' : '<C-\><C-o>$'
vnoremap <expr> <A-Left>    (col(".") ==? 1 ? '<Up>0' : '0')
vnoremap <expr> <A-Right>   LastCheck() ? '<Down>$' : '$'

" Space for normal mode"
nnoremap <space>    i<space><esc><Right>

" Delete for normal mode
nnoremap <Delete> i<Delete><Esc>

" enter -> newline without entering insert mode
nnoremap <Enter> i<Enter><Esc>
"nnoremap <Enter> mode()
" ctrl enter => move current line down
nnoremap <C-Enter>      0i<enter><up><esc>
inoremap <C-Enter>      <Esc>0i<enter>
vnoremap <C-Enter>      <Esc>`<i<Enter><Esc>gv
"alt enter -> newline without entering insert mode

nnoremap <A-Enter>      o<esc>
inoremap <A-Enter>      <Esc>o
vnoremap <A-Enter>      o<esc><enter>gv


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
nnoremap <C-²> ~
inoremap <C-²> <Esc>~a


 


" Toggle highlight => Ctrl+l
" https://stackoverflow.com/questions/9054780/how-to-toggle-vims-search-highlight-visibility-without-disabling-it
let hlstate=0
nnoremap <silent> <C-l> :if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<cr>
inoremap <silent> <C-l> <C-\><C-o>:if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<cr>
vnoremap <silent> <C-l> <Esc>:if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<cr>gv

"let mapleader = "\<Space>"
" Set backspace key to
set t_kb=^?
" Set Delete key to
set t_kD=^[[3~

" Ctrl - H => Find and replace
" For thos from visual code or smth, Ctrl-h can be finnicky in terminals
" Because that keycombo generates the exact keycode for Backspace, for
" compatibility reasons (but not in some terminal emulators, like kitty f.ex")
 
" Ctrl - f => Find
" Don't forget: Enter, not escape
nnoremap f /
nnoremap <C-f> /
inoremap <C-f> <Esc>/
vnoremap <C-f> /

" Shift F backwards search mode
nnoremap F ?

"Also Ctrl-Shift-F => Backward search
" But this conflicts with kitty 'move window forward'
"nnoremap <C-S-F> ?

"nnoremap <ESC>[70;5u ?
"inoremap <ESC>[70;5u <Esc>?
"vnoremap <ESC>[70;5u ?

" Alt-f => Global search
nnoremap <A-f> :%s,,,gc<Left><Left><Left><Left>
inoremap <A-f> <C-\><C-o>:%s,,,gc<Left><Left><Left><Left>
vnoremap <A-f> <esc>:%s,\%V,,gc<Left><Left><Left>
cnoremap <A-f> <C-e><C-u>nohl<CR>:<Esc>
" Different seperator for Alt+Shift
nnoremap <M-S-F> :%s///gc<Left><Left><Left><Left>
inoremap <M-S-F> <C-\><C-o>:%s///gc<Left><Left><Left><Left>
vnoremap <M-S-F> <esc>:%s/\%V//gc<Left><Left><Left>
cnoremap <M-S-F> <C-e><C-u>nohl<CR>:<Esc>

" unnamedplus	A variant of the "unnamed" flag which uses the
" clipboard register "+" (quoteplus) instead of
" register "*" for all yank, delete, change and put
" operations which would normally go to the unnamed
" register.
" Normal clipboard functionality for yy, y and d

set clipboard+=unnamedplus
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

nnoremap <A-d> cc
vnoremap <A-d> c
inoremap <A-d> <Esc>cc

"" Normal mode => whole line
"" Insert mode => word
"" visual => by selection
"" Best register no register
"" https://stackoverflow.com/questions/22598644/vim-copy-non-linewise-without-leading-or-trailing-spaces
nnoremap <C-c>  "+^yg_ 
nnoremap <silent> <C-v> "+P
nnoremap <C-d>  (col(".") ==? 1 ? '<C-\><C-o>daw' : '<C-\><C-o>diw')
""" Copy inner word except when on first line (copy a word)
inoremap <expr> <C-c>   (col(".") ==? 1 ? '<C-\><C-o>"+yaw' : '<C-\><C-o>"+yiw')
"" Paste with P if at beginning of line
inoremap <silent> <C-v> <C-\><C-o>"+P
"" Cut with a word instead of inner word if at beginning of line
inoremap <expr> <C-d>   (col(".") ==? 1 ? '<C-\><C-o>daw' : '<C-\><C-o>diw')
vnoremap <C-c>  "+y 
vnoremap <silent> <C-v> "+P
vnoremap <C-d>  "*d 
"tnoremap <C-c>  <C-\><C-N>
"tnoremap <C-v>  <C-W>"+


nnoremap <C-S-d>    <Down>"*dd<Up>
inoremap <expr> <C-S-d> (col(".") ==? 1 ? '<C-\><C-o>daW' : '<C-\><C-o>diW')
vnoremap <C-S-d>    "*D

" a => (insert) Append after cursor
" A => Insert before
"
" Ctrl-A normal => insert
" Ctrl-A visual => Chang$e selected line
" Ctrl-A Insert => Back to normal
nnoremap <C-a> a
vnoremap <C-a> <C-o>
inoremap <C-a> <Esc>
""Alt-A => Replace (insert variant)
nnoremap <A-a> R
vnoremap <A-a> R
inoremap <A-a> <Esc>
"" Ctrl-Alt-A => Virtual Replace mode                    
"" This mode differs from replace in that it plays nicely with tabs and spaces
"" in files
nnoremap <C-A-a> gR
vnoremap <C-A-a> <Esc>gR 
inoremap <C-A-a> <Esc>

"" Visual mode becomes 'Select' mode or smth idk
"" S => visual mode
nnoremap s v
vnoremap s v
nnoremap S V
vnoremap S V
""" Ctrl-s => Visual mode everywhere
nnoremap <C-S> v
vnoremap <C-s> <Esc>
inoremap <C-S> <C-o>v

"""Different visual block mode
set virtualedit=all
"""Alt-s => Visual block mode
nnoremap <A-s> <C-q>
vnoremap <A-s> <C-q> 
inoremap <A-s> <C-o><C-q>
"""Ctrl-Alt-S => Visual line mode
nnoremap <C-A-S> V
vnoremap <C-A-S> <Esc> 
inoremap <C-A-S> <C-o>V


"function! MyFunc()
"    let m = visualmode()
"    if m == "\<C-V>"
"        echo 'block-wise visual'
"    endif
"endfunction


"" vim tmux navigator integrator
"let g:tmux_navigator_no_mappings = 1
"noremap <silent> <C-S-Left> :<C-U>TmuxNavigateLeft<cr>
"noremap <silent> <C-S-Down> :<C-U>TmuxNavigateDown<cr>
"noremap <silent> <C-S-Up> :<C-U>TmuxNavigateUp<cr>
"noremap <silent> <C-S-Right> :<C-U>TmuxNavigateRight<cr>
"noremap <silent> <C-²> :<C-U>TmuxNavigatePrevious<cr>

"highlight Visual cterm=reverse ctermbg=NONE
" These options and commands enable some very useful features in Vim, that
" no user should live without
" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc

"If you set scrollof to a very large value (999) the cursor line will always be at the middle 
 set scrolloff=999

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

"lua <<EOF
"    vim.o.rtp += ~/.vim/bundle/Vundle.vim
"    local Plug = vim.fn['plug#']
"    vim.call('vundle#begin', '~/.config/nvim/plugged')
"    Plug('tpope/vim-sensible')
"    Plug('christoomey/vim-tmux-navigator') 
"    Plug('vimwiki/vimwiki') 
"    Plug('svermeulen/vimpeccable') 
"    vim.call('vundle#end')
"EOF

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


"vim.cmd 'packadd paq-nvim'
"require 'paq' {
"    {'savq/paq-nvim', opt = true};
"    'svermeulen/vimpeccable'
"}
"lua <<EOF
"    local vimp = require('vimpeccable')
"    vimp.bind('n', '<C-Tab>', 'i<C-X>')
"    vimp.bind('n', '<C-cr>', ':echom 'Hello C + R'<CR>')
"EOF
