#!/bin/zsh

# Bash_aliases at ~/.bash_aliases.d/
# global bashrc -> /etc/bash.bashrc
# root shell profiles -> /etc/profile

# https://stackoverflow.com/questions/8366450/complex-keybinding-in-bash

alias list-binds-zsh="bindkey -l"
alias list-binds-stty="stty -a"
alias list-binds-xterm="xrdb -query -all"
alias list-binds-kitty='kitty +kitten show_key -m kitty'

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
#bindkey -a '"\C-a": emacs-editing-mode'
#bind -m vi-insert '"\C-a": emacs-editing-mode'
#bindkey -e '"\C-a": vi-editing-mode'

# Up and down arrow will now intelligently complete partially completed
# commands by searching through the existing history.
bindkey -e "\e[A" history-search-backward
bindkey -a "\e[A" history-search-backward
bindkey -v "\e[A" history-search-backward

bindkey -e "\e[B" history-search-forward
bindkey -a "\e[B" history-search-forward
bindkey -v "\e[B" history-search-forward

# Control left/right to jump from bigwords (ignore spaces when jumping) instead of chars
bindkey -e '\e[1;5D' vi-backward-word
bindkey -a '\e[1;5D' vi-backward-word
bindkey -v '\e[1;5D' vi-backward-word

bindkey -e '\e[1;5C' vi-forward-word
bindkey -a '\e[1;5C' vi-forward-word
bindkey -v '\e[1;5C' vi-forward-word

# Full path dirs
alias dirs="dirs -l"
alias dirs-col="dirs -v | column -c $COLUMNS"
alias dirs-col-pretty="dirs -v | column -c $COLUMNS | sed -e 's/ 0 \\([^\t]*\\)/'\${GREEN}' 0 \\1'\${normal}'/'"

#'Silent' clear
if hash starship &>/dev/null && grep -q "^eval \"\$(starship init bash)\"" ~/.bashrc && (grep -q '\\n' ~/.config/starship.toml || (grep -q 'line_break' ~/.config/starship.toml && ! pcregrep -qM "[line_break]\$(.|\n)*^disabled = true" ~/.config/starship.toml)); then
    function clr1(){ tput cuu1 && tput cuu1 && tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null }
    function clr2(){ tput cuu1 && tput cuu1 && tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i < $(dirs -v | column -c ${COLUMNS} | wc -l) ; i++)); do tput cuu1; done && dirs-col-pretty && history -d -1 &>/dev/null }
elif hash starship &>/dev/null && grep -q "^eval \"\$(starship init bash)\"" ~/.zshrc; then
    function clr1(){ tput cuu1 && tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null }
    function clr2(){ tput cuu1 && tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i < $(dirs -v | column -c ${COLUMNS} | wc -l) ; i++)); do tput cuu1; done && tput cuu1 && dirs-col-pretty && tput rc && history -d -1 &>/dev/null }
else
    function clr1(){ tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null }
    function clr2(){ tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i <= $(dirs -v | column -c ${COLUMNS} | wc -l) ; i++)); do tput cuu1; done && dirs-col-pretty && tput rc && history -d -1 &>/dev/null }
fi

zle -N clr1
zle -N clr2

updir(){
    pushd +1 &>/dev/null
    zle beginning-of-line
    zle clr2
}

zle -N updir

# 'dirs' builtins shows all directories in stack
# Ctrl-Up arrow rotates over directory history
bindkey -e '\e[1;5A' updir
bindkey -a '\e[1;5A' updir
bindkey -v '\e[1;5A' updir

# Ctrl-Down -> Dir Down
downdir(){
    zle beginning-of-line
    cd ..
    zle clr2
}

zle -N downdir
bindkey -e "\e[1;5B" downdir
bindkey -a "\e[1;5B" downdir
bindkey -v "\e[1;5B" downdir

# Ctrl-Down -> Rotate between 2 last directories
#bindkey -s '"\e266": pushd -1 &>/dev/null\n'
#bindkey -e '"\e[1;5B": "\C-e\C-u\e266 _.\C-m"'
#bindkey -a     '"\e[1;5B": "ddi\C-u\e266 _.\C-m"'
#bindkey -v      '"\e[1;5B": "\eddi\e266 _.\C-m"'

