# !/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type rg &> /dev/null; then 
    if test $distro_base == "Arch"; then
        sudo pacman -S ripgrep
    elif test $distro_base == "Debian"; then
        sudo apt install ripgrep 
    fi
fi

if test -f ripgrep/.ripgreprc; then
    file=ripgrep/.ripgreprc
else
    dir1="$(mktemp -d -t rg-XXXXXXXXXX)"
    curl -s -o $dir1/.ripgreprc https://raw.githubusercontent.com/excited-bore/dotfiles/main/ripgrep/.ripgreprc
    file=$dir1/.ripgreprc
fi

if ! test -f ~/.ripgreprc; then 
    function ripgrep_conf(){
        cp -fbv $file $HOME 
    } 
    yes_edit_no ripgrep_conf "$file" "Install .ripgreprc at $HOME?" "yes" "GREEN"; 
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether root dir exists and whether it contains a .ripgreprc config file"
if sudo test -d /root && ! sudo test -f /root/.ripgreprc; then 
    function ripgrep_conf_r(){
        sudo cp -fbv $file /root 
    } 
    yes_edit_no ripgrep_conf_r "$file" "Install .ripgreprc at /root?" "yes" "GREEN"; 
fi

