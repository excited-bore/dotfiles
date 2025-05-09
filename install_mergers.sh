DLSCRIPT=1

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

SCRIPT_DIR=$(get-script-dir)

reade -Q "GREEN" -i "vscode mergiraf fac meld diffmerge kompare kdiff3 p4merge sublime nvim" -p "Which to install? [Vscode/mergiraf/fac(fixallconflicts)/meld/diffmerge/kdiff3/kompare/p4merge/sublime(sublime merge)/nvim]: " merger

if [[ $merger == 'nvim' ]] ;then
   if ! type nvim &> /dev/null; then
        if ! test -f install_neovim.sh; then
            if type curl &>/dev/null; then
                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_neovim.sh)
            else
                printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                return 1 || exit 1
            fi
        else
            . ./install_neovim.sh
        fi 
   fi

elif [[ $merger == 'vscode' ]] ;then
   if ! type code &> /dev/null; then
        if ! test -f install_visual_studio_code.sh; then
            if type curl &>/dev/null; then
                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_visual_studio_code.sh)
            else
                printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                return 1 || exit 1
            fi
        else
            . ./install_visual_studio_code.sh
        fi 
   fi

elif [[ $merger == 'fac' ]] ;then
    if ! type go &> /dev/null; then
        if ! test -f install_go.sh; then
            if type curl &>/dev/null; then
                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_go.sh)
            else
                printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                return 1 || exit 1
            fi
        else
            . ./install_go.sh
        fi
    fi
    go install github.com/mkchoi212/fac@latest 

elif [[ $merger == 'mergiraf' ]] ;then
    if ! type cargo &> /dev/null; then
        if ! test -f install_cargo.sh; then
            if type curl &>/dev/null; then
                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)
            else
                printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                return 1 || exit 1
            fi
        else
            . ./install_cargo.sh
        fi
    fi
    cargo install --locked mergiraf

elif [[ $merger == 'meld' ]] ;then
    if [[ $machine == 'Mac' ]]; then
        if ! type brew &> /dev/null; then
            if ! test -f install_brew.sh; then
                if type curl &>/dev/null; then
                    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_brew.sh)
                else
                    printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                    return 1 || exit 1
                fi
            else
                . ./install_brew.sh
            fi
        fi
        brew install meld 
    elif [[ $distro_base == 'Debian' ]]; then
        sudo apt install meld
    elif [[ $distro_base == 'Arch' ]]; then
        sudo pacman -S meld
    elif [[ $distro_base == 'RedHat' ]]; then
        sudo dnf install meld 
    else
        if ! type pipx &> /dev/null; then
            if ! test -f install_pipx.sh; then
                if type curl &>/dev/null; then
                    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)
                else
                    printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                    return 1 || exit 1
                fi
            else
                . ./install_pipx.sh
            fi
        fi
        pipx install meld
    fi

elif [[ $merger == 'kdiff3' ]] ;then
    
    if ! type kdiff3 &> /dev/null; then
        if [[ $distro_base == 'Debian' ]]; then
            sudo apt install kdiff3
        elif [[ $distro_base == 'Arch' ]]; then
            sudo pacman -S kdiff3
        elif [[ $machine == 'Linux' ]]; then
            if ! test -f install_flatpak.sh; then
                if type curl &>/dev/null; then
                    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_flatpak.sh)
                else
                    printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                    return 1 || exit 1
                fi
            else
                . ./install_flatpak.sh
            fi
            flatpak install kdiff3 
        fi 
    fi
elif [[ $merger == 'diffmerge' ]] ;then
   if ! command -v diffmerge  &> /dev/null; then
        if [[ $distro_base == 'Arch' ]]; then
            if ! test -f checks/check_AUR.sh; then
                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
            else
                . ./checks/check_AUR.sh
            fi
            eval "$AUR_ins diffmerge" 
        elif [[ $distro_base == 'Debian' ]]; then
            if ! command -v wget &> /dev/null || ! command -v jq &> /dev/null; then
                echo "Next $(tput setaf 1)sudo$(tput sgr0) will install 'wget' and 'jq'"
                sudo apt install -y jq wget 
            fi

            if ! test -f aliases/.bash_aliases.d/git.sh; then
                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/git.sh)
            else
                . ./aliases/.bash_aliases.d/git.sh
            fi
            #get-latest-releases-github 'https://github.com/sourcegear/diffmerge'  
        fi
   fi

elif [[ $merger == 'kompare' ]] ;then
    if ! type kdiff3 &> /dev/null; then
        if [[ $distro_base == 'Debian' ]]; then
            sudo apt install kompare
        elif [[ $distro_base == 'Arch' ]]; then
            sudo pacman -S kompare
        elif [[ $machine == 'Linux' ]]; then
            if ! test -f install_flatpak.sh; then
                if type curl &>/dev/null; then
                    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_flatpak.sh)
                else
                    printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                    return 1 || exit 1
                fi
            else
                . ./install_flatpak.sh
            fi
            flatpak install kompare 
        fi 
    fi