# Shift left/right to jump from words instead of chars
 
function clear-screen(){ 
    clear 
    tput cup $(($LINE_TPUT+1)) $TPUT_COL 
    tput sc 
    tput cuu1 
    zle reset-prompt 
    tput cuu1
}

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
    zle menu-select
}

zle -N clear-screen
zle -N show-cd

# Shift up => Clean reset
bindkey -e "\e[1;2A" clear-screen
bindkey -a "\e[1;2A" clear-screen
bindkey -v "\e[1;2A" clear-screen

# Shift down => cd shortcut
bindkey -e "\e[1;2B" show-cd 
bindkey -v "\e[1;2B" show-cd
bindkey -a "\e[1;2B" show-cd

# Shift left/right to jump from bigwords (ignore spaces when jumping) instead of chars
#bindkey -e -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -a     -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -v      -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#
#bindkey -e -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -a     -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -v      -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'

# Alt left/right to jump to beginning/end line instead of chars
bindkey -e "\e[1;3D" beginning-of-line
bindkey -a "\e[1;3D" beginning-of-line
bindkey -v "\e[1;3D" beginning-of-line

bindkey -e "\e[1;3C" end-of-line
bindkey -a "\e[1;3C" end-of-line
bindkey -v "\e[1;3C" end-of-line

# Alt up/down to change cursor line
function mv_prmpt_up(){ 
    clear 
    let LINE_TPUT=$LINE_TPUT-1
    if [ $LINE_TPUT -lt 0 ]; then 
        let LINE_TPUT=$LINES;
    fi 
    tput cup $LINE_TPUT $COL_TPUT
    zle reset-prompt
    tput sc }
zle -N mv_prmpt_up
bindkey -a "\e[1;3A" mv_prmpt_up
bindkey -e "\e[1;3A" mv_prmpt_up
bindkey -v "\e[1;3A" mv_prmpt_up


function mv_prmpt_dwn(){ 
    clear 
    let LINE_TPUT=$LINE_TPUT+1
    if [ $LINE_TPUT -gt $LINES ];then 
        let LINE_TPUT=0;
    fi 
    tput cup $LINE_TPUT $COL_TPUT
    zle reset-prompt
    tput sc 
}

zle -N mv_prmpt_up
zle -N mv_prmpt_dwn

bindkey -a "\e[1;3A" mv_prmpt_up
bindkey -e "\e[1;3A" mv_prmpt_up
bindkey -v "\e[1;3A" mv_prmpt_up

bindkey -e "\e[1;3B" mv_prmpt_dwn
bindkey -a "\e[1;3B" mv_prmpt_dwn
bindkey -v "\e[1;3B" mv_prmpt_dwn

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
bindkey -e "\C-w" expand-aliases
bindkey -a "\C-w" expand-aliases
bindkey -v "\C-w" expand-aliases

# Expand by looping through options
bindkey -e 'Tab' menu-complete
bindkey -a 'Tab' menu-complete
bindkey -v 'Tab' menu-complete

# Shift+Tab for reverse
bindkey -e "\e[Z" reverse-menu-complete
bindkey -a "\e[Z" reverse-menu-complete 
bindkey -v "\e[Z" reverse-menu-complete 

if [[ "$TERM" == 'xterm-kitty' ]]; then
    # (Kitty only) Ctrl-tab for variable autocompletion
    bindkey -e "\e[9;5u" complete-word
    bindkey -a "\e[9;5u" complete-word
    bindkey -v "\e[9;5u" complete-word
fi

function exit-zsh(){exit; zle reset-prompt}

zle -N exit-zsh

# Ctrl-q quits terminal
bindkey -e "\C-q" exit-zsh
bindkey -a "\C-q" exit-zsh
bindkey -v "\C-q" exit-zsh

# Ctrl+z is vi-undo (after being unbound in stty) instead of only on Ctrl+_
bindkey -e "\C-z" vi-undo-change
bindkey -a "\C-z" vi-undo-change
bindkey -v "\C-z" vi-undo-change 

# Ctrl-backspace deletes (kills) line backward
bindkey -e "\C-h" backward-kill-word
bindkey -a "\C-h" backward-kill-word
bindkey -v "\C-h" backward-kill-word

