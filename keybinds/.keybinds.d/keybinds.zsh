#!/bin/zsh

# Bash_aliases at ~/.bash_aliases.d/
# global bashrc -> /etc/bash.bashrc
# root shell profiles -> /etc/profile

# https://stackoverflow.com/questions/8366450/complex-keybinding-in-bash

alias list-binds-zsh="bindkey -l"
alias list-binds-stty="stty -a"
alias list-binds-xterm="xrdb -query -all"
alias list-binds-kitty='kitty +kitten show_key -m kitty'

GREEN=$(tput setaf 2)
GREEN=$(tput setaf 2 && tput bold)
# reset
normal=$(tput sgr0)

if hash xfconf-query &> /dev/null; then
    function list-binds-xfce4(){
        local usedkeysp="$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | sed 's|/xfwm4/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' | sort -V)"
        local usedkeysp1="$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' | sort -V)" 
        
        (printf "${GREEN}Known ${CYAN}xfce4${GREEN} keybinds: \n${normal}"
        local var1; 
        for i in $(seq 2); do
            if [[ $i == 1 ]]; then
                var1=($(echo "$usedkeysp" | awk '{print $1}'))
                printf "\n${GREEN}Window Manager shortcuts: \n\n${normal}"
            else 
                usedkeysp=$usedkeysp1 
                var1=($(echo "$usedkeysp1" | awk '{print $1}'))
                printf "\n${GREEN}Application Shortcuts: \n\n${normal}"
            fi
            for i in $(seq $#var1); do
                printf "%-35s %-35s\n" "${green}${var1[$i]}" "${cyan}$(awk 'NR=='$((i+1))'{$1="";print;}' <<< $usedkeysp | sed 's/^ //')${normal}"; 
            done
        done) | $PAGER
    }
fi

# TTY

# To see the complete character string sent by a key, you can use this command, and type the key within 2 seconds:
# stty raw; sleep 2; echo; stty cooked
# But Ctrl-v, then keycombination still works best

# Turn off flow control and free up Ctrl-s and Ctrl-q
# We make sure that when this is being run in an interactive (and real) shell 
# since resourcing ~/.zshrc could mean this line was being rerun
if [[ $- == *i* ]] && tty -s; then
    stty -ixon
fi

# XRESOURCES

# Install bindings from xterm
# xrdb -merge ~/.Xresources
# .Inputrc (readline conf) however has to be compiled, so restart shell

[[ $machine == 'Linux' ]] && [[ -z $XDG_SESSION_TYPE ]] &&
    XDG_SESSION_TYPE="$(loginctl show-session $(loginctl | grep $(whoami) | awk 'NR=1{print $1}') -p Type | awk -F= 'NR==1{print $2}')"

if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then
    # Set caps to Escape
    setxkbmap -option caps:escape

    # Set Shift delete to backspace
    xmodmap -e "keycode 119 = Delete BackSpace"
fi

# READLINE

# \C : Ctrl
# \M : Meta (alt)
# \e : Escape (alt)
# \t : Tab
# \b : Backspace
# \n : newline
# nop => no operation, but 'redraw-current-line' might work better
# https://unix.stackexchange.com/questions/556703/how-to-bind-a-key-combination-to-null-in-inputrc
# 'bind -l' for all options
# 'bind -p' for all bindings
# You can also run 'read' (or 'cat' + Ctrl+v)
# That way you can read the characters escape sequences
# The ^[ indicates an escape character in your shell, so this means that your f.ex. Home key has an escape code of [1~ and you End key has an escape code of [4~. Since these escape codes are not listed in the default Readline configuration, you will need to add them: \e[1~ or \e[4~
# It's good to use unused keys for complex keybindings since you can't combine readline commands with regular bash expressions in the same bind
# Also
# https://unix.stackexchange.com/questions/548726/bash-readline-inputrc-bind-key-to-a-sequence-of-multiple-commands
#
#
# Change editing mode
#bindkey -M viins '"\C-a": emacs-editing-mode'
#bindkey -M vicmd '"\C-a": emacs-editing-mode'
#bindkey -M emacs '"\C-a": vi-editing-mode'

# Shift-select
# https://github.com/jirutka/zsh-shift-select

# Move cursor to the end of the buffer.
# This is an alternative to builtin end-of-buffer-or-history.
function end-of-buffer() {
    CURSOR=${#BUFFER}
    zle end-of-line -w  # trigger syntax highlighting redraw
}
zle -N end-of-buffer

# Move cursor to the beginning of the buffer.
# This is an alternative to builtin beginning-of-buffer-or-history.
function beginning-of-buffer() {
    CURSOR=0
    zle beginning-of-line -w  # trigger syntax highlighting redraw
}
zle -N beginning-of-buffer

# Kill the selected region and switch back to the main keymap.
function shift-select::kill-region() {
    zle kill-region -w
    zle -K main
}
zle -N shift-select::kill-region

function move-region() {
    local len word prevc nextc linelen="${#BUFFER}"
    if [[ $CURSOR -lt $MARK ]]; then
        len=$(( $MARK - $CURSOR )) 
        word="${BUFFER:$CURSOR:$len}"
        if [[ $1 == 'left' ]]; then
            if [[ $CURSOR != 0 ]]; then
                prevc="${BUFFER:$(($CURSOR-1)):1}"
                BUFFER="${BUFFER:0:$(($CURSOR-1))}$word$prevc${BUFFER:$MARK}"
                CURSOR=$((CURSOR-1))
                MARK=$((MARK-1))
            else 
                BUFFER="${BUFFER:${#word}}$word"
                CURSOR=$((${#BUFFER}-${#word}))
                MARK=${#BUFFER}
            fi
        elif [[ $1 == 'right' ]]; then
            if [[ $MARK != $linelen ]]; then
                nextc="${BUFFER:$MARK:1}"
                BUFFER="${BUFFER:0:$CURSOR}$nextc$word${BUFFER:$((MARK+1))}"
                CURSOR=$((CURSOR+1))
                MARK=$((MARK+1))
            else
                BUFFER="$word${BUFFER:0:$((${#BUFFER} - ${#word}))}"
                CURSOR=0
                MARK=${#word}
            fi
        fi
    elif [[ $MARK -lt $CURSOR ]]; then
        len=$(( $CURSOR - $MARK )) 
        word="${BUFFER:$MARK:$len}" 
        if [[ $1 == 'left' ]]; then
            if [[ $MARK != 0 ]]; then
                prevc="${BUFFER:$(($MARK-1)):1}"
                BUFFER="${BUFFER:0:$(($MARK-1))}$word$prevc${BUFFER:$CURSOR}"
                CURSOR=$((CURSOR-1))
                MARK=$((MARK-1))
            else
                BUFFER="${BUFFER:${#word}}$word"
                MARK=$((${#BUFFER}-${#word}))
                CURSOR=${#BUFFER}
            fi
        elif [[ $1 == 'right' ]]; then
            if [[ $CURSOR != $linelen ]]; then
                nextc="${BUFFER:$CURSOR:1}"
                BUFFER="${BUFFER:0:$MARK}$nextc$word${BUFFER:$((CURSOR+1))}"
                CURSOR=$((CURSOR+1))
                MARK=$((MARK+1))
            else
                BUFFER="$word${BUFFER:0:$((${#BUFFER} - ${#word}))}"
                MARK=0
                CURSOR=${#word}
            fi
        fi
    fi

}


# Deactivate the selection region, switch back to the main keymap and process
# the typed keys again.
function shift-select::deselect-and-input() {
    zle deactivate-region -w
    # Switch back to the main keymap (emacs).
    zle -K main
    # Push the typed keys back to the input stack, i.e. process them again,
    # but now with the main keymap.
    zle -U "$KEYS"
}
zle -N shift-select::deselect-and-input

# If the selection region is not active, set the mark at the cursor position,
# switch to the shift-select keymap, and call $WIDGET without 'shift-select::'
# prefix. This function must be used only for shift-select::<widget> widgets.
function shift-select::select-and-invoke() {
    if (( !REGION_ACTIVE )); then
        zle set-mark-command -w
        zle -K shift-select
    fi
    zle ${WIDGET#shift-select::} -w
}



# Create a new keymap for the shift-selection mode.
bindkey -N shift-select

# Bind all possible key sequences to deselect-and-input, i.e. it will be used
# as a fallback for "unbound" key sequences.
bindkey -M shift-select -R '^@'-'^?' shift-select::deselect-and-input

local kcap seq seq_mac widget

# Bind Shift keys in the emacs and shift-select keymaps.
for	kcap   seq          seq_mac    widget (             # key name
        kLFT   '^[[1;2D'    x          backward-char        # Shift + LeftArrow
        kRIT   '^[[1;2C'    x          forward-char         # Shift + RightArrow
        kri    '^[[1;2A'    x          up-line              # Shift + UpArrow
        kind   '^[[1;2B'    x          down-line            # Shift + DownArrow
        kHOM   '^[[1;2H'    x          beginning-of-line    # Shift + Home
        kEND   '^[[1;2F'    x          end-of-line          # Shift + End
        x      '^[[1;4A'    x          beginning-of-buffer  # Shift + Alt + UpArrow
        x      '^[[1;4B'    x          end-of-buffer        # Shift + Alt + DownArrow
        x      '^[[1;4D'    x          beginning-of-line    # Shift + Alt + RightArrow
        x      '^[[1;4C'    x          end-of-line          # Shift + Alt + LeftArrow
        #x      '^[[97;6u'   x          beginning-of-line    # Shift + Ctrl + A
        #x      '^[[101;6u'  x          end-of-line          # Shift + Ctrl + E
        #x      '^[[1;6D'    '^[[1;4D'  backward-word        # Shift + Ctrl/Option + LeftArrow
        #x      '^[[1;6C'    '^[[1;4C'  forward-word         # Shift + Ctrl/Option + RightArrow
        #x      '^[[1;6H'    '^[[1;4H'  beginning-of-buffer  # Shift + Ctrl/Option + Home
        #x      '^[[1;6F'    '^[[1;4F'  end-of-buffer        # Shift + Ctrl/Option + End
); do
    # Use alternative sequence (Option instead of Ctrl) on macOS, if defined.
    [[ "$OSTYPE" = darwin* && "$seq_mac" != x ]] && seq=$seq_mac

    zle -N shift-select::$widget shift-select::select-and-invoke
    bindkey -M emacs ${terminfo[$kcap]:-$seq} shift-select::$widget
    bindkey -M shift-select ${terminfo[$kcap]:-$seq} shift-select::$widget
done

# Bind keys in the shift-select keymap.
for	kcap   seq        widget (                          # key name
        kdch1  '^[[3~'    shift-select::kill-region         # Delete
        bs     '^?'       shift-select::kill-region         # Backspace

); do
    bindkey -M shift-select ${terminfo[$kcap]:-$seq} $widget
done

shift-select::move-region-left(){ move-region left }
shift-select::move-region-right(){ move-region right }

zle -N shift-select::move-region-left
zle -N shift-select::move-region-right

# Alt-Right - Move region left/right
bindkey -M emacs '\e[1;3C' shift-select::move-region-right  
bindkey -M viins '\e[1;3C' shift-select::move-region-right  
bindkey -M vicmd '\e[1;3C' shift-select::move-region-right  
bindkey -M shift-select '\e[1;3C' shift-select::move-region-right  

# Alt-Left - Move region left/right
bindkey -M emacs '\e[1;3D' shift-select::move-region-left  
bindkey -M viins '\e[1;3D' shift-select::move-region-left  
bindkey -M vicmd '\e[1;3D' shift-select::move-region-left  
bindkey -M shift-select '\e[1;3D' shift-select::move-region-left  


# Up and down arrow will now intelligently complete partially completed
# commands by searching through the existing history.
bindkey -M emacs "\e[A" history-search-backward
bindkey -M viins "\e[A" history-search-backward
bindkey -M vicmd "\e[A" history-search-backward

bindkey -M emacs "\e[B" history-search-forward
bindkey -M viins "\e[B" history-search-forward
bindkey -M vicmd "\e[B" history-search-forward

# Control left/right to jump from bigwords (ignore spaces when jumping) instead of chars
bindkey -M emacs '\e[1;5D' backward-word
bindkey -M viins '\e[1;5D' backward-word
bindkey -M vicmd '\e[1;5D' backward-word

bindkey -M emacs '\e[1;5C' forward-word
bindkey -M viins '\e[1;5C' forward-word
bindkey -M vicmd '\e[1;5C' forward-word

# Full path dirs
alias dirs="dirs -l"
alias dirs-col="dirs -v | column -c $COLUMNS"
alias dirs-col-pretty="dirs -p -v | column -c $COLUMNS | sed -E 's|^0[[:space:]]+([^[:space:]]+)|'\${GREEN}'0\t\1'\${normal}'|'"

# A clear for alt-right/left that displays dirs/dirs-col/dirs-col-pretty
# echo -en "\e[2K\r" clears the line we're on, and moves the cursor to the start of the line 
if hash starship &>/dev/null && [[ $STARSHIP_SHELL == 'zsh' ]] && (grep -q '\\n' ~/.config/starship.toml || (grep -q 'line_break' ~/.config/starship.toml && ! pcregrep -qM "[line_break]\$(.|\n)*^disabled = true" ~/.config/starship.toml)); then
    function clr1(){ 
        echo -en "\e[2K\r"
        tput cuu1
        tput cuu1
        tput cuu1
        tput sc;
        clear
        zle reset-prompt    
        zle redisplay 
    }
    function clr2(){ 
        echo -en "\e[2K\r"
        tput cuu1 
        tput cuu1 
        tput cuu1 
        tput sc;
        clear 
        tput rc 
        for ((i = 0 ; i < $(dirs -v | column -c ${COLUMNS} | wc -l) ; i++)); do
            tput cuu1;
        done 
        echo 
        dirs-col-pretty
        echo
        zle reset-prompt    
        zle redisplay 
    }
elif hash starship &>/dev/null && [[ $STARSHIP_SHELL == 'zsh' ]]; then
    function clr1(){ 
        echo -en "\e[2K\r"
        tput cuu1 
        tput cuu1
        tput sc; 
        clear 
        tput rc 
        zle reset-prompt    
        zle redisplay 
    }
    function clr2(){ 
        echo -en "\e[2K\r"
        tput cuu1 
        tput cuu1 
        tput sc; 
        clear
        tput rc 
        for ((i = 0 ; i < $(dirs -v | column -c ${COLUMNS} | wc -l) ; i++)); do 
            tput cuu1; 
        done 
        echo 
        dirs-col-pretty
        echo 
        zle reset-prompt
        zle redisplay 
    }
else
    function clr1(){ 
        echo -en "\e[2K\r"
        tput sc; 
        clear
        tput rc
        zle reset-prompt    
        zle redisplay 
    }
    function clr2(){ 
        echo -en "\e[2K\r"
        tput sc; 
        zle kill-whole-line
        # Make sure when powerlevel10k/9k is active the prompt updates 
        [[ -n $POWERLEVEL9K_STATUS_OK ]] &&
            zle accept-line
        clear; 
        tput rc;
        for ((i = 0 ; i <= $(dirs -v | column -c ${COLUMNS} | wc -l) ; i++)); do 
            tput cuu1; 
        done;
        tput cuu1 
        echo 
        dirs-col-pretty;
        # P10k doesn't like this 
        [[ -z $POWERLEVEL9K_STATUS_OK ]] && 
            echo && 
            zle reset-prompt &&    
    }
fi

zle -N clr1
zle -N clr2

# We set this option so every time we change directory, we add said directory to the dir stack 
# (used by dirs/pushd/popd)
setopt autopushd pushdignoredups

rightdir(){
    pushd +1 &>/dev/null
    zle beginning-of-line
    zle clr2
}

leftdir(){
    pushd -0 &>/dev/null
    zle beginning-of-line
    zle clr2
}

zle -N rightdir
zle -N leftdir

# 'dirs' builtins shows all directories in stack
# Ctrl-Alt-Left/Right arrow rotates over directory history
bindkey -M emacs '\e[1;7C' rightdir
bindkey -M viins '\e[1;7C' rightdir
bindkey -M vicmd '\e[1;7C' rightdir

bindkey -M emacs '\e[1;7D' leftdir
bindkey -M viins '\e[1;7D' leftdir
bindkey -M vicmd '\e[1;7D' leftdir

# Ctrl-Alt-Up -> Dir Up
updir(){
    zle beginning-of-line
    cd ..
    zle clr2
}

zle -N updir
bindkey -M emacs "\e[1;7A" updir
bindkey -M viins "\e[1;7A" updir
bindkey -M vicmd "\e[1;7A" updir

# Ctrl-Alt-Down prompts you to select a folder to go into
# With fzf keybinds or with tabcomplete
if ! hash fzf &> /dev/null; then
    
    # Ctrl-Alt-Down -> Dir Select
    function show-cd(){ 
        clear 
        tput cup $(($LINE_TPUT+1)) $TPUT_COL 
        tput sc 
        tput cuu1 
        # If the current buffer doesn't start with 'cd ', insert it
        if [[ "$BUFFER" != cd\ * && "$BUFFER" != cd ]]; then
            BUFFER="cd "
            CURSOR=${#BUFFER}  # move cursor to end
        fi 
        zle -C complete-cd expand-or-complete _cd 
        zle reset-prompt 
        zle complete-word
    }
    zle -N show-cd
     
    bindkey -M emacs '\e[1;7B' show-cd
    bindkey -M vicmd '\e[1;7B' show-cd
    bindkey -M viins '\e[1;7B' show-cd
else
    if ! [ -f $HOME/.keybinds.d/fzf-bindings.zsh ]; then
        __fzf_defaults() {
          printf '%s\n' "--height ${FZF_TMUX_HEIGHT:-40%} --min-height 20+ --bind=ctrl-z:ignore $1"
          command cat "${FZF_DEFAULT_OPTS_FILE-}" 2> /dev/null
          printf '%s\n' "${FZF_DEFAULT_OPTS-} $2"
        } 
        
        __fzfcmd() {
          [ -n "${TMUX_PANE-}" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "${FZF_TMUX_OPTS-}" ]; } &&
            echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
        } 
        
        fzf-cd-widget() {
          setopt localoptions pipefail no_aliases 2> /dev/null
          local dir="$(
            FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} \
            FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "${FZF_ALT_C_OPTS-} +m") \
            FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) < /dev/tty)"
          if [[ -z "$dir" ]]; then
            zle redisplay
            return 0
          fi
          zle push-line # Clear buffer. Auto-restored on next prompt.
          builtin cd -- ${(q)dir:a}
          zle accept-line
          local ret=$?
          unset dir # ensure this doesn't end up appearing in prompt expansion
          zle reset-prompt
          return $ret
        }
        if [[ "${FZF_ALT_C_COMMAND-x}" != "" ]]; then
          zle -N fzf-cd-widget
          bindkey -M emacs '\e[1;7B' fzf-cd-widget
          bindkey -M vicmd '\e[1;7B' fzf-cd-widget
          bindkey -M viins '\e[1;7B' fzf-cd-widget
        fi
    fi
    if hash bfs &> /dev/null; then
        # https://github.com/tavianator/bfs/issues/163 
        FZF_ALT_C_COMMAND="[[ -n \"\$(command ls -Ahp | command grep \".*/$\")\" ]] && bfs -s -x -type d -printf '%P\n' -exclude -name '.git' -exclude -name 'node_modules' | sed '/^[[:space:]]*$/d' || echo .." 
        # Alternative with previous directory added
        # FZF_ALT_C_COMMAND="[[ -n \"\$(command ls -Ahp | command grep \".*/$\")\" ]] && echo \"..\n\$(bfs -s -x -type d -printf '%P\n' -exclude -name '.git' -exclude -name 'node_modules' | sed '/^[[:space:]]*$/d')\" || echo .." 
    elif hash fd &> /dev/null; then
        FZF_ALT_C_COMMAND="fd -H --type d --exclude '.git' --exclude 'node_modules'" 
    fi
    
    FZF_ALT_C_OPTS='--bind "ctrl-v:become(vlc --recursive expand {})"
                    --bind "ctrl-g:become(. ~/.bash_aliases.d/ripgrep-directory.sh && cd {} && ripgrep-dir > /dev/tty)"' 
    if hash eza &> /dev/null; then
        FZF_ALT_C_OPTS="$FZF_ALT_C_OPTS --preview 'eza --tree --color=always --icons=always --all {}'"
    elif hash tree &> /dev/null; then 
        FZF_ALT_C_OPTS="$FZF_ALT_C_OPTS --preview 'tree -C {}'"
    fi
fi

# Shift left/right to jump from words instead of chars
 
function clear-screen(){ 
    clear 
    tput cup $(($LINE_TPUT+1)) $TPUT_COL 
    tput sc 
    tput cuu1 
    zle reset-prompt 
    tput cuu1
}

zle -N clear-screen

# Shift left/right to jump from bigwords (ignore spaces when jumping) instead of chars
#bindkey -M emacs -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -M viins     -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -M vicmd      -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#
#bindkey -M emacs -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -M viins     -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -M vicmd      -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'

# Alt left/right to jump to beginning/end line instead of chars
bindkey -M emacs "\e[1;3D" beginning-of-line
bindkey -M viins "\e[1;3D" beginning-of-line
bindkey -M vicmd "\e[1;3D" beginning-of-line

bindkey -M emacs "\e[1;3C" end-of-line
bindkey -M viins "\e[1;3C" end-of-line
bindkey -M vicmd "\e[1;3C" end-of-line

# Alt up/down to change cursor line
function mv_prmpt_up(){ 
    clear 
    let LINE_TPUT=$LINE_TPUT-1
    if [ $LINE_TPUT -lt 0 ]; then 
        let LINE_TPUT=$LINES;
    fi 
    tput cup $LINE_TPUT $COL_TPUT
    zle reset-prompt
    tput sc 
}

zle -N mv_prmpt_up

bindkey -M viins "\e[1;3A" mv_prmpt_up
bindkey -M emacs "\e[1;3A" mv_prmpt_up
bindkey -M vicmd "\e[1;3A" mv_prmpt_up


function mv_prmpt_dwn(){ 
    clear 
    let LINE_TPUT=$LINE_TPUT+1
    if [ $LINE_TPUT -gt $LINES ]; then 
        let LINE_TPUT=0;
    fi 
    tput cup $LINE_TPUT $COL_TPUT
    zle reset-prompt
    tput sc 
}

zle -N mv_prmpt_up
zle -N mv_prmpt_dwn

bindkey -M viins "\e[1;3A" mv_prmpt_up
bindkey -M emacs "\e[1;3A" mv_prmpt_up
bindkey -M vicmd "\e[1;3A" mv_prmpt_up

bindkey -M emacs "\e[1;3B" mv_prmpt_dwn
bindkey -M viins "\e[1;3B" mv_prmpt_dwn
bindkey -M vicmd "\e[1;3B" mv_prmpt_dwn

function expand-aliases() {
    local cmd=${BUFFER%% *}
    local rest=${BUFFER#"$cmd"}
    local expansion=$(alias "$cmd" 2>/dev/null | sed -E "s/^$cmd='(.*)'$/\1/")

    if [[ -n "$expansion" ]]; then
        BUFFER="$expansion$rest"
        CURSOR=${#BUFFER}
    fi
}

zle -N expand-aliases

# Ctrl-w expands aliases
bindkey -M emacs "\C-w" expand-aliases
bindkey -M viins "\C-w" expand-aliases
bindkey -M vicmd "\C-w" expand-aliases

# Expand by looping through options
bindkey -M emacs 'Tab' menu-complete
bindkey -M viins 'Tab' menu-complete
bindkey -M vicmd 'Tab' menu-complete

# Shift+Tab for reverse
bindkey -M emacs "\e[Z" reverse-menu-complete
bindkey -M viins "\e[Z" reverse-menu-complete 
bindkey -M vicmd "\e[Z" reverse-menu-complete 

if [[ "$TERM" == 'xterm-kitty' ]]; then
    # (Kitty only) Ctrl-tab for variable autocompletion
    bindkey -M emacs "\e[9;5u" complete-word
    bindkey -M viins "\e[9;5u" complete-word
    bindkey -M vicmd "\e[9;5u" complete-word
fi

# Ctrl-q quits terminal

function exit-zsh(){ exit }
zle -N exit-zsh

bindkey -M emacs "\C-q" exit-zsh
bindkey -M viins "\C-q" exit-zsh
bindkey -M vicmd "\C-q" exit-zsh

# Ctrl+z is vi-undo (after being unbound in stty) instead of only on Ctrl+_
bindkey -M emacs "\C-z" vi-undo-change
bindkey -M viins "\C-z" vi-undo-change
bindkey -M vicmd "\C-z" vi-undo-change 

# Ctrl-backspace deletes (kills) line backward
bindkey -M emacs "\C-h" backward-kill-word
bindkey -M viins "\C-h" backward-kill-word
bindkey -M vicmd "\C-h" backward-kill-word

# Ctrl-l clears
bindkey -M viins '\C-l' clear-screen
bindkey -M emacs '\C-l' clear-screen
bindkey -M vicmd '\C-l' clear-screen

function delete-first-char() {
    if [[ -n "$BUFFER" ]]; then
        BUFFER=${BUFFER:1}       
        (( CURSOR > 0 )) && (( CURSOR-- ))  
    fi
}

zle -N delete-first-char

# Ctrl-d: Delete first character on line
bindkey -M emacs "\C-d" delete-first-char
bindkey -M viins "\C-d" delete-first-char
bindkey -M vicmd "\C-d" delete-first-char  

# Ctrl+b: (Ctrl+x Ctrl+b emacs mode) is quoted insert - Default Ctrl+v - Gives (f.ex. 'Ctrl-a') back as '^A'
bindkey -M emacs "\C-x\C-b" quoted-insert
bindkey -M viins "\C-b" quoted-insert
bindkey -M vicmd "\C-b" quoted-insert

function emacs-mode() {
    bindkey -e
    zle reset-prompt      
}

function vi-cmd-mode() {
    bindkey -a
    zle reset-prompt      
}

function vi-ins-mode() {
    bindkey -v
    zle reset-prompt      
}

zle -N emacs-mode
zle -N vi-cmd-mode
zle -N vi-ins-mode


# Ctrl+o: Change from vi-mode to emacs mode and back
# This is also configured in ~/.fzf/shell/key-bindings-bash.sh if you have fzf keybinds installed
bindkey -M viins "\C-o" emacs-mode
bindkey -M vicmd "\C-o" emacs-mode
bindkey -M emacs "\C-o" vi-ins-mode

# vi-command ' / emacs C-x ' helps with adding quotes to bash strings
function quote-all-zsh() { BUFFER="${BUFFER@Q}"; zle reset-prompt }
zle -N quote-all-zsh
bindkey -M emacs -s '\C-x'\''' quote-all-zsh
bindkey -M viins -s ''\''' quote-all-zsh
#bindkey -M vicmd -s '\C-x'\''' '_quote_all'

# https://unix.stackexchange.com/questions/85391/where-is-the-bash-feature-to-open-a-command-in-editor-documented
edit-wo-executing() {
    local editor="${EDITOR:-nano}"
    tmpf="$(mktemp).sh"
    printf "$BUFFER" >"$tmpf"
    $EDITOR "$tmpf"
    # https://stackoverflow.com/questions/6675492/how-can-i-remove-all-newlines-n-using-sed
    #[ "$(sed -n '/^#!\/bin\/bash/p;q' "$tmpf")" ] && sed -i 1d "$tmpf"
    BUFFER="$(<"$tmpf")"
    CURSOR="${#BUFFER}"
    command rm "$tmpf" &>/dev/null
}

zle -N edit-wo-executing

bindkey -M vicmd "\C-e" edit-wo-executing
bindkey -M viins "v" edit-wo-executing
bindkey -M viins "\C-e" edit-wo-executing
bindkey -M emacs "\C-e\C-e" edit-wo-executing

# RLWRAP

#if hash rlwrap &> /dev/null; then
#    bindkey -M emacs '"\C-x\C-e" : rlwrap-call-editor'
#    bindkey -M viins '"\C-e" : rlwrap-call-editor'
#    bindkey -M vicmd '"\C-e" : rlwrap-call-editor'
#fi

if hash osc &>/dev/null; then
    
    function osc-copy() {
        if (( REGION_ACTIVE )); then
            if [[ $MARK -gt $CURSOR ]]; then
                echo -n ${BUFFER[$((CURSOR+1)),$MARK]} | osc copy 
            else 
                echo -n ${BUFFER[$((MARK+1)),$CURSOR]} | osc copy 
            fi
            zle deactivate-region -w
            zle -K main
        else 
            echo -n "$BUFFER" | osc copy
        fi
    }
    
    function osc-paste() {
        local pasters="$(osc paste)"
        BUFFER="${BUFFER:0:$CURSOR}$pasters${BUFFER:$CURSOR}"
        CURSOR=$((CURSOR + ${#pasters}))
    }
   
    zle -N osc-copy
    zle -N osc-paste

    bindkey -M emacs "\C-s" osc-copy
    bindkey -M viins "\C-s" osc-copy
    bindkey -M vicmd "\C-s" osc-copy
    bindkey -M shift-select "\C-s" osc-copy

    bindkey -M viins "\C-v" osc-paste
    bindkey -M emacs "\C-v" osc-paste
    bindkey -M vicmd "\C-v" osc-paste

elif ([[ "$XDG_SESSION_TYPE" == 'x11' ]] && hash xclip &>/dev/null) || ([[ "$XDG_SESSION_TYPE" == 'wayland' ]] && hash wl-copy &> /dev/null); then
  
    function clip-copy() {
        if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then  
            if (( REGION_ACTIVE )); then
                if [[ $MARK -gt $CURSOR ]]; then
                    echo -n ${BUFFER[$((CURSOR+1)),$MARK]} | xclip -i -sel c 
                else 
                    echo -n ${BUFFER[$((MARK+1)),$CURSOR]} | xclip -i -sel c 
                fi
                zle deactivate-region -w
                zle -K main
            else 
                echo -n "$BUFFER" | xclip -i -sel c
            fi
        elif [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
            if (( REGION_ACTIVE )); then
                if [[ $MARK -gt $CURSOR ]]; then
                    echo -n ${BUFFER[$((CURSOR+1)),$MARK]} | wl-copy 
                else 
                    echo -n ${BUFFER[$((MARK+1)),$CURSOR]} | wl-copy 
                fi
                zle deactivate-region -w
                zle -K main
            else 
                echo -n "$BUFFER" | wl-copy
            fi
        fi
    }

    function clip-paste() {
        if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then  
            local pasters="$(xclip -o -sel c)"
        elif [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
            local pasters="$(wl-paste)"
        fi
        BUFFER="${BUFFER:0:$CURSOR}$pasters${BUFFER:$CURSOR}"
        CURSOR=$((CURSOR + ${#pasters}))
    }
   
    zle -N clip-copy
    zle -N clip-paste

    # Ctrl-s: Proper copy
    bindkey -M emacs "\C-s" clip-copy
    bindkey -M viins "\C-s" clip-copy
    bindkey -M vicmd "\C-s" clip-copy
    bindkey -M shift-select "\C-s" clip-copy

    # Ctrl-v: Proper paste
    bindkey -M emacs "\C-v" clip-paste
    bindkey -M viins "\C-v" clip-paste
    bindkey -M vicmd "\C-v" clip-paste

fi

if hash autojump &>/dev/null; then
    function show-j(){ 
        clear 
        tput cup $(($LINE_TPUT+1)) $TPUT_COL 
        tput sc 
        tput cuu1 
        if [[ "$BUFFER" != j\ * && "$BUFFER" != j ]]; then
            BUFFER="j "
            CURSOR=${#BUFFER}
        fi 
        zle reset-prompt 
        zle menu-select
    }
          
    zle -N show-j   

    # Ctrl-x Ctrl-j for autojump
    bindkey -M emacs "\C-x\C-j" show-j 
    bindkey -M viins "\C-j" show-j 
    bindkey -M vicmd "\C-j" show-j 
fi

if hash fzf &>/dev/null; then
    
    #if [[ "$TERM" == 'xterm-kitty' ]]; then
    #    # (Kitty only) Ctrl-tab for fzf autocompletion
    #    bindkey -M emacs '"\e[9;5u": " **\t"'
    #    bindkey -M viins '"\e[9;5u": " **\t"'
    #    bindkey -M vicmd '"\e[9;5u": " **\t"'
    #fi

    if type ripgrep-dir &>/dev/null; then
        
        function ripgrep-dir-zsh(){
            ripgrep-dir
            zle reset-prompt
        }
         
        zle -N ripgrep-dir-zsh
        
        # Ctrl-g: Ripgrep function overview
        bindkey -M emacs "\C-g" ripgrep-dir-zsh
        bindkey -M viins "\C-g" ripgrep-dir-zsh
        bindkey -M vicmd "\C-g" ripgrep-dir-zsh
    fi

    if type fzf_rifle &>/dev/null; then
       
        function fzf_rifle-zsh(){
            fzf_rifle
            zle reset-prompt
        }
         
        zle -N fzf_rifle-zsh
       
        # CTRL-F - Paste the selected file path into the command line
        bindkey -M emacs "\C-f" fzf_rifle-zsh
        bindkey -M viins "\C-f" fzf_rifle-zsh
        bindkey -M vicmd "\C-f" fzf_rifle-zsh

        # F4 - Rifle search
        bindkey -M emacs "\eOS" fzf_rifle-zsh
        bindkey -M viins "\eOS" fzf_rifle-zsh
        bindkey -M vicmd "\eOS" fzf_rifle-zsh
    fi
fi

# F2 - ranger (file explorer)
if hash ranger &>/dev/null; then
    # https://unix.stackexchange.com/questions/475310/how-to-bind-a-keyboard-shortcut-in-zsh-to-a-program-requiring-stdin 
    function ranger-zsh () {
        ranger --choosedir=$HOME/.rangerdir < $TTY
        LASTDIR=`cat $HOME/.rangerdir`
        cd "$LASTDIR"
        zle reset-prompt
        unset LASTDIR 
    }
    
    zle -N ranger-zsh 
   
    bindkey -M emacs "\eOQ" ranger-zsh
    bindkey -M viins "\eOQ" ranger-zsh
    bindkey -M vicmd "\eOQ" ranger-zsh
fi

# F3 - lazygit (Git helper)
if hash lazygit &>/dev/null; then
    function lazygit-zsh () {
        lazygit
        zle reset-prompt
    }
    
    zle -N lazygit-zsh
    bindkey -M emacs "\eOR" lazygit-zsh
    bindkey -M viins "\eOR" lazygit-zsh
    bindkey -M vicmd "\eOR" lazygit-zsh
fi

# F5, Ctrl-r - Reload .zshrc
function resource-zsh(){ 
    source ~/.zshrc; 
    zle reset-prompt 
}
zle -N resource-zsh
bindkey -M emacs "\e[15~" resource-zsh
bindkey -M viins "\e[15~" resource-zsh 
bindkey -M vicmd "\e[15~" resource-zsh 

# F6 - (neo/fast/screen)fetch (System overview)
if hash neofetch &>/dev/null || hash fastfetch &>/dev/null || hash screenfetch &>/dev/null || hash onefetch &>/dev/null; then

    if hash onefetch &>/dev/null; then
        if hash neofetch &>/dev/null || hash fastfetch &>/dev/null || hash screenfetch &>/dev/null; then
            function fetchbind-zsh(){
                if hash git &> /dev/null && git rev-parse --git-dir &> /dev/null; then
                    local gstats 
                    readyn -p "Use onefetch? (lists github stats)" gstats 
                    if [[ "$gstats" == "y" ]]; then
                        onefetch 
                    else
                        echo 
                        if hash fastfetch &>/dev/null; then
                            fastfetch
                        elif hash screenfetch &>/dev/null; then
                            screenfetch
                        elif hash neofetch &>/dev/null; then
                            neofetch
                        fi
                    fi
                else
                    echo 
                    if hash fastfetch &>/dev/null; then
                        fastfetch
                    elif hash screenfetch &>/dev/null; then
                        screenfetch
                    elif hash neofetch &>/dev/null; then
                        neofetch
                    fi
                fi
                zle reset-prompt
            }
        else
            function fetchbind-zsh(){ stty sane; onefetch }
        fi
    else
        if hash neofetch &>/dev/null; then
            function fetchbind-zsh(){ stty sane; echo; neofetch }
        fi

        if hash screenfetch &>/dev/null; then
            function fetchbind-zsh(){ stty sane; echo;screenfetch }
        fi

        if hash fastfetch &>/dev/null; then
            function fetchbind-zsh(){ stty sane; echo; fastfetch }
        fi
    fi
    
    zle -N fetchbind-zsh

    bindkey -M emacs "\e[17~" fetchbind-zsh
    bindkey -M viins "\e[17~" fetchbind-zsh 
    bindkey -M vicmd "\e[17~" fetchbind-zsh 
    
    unset fetch
fi

# F7 - Htop and alternatives

function htop-btop-zsh(){
    local ansr ansr1 
    
    # Flush zle's state / clean it up  
    zle -I 
    
    if hash btop &>/dev/null; then
         readyn -p "Use btop instead of htop?" ansr 
         if [[ "$ansr" == "y" ]]; then
             readyn -p "Start btop as root?" ansr1 
             if [[ "$ansr1" == "y" ]]; then
                 # ZSH widgets apparently run detached from TTY's standard input???  
                 # Redirect stdin from TTY to btop, otherwise we can't see what jobs are running  
                 sudo btop </dev/tty
             else 
                btop </dev/tty
             fi
         fi
    
    elif hash bashtop &>/dev/null; then
         readyn -p "Use bashtop instead of htop?" ansr 
         if [[ "$ansr" == "y" ]]; then
             readyn -p "Start bashtop as root?" ansr1 
             if [[ "$ansr1" == "y" ]]; then
                sudo bashtop </dev/tty
             else 
                bashtop </dev/tty
             fi
         fi
    elif hash bpytop &>/dev/null; then
         readyn -p "Use bpytop instead of htop?" ansr 
         if [[ "$ansr" == "y" ]]; then
             readyn -p "Start bpytop as root?" ansr1 
             if [[ "$ansr1" == "y" ]]; then
                sudo bpytop </dev/tty
             else 
                bpytop </dev/tty
             fi
         fi
    fi
   
    if ! (hash btop &> /dev/null || hash bashtop &> /dev/null || hash bpytop &> /dev/null) || [[ "$ansr" == 'n' ]]; then
        readyn -p "Start htop as root?" ansr1 
        [[ "$ansr1" == "y" ]] && sudo htop </dev/tty || htop </dev/tty
    fi
    zle reset-prompt 
}

zle -N htop-btop-zsh

bindkey -M emacs "\e[18~" htop-btop-zsh
bindkey -M viins "\e[18~" htop-btop-zsh
bindkey -M vicmd "\e[18~" htop-btop-zsh

# F8 - Lazydocker (Docker TUI)
if hash lazydocker &>/dev/null; then
    function lazydocker-zsh () {
        lazydocker
        zle reset-prompt
    }
    
    zle -N lazydocker-zsh
    bindkey -M emacs "\e[19~" lazydocker-zsh
    bindkey -M viins "\e[19~" lazydocker-zsh 
    bindkey -M vicmd "\e[19~" lazydocker-zsh 
fi