elif [[ $merger == 'p4merge' ]] ;then

    if ! type kdiff3 &> /dev/null; then
        if [[ $distro_base == 'Arch' ]]; then
            if ! test -f checks/check_AUR.sh; then
                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
            else 
                . ./checks/check_AUR.sh
            fi
            if test -n "$AUR_ins"; then
                eval "$AUR_ins p4merge-bin"
            fi
        else
            test -z $TMPDIR && TMPDIR 
            curl https://cdist2.perforce.com/perforce/r19.1/bin.linux26x86_64/p4v.tgz -o $TMPDIR/p4v.tgz 
            sudo mkdir -p /opt/p4merge
            sudo tar -zxvf $TMPDIR/p4v.tgz -C /opt/p4merge --strip-components=1
            sudo mv /opt/p4merge/bin/p4merge /usr/local/bin/p4merge
        fi
    fi

elif [[ $merger == 'sublime' ]] ;then

    if ! test -f /opt/sublime_merge/sublime_merge; then
        if [[ $distro_base == 'Debian' ]]; then
            curl https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
            if test -z $(apt list --installed apt-transport-https 2> /dev/null); then
                eval "$pac_ins apt-transport-https "
            fi
            if [[ $stabl_dev == 'stable' ]]; then
                echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
            elif [[ $stabl_dev == 'dev' ]]; then
                echo "deb https://download.sublimetext.com/ apt/dev/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
            fi
            sudo apt-get update
            sudo apt-get install sublime-merge

        elif [[ $distro_base == 'Arch' ]]; then
            # Key 
            test -z $TMPDIR && TMPDIR=$(mktemp -d)
            curl -O https://download.sublimetext.com/sublimehq-pub.gpg --output-dir $TMPDIR 
            sudo pacman-key --add $TMPDIR/sublimehq-pub.gpg 
            sudo pacman-key --lsign-key 8A8F901A 
            command rm $TMPDIR/sublimehq-pub.gpg
            reade -Q 'GREEN' -i 'stable dev' -p 'Stable or development build? [Stable/dev]: ' stabl_dev 
            if [[ $stabl_dev == 'stable' ]]; then
                if [[ $arch == 'arm64' ]]; then
                    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/aarch64" | sudo tee -a /etc/pacman.conf 
                elif ! [[ $arch =~ 'arm' ]]; then
                    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
                fi
            elif [[ $stabl_dev == 'dev' ]]; then
                if [[ $arch == 'arm64' ]]; then
                    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/dev/aarch64" | sudo tee -a /etc/pacman.conf 
                elif ! [[ $arch =~ 'arm' ]]; then
                    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/dev/x86_64" | sudo tee -a /etc/pacman.conf
                fi
            fi
            sudo pacman -Syu sublime-merge

        elif [[ $distro_base == 'RedHat' ]]; then
            if [[ $arch =~ 'arm' ]]; then
                printf "${MAGENTA}There are sadly no RPM packages available for arm-based systems${normal}\n" 
            else
                sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg 
                reade -Q 'GREEN' -i 'stable dev' -p 'Stable or development build? [Stable/dev]: ' stabl_dev
                rpmsublm='n' 
                type dnf5 &> /dev/null && readyn -p 'Use RPM package/Dnf5?' rpmsublm

                if type dnf &> /dev/null; then

                    if [[ $stabl_dev == 'stable' ]]; then
                        if [[ $rpmsublm == 'y' ]]; then
                            sudo dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo 
                        else
                            sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
                        fi
                    elif [[ $stabl_dev == 'dev' ]]; then
                        if [[ $rpmsublm == 'y' ]]; then
                            sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo
                        else
                            sudo dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo
                        fi
                    fi
                    sudo dnf install sublime-merge

                elif type yum &> /dev/null; then
                    if [[ $stabl_dev == 'stable' ]]; then
                        sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
                    elif [[ $stabl_dev == 'dev' ]]; then
                        sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo
                    fi
                    sudo yum install sublime-merge
                fi 
             fi

        elif [[ $distro_base == 'openSUSE' ]]; then

            if [[ $arch =~ 'arm' ]]; then
                printf "${MAGENTA}There are sadly no RPM packages available for arm-based systems${normal}\n" 
            else
                if [[ $stabl_dev == 'stable' ]]; then
                    sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
                elif [[ $stabl_dev == 'dev' ]]; then
                    sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo
                fi
                sudo zypper install sublime-merge 
            fi 
        fi
    fi 
fi