# Ctrl-l clears
bindkey -a '\C-l' clear-screen
bindkey -e '\C-l' clear-screen
bindkey -v '\C-l' clear-screen

function delete-first-char() {
    if [[ -n "$BUFFER" ]]; then
        BUFFER=${BUFFER:1}       
        (( CURSOR > 0 )) && (( CURSOR-- ))  
    fi
}

zle -N delete-first-char

# Ctrl-d: Delete first character on line
bindkey -e "\C-d" delete-first-char
bindkey -a "\C-d" delete-first-char
bindkey -v "\C-d" delete-first-char  

# Ctrl+b: (Ctrl+x Ctrl+b emacs mode) is quoted insert - Default Ctrl+v - Gives (f.ex. 'Ctrl-a') back as '^A'
bindkey -e "\C-x\C-b" quoted-insert
bindkey -a "\C-b" quoted-insert
bindkey -v "\C-b" quoted-insert

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
bindkey -a "\C-o" emacs-mode
bindkey -v "\C-o" emacs-mode
bindkey -e "\C-o" vi-ins-mode

# vi-command ' / emacs C-x ' helps with adding quotes to bash strings
function quote-all-zsh() { BUFFER="${BUFFER@Q}"; zle reset-prompt }
zle -N quote-all-zsh
bindkey -e -s '\C-x'\''' quote-all-zsh
bindkey -a -s ''\''' quote-all-zsh
#bindkey -v -s '\C-x'\''' '_quote_all'

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

bindkey -v "\C-e" edit-wo-executing
bindkey -a "v" edit-wo-executing
bindkey -a "\C-e" edit-wo-executing
bindkey -e "\C-e\C-e" edit-wo-executing

# RLWRAP

#if hash rlwrap &> /dev/null; then
#    bindkey -e '"\C-x\C-e" : rlwrap-call-editor'
#    bindkey -a '"\C-e" : rlwrap-call-editor'
#    bindkey -v '"\C-e" : rlwrap-call-editor'
#fi

if hash osc &>/dev/null; then
    
    function osc-copy() {
        echo -n "$BUFFER" | osc copy
    }
    
    function osc-paste() {
        local pasters="$(osc paste)"
        BUFFER="${BUFFER:0:$CURSOR}$pasters${BUFFER:$CURSOR}"
        CURSOR=$((CURSOR + ${#pasters}))
    }
   
    zle -N osc-copy
    zle -N osc-paste

    bindkey -e "\C-s" osc-copy
    bindkey -a "\C-s" osc-copy
    bindkey -v "\C-s" osc-copy

    bindkey -a "\C-v" osc-paste
    bindkey -e "\C-v" osc-paste
    bindkey -v "\C-v" osc-paste

elif ([[ "$XDG_SESSION_TYPE" == 'x11' ]] && hash xclip &>/dev/null) || ([[ "$XDG_SESSION_TYPE" == 'wayland' ]] && hash wl-copy &> /dev/null); then
  
    function clip-copy() {
        if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then  
            echo -n "$BUFFER" | xclip -i -sel c
        elif [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
            echo -n "$BUFFER" | wl-copy
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
    bindkey -e "\C-s" clip-copy
    bindkey -a "\C-s" clip-copy
    bindkey -v "\C-s" clip-copy

    # Ctrl-v: Proper paste
    bindkey -e "\C-v" clip-paste
    bindkey -a "\C-v" clip-paste
    bindkey -v "\C-v" clip-paste

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
    bindkey -e "\C-x\C-j" show-j 
    bindkey -a "\C-j" show-j 
    bindkey -v "\C-j" show-j 
fi

if hash fzf &>/dev/null; then
    
    #if [[ "$TERM" == 'xterm-kitty' ]]; then
    #    # (Kitty only) Ctrl-tab for fzf autocompletion
    #    bindkey -e '"\e[9;5u": " **\t"'
    #    bindkey -a '"\e[9;5u": " **\t"'
    #    bindkey -v '"\e[9;5u": " **\t"'
    #fi

    if type ripgrep-dir &>/dev/null; then
        
        function ripgrep-dir-zsh(){
            ripgrep-dir
            zle reset-prompt
        }
         
        zle -N ripgrep-dir-zsh
        
        # Ctrl-g: Ripgrep function overview
        bindkey -e "\C-g" ripgrep-dir-zsh
        bindkey -a "\C-g" ripgrep-dir-zsh
        bindkey -v "\C-g" ripgrep-dir-zsh
    fi

    if type fzf_rifle &>/dev/null; then
       
        function fzf_rifle-zsh(){
            fzf_rifle
            zle reset-prompt
        }
         
        zle -N fzf_rifle-zsh
       
        # CTRL-F - Paste the selected file path into the command line
        bindkey -e "\C-f" fzf_rifle-zsh
        bindkey -a "\C-f" fzf_rifle-zsh
        bindkey -v "\C-f" fzf_rifle-zsh

        # F4 - Rifle search
        bindkey -e "\eOS" fzf_rifle-zsh
        bindkey -a "\eOS" fzf_rifle-zsh
        bindkey -v "\eOS" fzf_rifle-zsh
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
   
    bindkey -e "\eOQ" ranger-zsh
    bindkey -a "\eOQ" ranger-zsh
    bindkey -v "\eOQ" ranger-zsh
fi

# F3 - lazygit (Git helper)
if hash lazygit &>/dev/null; then
    function lazygit-zsh () {
        lazygit
        zle reset-prompt
    }
    
    zle -N lazygit-zsh
    bindkey -e "\eOR" lazygit-zsh
    bindkey -a "\eOR" lazygit-zsh
    bindkey -v "\eOR" lazygit-zsh
fi

# F5, Ctrl-r - Reload .zshrc
#bind '"\205": re-read-init-file;'
function resource-zsh(){ source ~/.zshrc }
zle -N resource-zsh
bindkey -e "\e[15~" resource-zsh
bindkey -a "\e[15~" resource-zsh 
bindkey -v "\e[15~" resource-zsh 

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

    bindkey -e "\e[17~" fetchbind-zsh
    bindkey -a "\e[17~" fetchbind-zsh 
    bindkey -v "\e[17~" fetchbind-zsh 
    
    unset fetch
fi

# F7 - Htop and alternatives

function htop-btop-zsh(){
    stty sane
    local ansr ansr1 
    if hash btop &>/dev/null; then
         readyn -p "Use btop instead of htop?" ansr 
         if [[ "$ansr" == "y" ]]; then
             readyn -p "Start btop as root?" ansr1 
             if [[ "$ansr1" == "y" ]]; then
                sudo btop
             else 
                btop
             fi
         fi
    
    elif hash bashtop &>/dev/null; then
         readyn -p "Use bashtop instead of htop?" ansr 
         if [[ "$ansr" == "y" ]]; then
             readyn -p "Start bashtop as root?" ansr1 
             if [[ "$ansr1" == "y" ]]; then
                sudo bashtop
             else 
                bashtop
             fi
         fi
    elif hash bpytop &>/dev/null; then
         readyn -p "Use bpytop instead of htop?" ansr 
         if [[ "$ansr" == "y" ]]; then
             readyn -p "Start bpytop as root?" ansr1 
             if [[ "$ansr1" == "y" ]]; then
                sudo bpytop
             else 
                bpytop
             fi
         fi
    fi
    
    if (! hash bpytop &> /dev/null && ! hash bpytop &> /dev/null && ! hash bpytop &> /dev/null) || [[ "$ansr" == 'n' ]]; then
        readyn -p "Start htop as root?" ansr1 && [[ "$ansr1" == "y" ]] && sudo htop || htop
    fi
    zle reset-prompt 
}

zle -N htop-btop-zsh

bindkey -e "\e[18~" htop-btop-zsh
bindkey -a "\e[18~" htop-btop-zsh
bindkey -v "\e[18~" htop-btop-zsh

# F8 - Lazydocker (Docker TUI)
if hash lazydocker &>/dev/null; then
    function lazydocker-zsh () {
        lazydocker
        zle reset-prompt
    }
    
    zle -N lazydocker-zsh
    bindkey -e "\e[19~" lazydocker-zsh
    bindkey -a "\e[19~" lazydocker-zsh 
    bindkey -v "\e[19~" lazydocker-zsh 
fi
