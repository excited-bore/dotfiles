# https://code.visualstudio.com/
# https://neovim.io/doc/user/diff.html#_4.-diff-copying
# https://mergiraf.org/
# https://meldmerge.org/
# https://kdiff3.sourceforge.net/
# https://github.com/sourcegear/diffmerge
# https://apps.kde.org/kompare/
# https://www.perforce.com/products/helix-core-apps/merge-diff-tool-p4merge
# https://www.sublimemerge.com/

hash code &> /dev/null && hash nvim &> /dev/null && hash fac &> /dev/null && hash mergiraf &> /dev/null && hash meld &> /dev/null && hash diffmerge &> /dev/null && hash kdiff3 &> /dev/null && hash kompare &> /dev/null && hash p4merge &> /dev/null && hash smerge &> /dev/null && SYSTEM_UPDATED='TRUE' 

TOP=$(git rev-parse --show-toplevel)

if ! [[ -f $TOP/checks/check_all.sh ]]; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

reade -Q "GREEN" -i "vscode mergiraf fac meld diffmerge kompare kdiff3 p4merge sublime nvim" -p "Which to install? [Vscode/mergiraf/fac(fixallconflicts)/meld/diffmerge/kdiff3/kompare/p4merge/sublime(sublime merge)/nvim]: " merger

if [[ $merger == 'nvim' ]] ;then
   if ! hash nvim &> /dev/null; then
        if ! [[ -f $TOP/cli-tools/install_neovim.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_neovim.sh)
        else
            . $TOP/cli-tools/install_neovim.sh
        fi 
   fi

elif [[ $merger == 'vscode' ]] ;then
   if ! hash code &> /dev/null; then
        if ! [[ -f $TOP/install_visual_studio_code.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_visual_studio_code.sh)
        else
            . $TOP/install_visual_studio_code.sh
        fi 
   fi

elif [[ $merger == 'fac' ]] ;then
    if ! hash go &> /dev/null || ! [[ $PATH =~ "$(go env GOPATH)/bin" ]]; then
        if ! [[ -f $TOP/cli-tools/pkgmngrs/install_go.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_go.sh)
        else
            . $TOP/cli-tools/pkgmngrs/install_go.sh
        fi
    fi
    if ! hash fac &> /dev/null; then
        go install github.com/mkchoi212/fac@latest 
    fi

elif [[ $merger == 'mergiraf' ]] ;then
    if ! hash cargo &> /dev/null; then
        if ! [[ -f $TOP/cli-tools/pkgmngrs/install_cargo.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_cargo.sh)
        else
            . $TOP/cli-tools/pkgmngrs/install_cargo.sh
        fi
    fi
    cargo install --locked mergiraf

elif [[ $merger == 'meld' ]] ;then
    if [[ $machine == 'Mac' ]]; then
        if ! hash brew &> /dev/null; then
            if ! [[ -f $TOP/cli-tools/pkgmngrs/install_brew.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_brew.sh)
            else
                . $TOP/cli-tools/pkgmngrs/install_brew.sh
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
        if ! hash pipx &> /dev/null; then
            if ! [[ -f $TOP/cli-tools/pkgmngrs/install_pipx.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_pipx.sh)
            else
                . $TOP/cli-tools/pkgmngrs/install_pipx.sh
            fi
        fi
        pipx install meld
    fi

elif [[ $merger == 'kdiff3' ]] ;then
    
    if ! hash kdiff3 &> /dev/null; then
        if [[ $distro_base == 'Debian' ]]; then
            sudo apt install kdiff3
        elif [[ $distro_base == 'Arch' ]]; then
            sudo pacman -S kdiff3
        elif [[ $machine == 'Linux' ]]; then
            if ! [[ -f cli-tools/pkgmngrs/install_flatpak.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_flatpak.sh)
            else
                . cli-tools/pkgmngrs/install_flatpak.sh
            fi
            flatpak install kdiff3 
        fi 
    fi
elif [[ $merger == 'diffmerge' ]] ;then
   if ! hash diffmerge &> /dev/null; then
        if [[ $distro_base == 'Arch' ]]; then
            if ! [[ -f $TOP/checks/check_AUR.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
            else
                . $TOP/checks/check_AUR.sh
            fi
            eval "$AUR_ins_y diffmerge" 
        elif [[ $distro_base == 'Debian' ]]; then
            if ! hash wget &> /dev/null || ! hash jq &> /dev/null; then
                echo "Next $(tput setaf 1)sudo$(tput sgr0) will install 'wget' and 'jq'"
                sudo apt install -y jq wget 
            fi

            if ! [[ -f $TOP/shell/aliases/.aliases.d/git.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.aliases.d/git.sh)
            else
                . $TOP/shell/aliases/.aliases.d/git.sh
            fi
            #get-latest-releases-github 'https://github.com/sourcegear/diffmerge'  
        fi
   fi

elif [[ $merger == 'kompare' ]] ;then
    if ! hash kompare &> /dev/null; then
        if [[ $distro_base == 'Debian' ]]; then
            sudo apt install kompare
        elif [[ $distro_base == 'Arch' ]]; then
            sudo pacman -S kompare
        elif [[ $machine == 'Linux' ]]; then
            if ! [[ -f $TOP/cli-tools/pkgmngrs/install_flatpak.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_flatpak.sh)
            else
                . $TOP/cli-tools/pkgmngrs//install_flatpak.sh
            fi
            flatpak install kompare 
        fi 
    fi

elif [[ $merger == 'p4merge' ]] ;then

    if ! hash p4merge &> /dev/null; then
        if [[ $distro_base == 'Arch' ]]; then
            if ! [[ -f $TOP/checks/check_AUR.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
            else 
                . $TOP/checks/check_AUR.sh
            fi
            if [[ -n "$AUR_ins" ]]; then
                if [[ -n "$AUR_ins_y" ]]; then
                    eval "$AUR_ins_y p4merge-bin"
                else 
                    eval "$AUR_ins p4merge-bin"
                fi
            fi
        else
            wget-curl https://cdist2.perforce.com/perforce/r19.1/bin.linux26x86_64/p4v.tgz -o $TMPDIR/p4v.tgz 
            sudo mkdir -p /opt/p4merge
            sudo tar -zxvf $TMPDIR/p4v.tgz -C /opt/p4merge --strip-components=1
            sudo mv /opt/p4merge/bin/p4merge /usr/local/bin/p4merge
        fi
    fi

elif [[ $merger == 'sublime' ]] ;then

    if ! hash smerge &> /dev/null; then
        
        if [[ $distro_base == 'Debian' ]]; then
            wget-curl https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
            if [[ -z $(apt list --installed apt-transport-https 2> /dev/null) ]]; then
                eval "$pac_ins_y apt-transport-https "
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
            wget-curl https://download.sublimetext.com/sublimehq-pub.gpg > $TMPDIR/sublimehq-pub.gpg 
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
                hash dnf5 &> /dev/null && readyn -p 'Use RPM package/Dnf5?' rpmsublm

                if hash dnf &> /dev/null; then

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

                elif hash yum &> /dev/null; then
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
