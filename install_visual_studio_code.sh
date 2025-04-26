#/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

if ! type code &> /dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        if ! test -f checks/check_AUR.sh; then
            source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
        else 
            . ./checks/check_AUR.sh
        fi
        if test -n "$AUR_ins"; then 
            eval "$AUR_ins" visual-studio-code-bin
        fi
    elif [[ $distro_base == "Debian" ]]; then
        if ! type wget &> /dev/null; then
           eval "$pac_ins wget"
        fi
        if test -z $(apt list --installed software-properties-common 2> /dev/null); then
            eval "$pac_ins software-properties-common "
        fi
        if test -z $(apt list --installed apt-transport-https 2> /dev/null); then
            eval "$pac_ins apt-transport-https "
        fi
        wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - 
        sudo add-apt-repository "deb [arch=$arch] https://packages.microsoft.com/repos/vscode stable main" 
        sudo apt update 
        eval "$pac_ins code"
    elif [[ $distro_base == 'RedHat' ]]; then
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null 
        if type dnf &> /dev/null; then 
            dnf check-update 
            sudo dnf install code
        elif type yum &> /dev/null; then
            yum check-update
            sudo yum install code 
        fi
    elif [[ $distro_base == 'openSUSE' ]]; then  
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/zypp/repos.d/vscode.repo > /dev/null
        sudo zypper install code
    elif type nix-env &> /dev/null; then
        nix-env -i vscode
    fi 
fi
