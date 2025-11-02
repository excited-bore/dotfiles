# https://code.visualstudio.com/

hash code &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash code &> /dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        if ! test -f $TOP/checks/check_AUR.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
        else 
            . $TOP/checks/check_AUR.sh
        fi
        if test -n "$AUR_ins_y"; then 
            eval "$AUR_ins_y" visual-studio-code-bin
        else 
            eval "$AUR_ins_y" visual-studio-code-bin
        fi
    elif [[ $distro_base == "Debian" ]]; then
        if test -z $(apt list --installed software-properties-common 2> /dev/null); then
            eval "$pac_ins_y software-properties-common "
        fi
        if test -z $(apt list --installed apt-transport-https 2> /dev/null); then
            eval "$pac_ins_y apt-transport-https "
        fi
        wget-curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - 
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
