# Shell (bash, zsh) completions, aliases, keybinds and other config 

hash bash &> /dev/null && hash zsh &> /dev/null && SYSTEM_UPDATED="TRUE"

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! [[ -f $TOP/checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi


# Bash

if ! hash bash &> /dev/null; then
   readyn -p "${CYAN}Bash${GREEN} is not installed. Install ${CYAN}Bash${GREEN}?" ns_bash
   if [[ "$ns_bash" == 'y' ]]; then
        eval "${pac_ins_y} bash" 
   fi
else
    echo "${CYAN}Bash${GREEN} installed!${normal}"
fi
unset ns_bash

# Zsh

if ! hash zsh &> /dev/null; then
   readyn -p "${CYAN}Zsh${GREEN} is not installed. Install ${CYAN}Zsh${GREEN}?" ns_zsh
   if [[ "$ns_zsh" == 'y' ]]; then
        eval "${pac_ins_y} zsh" 
   fi
else
    echo "${CYAN}Zsh${GREEN} installed!${normal}"
fi
unset ns_zsh

current_shell=$(grep '^'$USER: /etc/passwd | cut -d: -f7)

#list-available-shells="cat /etc/shells | sed '/#/d; /^$/d'"

if hash fzf &> /dev/null; then
    set-default-shell-user(){
        local newshell=$(cat /etc/shells | sed '/#/d; /^$/d' | fzf --reverse --height 33%) 
        if ! test -z "$newshell"; then
            chsh -s $newshell $USER 
            echo "Log out and in again to make the change take effect" 
        fi
    } 
elif type reade &> /dev/null; then  
    set-default-shell-user(){
        local newshell shells=($(cat /etc/shells | sed '/#/d; /^$/d')) 
        echo "${CYAN}Available shells:${normal}"
        for i in ${shells[@]}; do 
            printf "${GREEN}\t-$i${normal}\n" 
        done 
        reade -Q "GREEN" -i "$shells" -p "Which shell do you pick?: " newshell  
        if ! test -z "$newshell"; then
            chsh -s $newshell $USER 
            echo "Log out and in again to make the change take effect" 
        fi
    } 
fi

echo "${CYAN}Current shell: ${GREEN}$current_shell${normal}"

readyn -p "Change this (Only configuration is given for (/usr/bin/)\|(/bin/)bash and (/usr/bin/)\|(/bin/)zsh)?" -c "! [[ $current_shell == '/bin/bash' || $current_shell == '/usr/bin/bash' || $current_shell == '/bin/zsh' || $current_shell == '/usr/bin/zsh' ]]" chshell
if [[ "$chshell" == 'y' ]]; then
    set-default-shell-user 
fi

unset current_shell chshell

BASH_C='' ZSH_C='' BASH_C_G='' ZSH_C_G='' BASH_A="" ZSH_A="" BASH_A_G="" ZSH_A_G=""

# Completions

if hash bash &> /dev/null && (! test -f ~/.bashrc || ! test -d ~/.bash_completion.d || ! test -f ~/.bash_completion || ! test -f /etc/bash.bashrc || ! test -d /usr/share/bash-completion/completions/ || ! test -f /usr/share/bash-completion/bash_completion) && hash zsh &> /dev/null && (! test -f ~/.zshrc || ! test -d ~/.zsh_completion.d/site-functions || ! test -f ~/.zsh_completion || ! test -f /etc/zshrc || ! test -d /usr/share/zsh/site-functions/ || ! test -f /etc/zsh_completion); then
   reade -Q 'GREEN' -i 'both bash zsh' -p "Create directories and install files for completion functions for ${CYAN}Bash${GREEN}, ${CYAN}Zsh${GREEN} or both? [Both/bash/zsh]: " bash_zsh_comp
elif hash bash &> /dev/null && (! test -f ~/.bashrc || ! test -d ~/.bash_completion.d || ! test -f ~/.bash_completion || ! test -f /etc/bash.bashrc || ! test -d /usr/share/bash-completion/completions/ || ! test -f /usr/share/bash-completion/bash_completion); then
   readyn -p "Install completion functions for ${CYAN}Bash${GREEN}?" bash_zsh_comp
   [[ "$bash_zsh_comp" == 'y' ]] && bash_zsh_comp='bash' 
elif hash zsh &> /dev/null && (! test -f ~/.zshrc || ! test -d ~/.zsh_completion.d/site-functions || ! test -f ~/.zsh_completion || ! test -f /etc/zshrc || ! test -d /usr/share/zsh/site-functions/ || ! test -f /etc/zsh_completion); then
   readyn -p "Install completion functions for ${CYAN}Zsh${GREEN}?" bash_zsh_comp
   [[ "$bash_zsh_comp" == 'y' ]] && bash_zsh_comp='zsh' 
fi

if [[ "$bash_zsh_comp" == 'both' || "$bash_zsh_comp" == 'bash' ]]; then
    BASH_C="1" 
    if ! test -f /etc/bash.bashrc || ! test -d /usr/share/bash-completion/completions/ || ! test -f /usr/share/bash-completion/bash_completion; then
        readyn -p "Configure ${CYAN}bash${GREEN} completions ${CYAN}systemwide/for all users${GREEN}?" bash_g
        if [[ "$bash_g" == 'y' ]]; then
            BASH_C_G='1'
        fi
    fi
fi
if [[ "$bash_zsh_comp" == 'both' || "$bash_zsh_comp" == 'zsh' ]]; then
    ZSH_C="1" 
    if ! test -f /etc/zshrc || ! test -d /usr/share/bash-completion/completions/ || ! test -f /etc/zsh_completion; then
        readyn -p "Configure ${CYAN}zsh${GREEN} completions ${CYAN}systemwide/for all users${GREEN}?" zsh_g
        if [[ "$zsh_g" == 'y' ]]; then
            ZSH_C_G='1'
        fi
    fi
fi

unset bash_zsh_comp 

# Aliases

if hash bash &> /dev/null && (! test -f ~/.bashrc || ! test -d ~/.aliases.d || ! test -d ~/.bash_aliases.d || ! test -f ~/.bash_aliases || ! test -f /etc/bash.bashrc || ! test -d /etc/aliases.d || ! test -d /etc/bash_aliases.d || ! test -f /etc/bash_aliases) && hash zsh &> /dev/null && (! test -f ~/.zshrc || ! test -d ~/.aliases.d || ! test -d ~/.zsh_aliases.d || ! test -f ~/.zsh_aliases || ! test -f /etc/zshrc || ! test -d /etc/aliases.d || ! test -d /etc/zsh_aliases.d || ! test -f /etc/zsh_aliases); then
   reade -Q 'GREEN' -i 'both bash zsh' -p "Create directories and install files filled with aliases/functions for ${CYAN}Bash${GREEN}, ${CYAN}Zsh${GREEN} or both? [Both/bash/zsh]: " bash_zsh_alias
elif hash bash &> /dev/null && (! test -f ~/.bashrc || ! test -d ~/.aliases.d || ! test -d ~/.bash_aliases.d || ! test -f ~/.bash_aliases || ! test -f /etc/bash.bashrc || ! test -d /etc/aliases.d || ! test -d /etc/bash_aliases.d || ! test -f /etc/bash_aliases); then
   readyn -p "Install aliases/functions for ${CYAN}Bash${GREEN}?" bash_zsh_alias
   [[ "$bash_zsh_alias" == 'y' ]] && bash_zsh_alias='bash' 
elif hash zsh &> /dev/null && (! test -f ~/.zshrc || ! test -d ~/.aliases.d || ! test -d ~/.zsh_aliases.d || ! test -f ~/.zsh_aliases || ! test -f /etc/zshrc || ! test -d /etc/aliases.d || ! test -d /etc/zsh_aliases.d || ! test -f /etc/zsh_aliases); then
   readyn -p "Install aliases/functions for ${CYAN}Zsh${GREEN}?" bash_zsh_alias
   [[ "$bash_zsh_alias" == 'y' ]] && bash_zsh_alias='zsh' 
fi

if [[ "$bash_zsh_alias" == 'both' || "$bash_zsh_alias" == 'bash' ]]; then
    BASH_A="1" 
    if ! test -f /etc/bash.bashrc || ! test -d /etc/aliases.d || ! test -d /etc/bash_aliases.d || ! test -f /etc/bash_aliases; then
        readyn -p "Install aliases for ${CYAN}bash systemwide/for all users${GREEN}?" bash_g
        if [[ "$bash_g" == 'y' ]]; then
            BASH_A_G='1'
        fi
    fi
fi
if [[ "$bash_zsh_alias" == 'both' || "$bash_zsh_alias" == 'zsh' ]]; then
    ZSH_A="1" 
    if ! test -f /etc/zshrc || ! test -d /etc/aliases.d || ! test -d /etc/zsh_aliases.d || ! test -f /etc/zsh_aliases; then
        readyn -p "Install aliases for ${CYAN}zsh systemwide/for all users${GREEN}?" zsh_g
        if [[ "$zsh_g" == 'y' ]]; then
            ZSH_A_G='1'
        fi
    fi
fi


if ! test -f $TOP/checks/check_completions.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions.sh)
else 
    source $TOP/checks/check_completions.sh
fi

if [[ -n "$BASH" ]] || [ -d ~/.bash_completion.d ]; then

    # Bash Completion
   
    bsh_cmp=$(eval "$pac_ls_ins bash-completion 2> /dev/null")
    if test -z "$bsh_cmp"; then
        readyn -p "Bash completions package is not installed (Adds completion to a lot of commands). Install ${CYAN}Bash-completion${GREEN}?" ns_bashc
        if [[ "$ns_bashc" == 'y' ]]; then
            eval "$pac_ins_y bash-completion" 
        fi
    fi
    unset bsh_cmp

    # If bash-completion is installed we want to avoid that it get's sourced more then once 
    bsh_cmp=$(eval "$pac_ls_ins bash-completion 2> /dev/null")
    if test -n "$bsh_cmp" && grep -q '\. /usr/share/bash-completion/bash_completion' /etc/bash.bashrc && grep -q '\. /usr/share/bash-completion/bash_completion' ~/.bashrc; then
        sed -i '/. \/usr\/share\/bash-completion\/bash_completion/d' ~/.bashrc 
    fi

    # Bash alias completions

    readyn -p "Install bash completions for aliases (complete_alias.bash) in ~/.bash_completion.d?" -c "! [ -f ~/.bash_completion.d/complete_alias.bash ]" compl
    if [[ "y" == "$compl" ]]; then
        if ! [[ -f $TOP/shell/install_bashalias_completions.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/install_bashalias_completions.sh)
        else
            . $TOP/shell/install_bashalias_completions.sh
        fi
    fi
    unset compl
    
fi

if [[ -n "$ZSH" ]] || [ -d ~/.zsh_completion.d ]; then

    if ! [[ -d ~/.zsh_completion.d/ ]]; then
        mkdir ~/.zsh_completion.d/
    fi

    if ! [[ -f ~/.zsh_completion ]]; then
        if ! [[ -f $TOP/shell/completions/.zsh_completion ]]; then
            curl-wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/completions/.zsh_completion > ~/.zsh_completion 
        else
            cp $TOP/shell/completions/.zsh_completion ~/
        fi 
    fi

    # Make sure the ~/.zsh_completion sources BEFORE ~/.zsh_aliases to prevent zshalias-completions from breaking
    if ! grep -q "~/.zsh_completion" ~/.zshrc; then
        if grep -q "[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases" ~/.zshrc || grep -q '^if \[\[ -f ~/.zsh_aliases \]\]; then' ~/.zshrc; then
            if grep -q "[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases" ~/.zshrc; then
                sed -i 's|\([[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases\)|[[ -f ~/.zsh_completion ]] \&\& source ~/.zsh_completion\n\n\1|' ~/.zshrc 
            else
                sed -i 's|\(\^if [[ -f ~/.zsh_aliases ]]; then\)|[[ -f ~/.zsh_completion ]] \&\& source ~/.zsh_completion\n\n\1|' ~/.zshrc 
            fi
        else
            printf "\n[[ -f ~/.zsh_completion ]] && source ~/.zsh_completion\n\n" >> ~/.zshrc
        fi
    fi
     

    # ZSH Completions
    
    zsh_cmp=$(eval "$pac_ls_ins zsh-completions 2> /dev/null") 
    if test -z "$zsh_cmp"; then
        readyn -p "Zsh completions package is not installed (Adds completion to a lot of commands). Install ${CYAN}Zsh-completions${GREEN}?" ns_zshc
        if [[ "$ns_zshc" == 'y' ]]; then
            eval "$pac_ins_y zsh-completions" 
        fi
    fi
    unset zsh_cmp ns_zshc

    # FZF-tab completion

    if ! test -f ~/.zsh_completion.d/fzf-tab.plugin.zsh; then
        readyn -n -p "Fzf completion for Zsh is not installed? Install ${CYAN}Fzf-tab${GREEN}?" fzf_tab
        if [[ "$fzf_tab" == 'y' ]]; then
            git clone https://github.com/Aloxaf/fzf-tab ~/.zsh_completion.d/fzf-tab
            mv ~/.zsh_completion.d/fzf-tab/fzf-tab.plugin.zsh ~/.zsh_completion.d
            sed -i 's|source "${0:A:h}/fzf-tab.zsh"|source "${0:A:h}/fzf-tab/fzf-tab.zsh"|g' ~/.zsh_completion.d/fzf-tab.plugin.zsh
        fi
    fi
    unset fzf_tab 
fi

# Python completions

readyn -p "Install python completions in ~/.bash_completion.d?" -c "! hash activate-global-python-argcomplete &> /dev/null" pycomp
if [[ "y" == "$pycomp" ]]; then
    if ! [[ -f $TOP/shell/install_python_completions.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/install_python_completions.sh)
    else
        . $TOP/shell/install_python_completions.sh
    fi
fi
unset pycomp

# Aliases

if [[ -n "$BASH" || -n "$ZSH" ]] && ! test -d ~/.aliases.d; then
   mkdir ~/.aliases.d 
fi

if [[ -n "$BASH" ]]; then
    if ! [ -f ~/.bash_aliases ]; then
        if ! [ -f $TOP/shell/aliases/.bash_aliases ]; then
            curl-wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases > ~/.bash_aliases 
        else
            cp $TOP/shell/aliases/.bash_aliases ~/
        fi 
    fi

    if [[ -f ~/.bashrc ]] && ! grep -q '\[ -f ~/.bash_aliases \] && source ~/.bash_aliases' ~/.bashrc; then
        if grep -q '^if \[ -f ~/.bash_aliases \]; then' ~/.bashrc; then
            sed -i -e 's|\(if \[ -f \~/.bash_aliases \]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.bash_aliases later down ~/.bashrc\n\n#\1|g' -e 's|\(^\s*\. ~/.bash_aliases\)|#\1|' ~/.bashrc
            ubbashrcfi="$(awk '/\. ~\/.bash_aliases/{print NR+1};' ~/.bashrc)" 
            sed -i "$ubbashrcfi s/^fi/#fi/" ~/.bashrc   
            unset ubbashrcfi 
        fi
       
        if grep -q '\[ -f ~/.bash_keybinds \]' ~/.bashrc; then
            sed -i 's|\(\[ -f \~/.bash_keybinds \] \&\& source \~/.bash_keybinds\)|\[ -f \~/.bash_aliases \] \&\& source \~/.bash_aliases\n\n\1|g' ~/.bashrc
        else
            echo '[ -f ~/.bash_aliases ] && source ~/.bash_aliases' >> ~/.bashrc
        fi
    fi
     
fi
    
if [[ -n "$ZSH" ]]; then
    if ! [ -f ~/.zsh_aliases ]; then
        if ! [[ -f $TOP/shell/aliases/.zsh_aliases ]]; then
            curl-wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.zsh_aliases > ~/.zsh_aliases  
        else
            cp $TOP/shell/aliases/.zsh_aliases ~/
        fi 
    fi

    if [[ -f ~/.zshrc ]] && ! grep -q '\[ -f ~/.zsh_aliases \] && source ~/.zsh_aliases' ~/.zshrc; then
        if grep -q '^if \[ -f ~/.zsh_aliases \]; then' ~/.zshrc; then
            sed -i -e 's|\(if \[ -f \~/.zsh_aliases \]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.zsh_aliases later down ~/.zshrc\n\n#\1|g' -e 's|\(^\s*\. ~/.zsh_aliases\)|#\1|' ~/.zshrc
            ubzshrcfi="$(awk '/\. ~\/.zsh_aliases/{print NR+1};' ~/.zshrc)" 
            sed -i "$ubzshrcfi s/^fi/#fi/" ~/.zshrc   
            unset ubzshrcfi 
        fi
       
        if grep -q '\[ -f ~/.zsh_keybinds \]' ~/.zshrc; then
            sed -i 's|\(\[ -f \~/.zsh_keybinds \] \&\& source \~/.zsh_keybinds\)|\[ -f \~/.zsh_aliases \] \&\& source \~/.zsh_aliases\n\n\1|g' ~/.zshrc
        else
            echo '[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases' >> ~/.zshrc
        fi
    fi
fi

if [ -n "$BASH" ] && [ -z "$ZSH" ]; then
    readyn -p "Install aliases (and functions) for ${CYAN}Bash${GREEN}?" scripts
elif [ -n "$ZSH" ] && [ -z "$BASH" ]; then
    readyn -p "Install aliases (and functions) for ${CYAN}Zsh${GREEN}?" scripts
elif [ -n "$ZSH" ] && [ -n "$BASH" ]; then
    readyn -p "Install aliases (and functions) for ${CYAN}Bash${GREEN} and ${CYAN}Zsh${GREEN}?" scripts
fi

if [[ "y" == "$scripts" ]]; then
    if ! [[ -f $TOP/shell/install_shell_aliases.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/install_shell_aliases.sh)
    else
        . $TOP/shell/install_shell_aliases.sh
    fi
fi

# Hhighlighter (or just h)

readyn -c "! test -f ~/.aliases.d/h.sh" -p "Install hhighlighter (or just h)? (A tiny utility to highlight multiple keywords with different colors in a textoutput)" h
if [[ "y" == "$h" ]]; then
    if ! [[ -f $TOP/shell/install_hhighlighter.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/install_hhighlighter.sh)
    else
        . $TOP/shell/install_hhighlighter.sh
    fi
fi
unset h

# Keybinds

if ! [[ -f $TOP/shell/install_shell_keybinds.sh ]]; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/install_shell_keybinds.sh)
else
    . $TOP/shell/install_shell_keybinds.sh
fi


if [[ -n "$BASH" ]]; then
    
    # Bash Preexec

    readyn -p "Install pre-execution hooks for bash in ~/.bash_preexec?" -c "! [ -f ~/.bash_preexec.sh ]" bash_preexec
    if [[ "y" == "$bash_preexec" ]]; then
        if ! [[ -f $TOP/shell/install_bash_preexec.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/install_bash_preexec.sh)
        else
            . $TOP/shell/install_bash_preexec.sh
        fi
    fi
    unset bash_preexec


    # Make sure bash_preexec is sourced last

    if test -f ~/.bash_profile; then
        if grep -q '~/.bash_preexec' ~/.bash_profile && ! [[ "$(tail -1 ~/.bash_profile)" =~ '~/.bash_preexec' ]]; then
            sed -i '/[ -f ~\/.bash_preexec ] && source ~\/.bash_preexec/d' ~/.bash_profile
            printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" >>~/.bash_profile
        fi
    fi

    if test -f ~/.bashrc; then
        if grep -q '~/.bash_preexec' ~/.bashrc && ! [[ "$(tail -1 ~/.bashrc)" =~ '~/.bash_preexec' ]]; then
            sed -i '/[ -f ~\/.bash_preexec ] && source ~\/.bash_preexec/d' ~/.bashrc
            printf "[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" >>~/.bashrc
        fi
    fi
fi

[[ -n "$BASH" && -n "$BASH_VERSION" ]] && source ~/.bashrc &>/dev/null
[[ -n "$ZSH" && -n "$ZSH_VERSION" ]] && source ~/.zshrc &>/dev/null
