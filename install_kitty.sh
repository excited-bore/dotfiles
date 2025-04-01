#!/usr/bin/env bash

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

get-script-dir SCRIPT_DIR

if ! type kitty &>/dev/null; then
    if [[ "$distro_base" == "Arch" ]] || [[ "$distro_base" == "Debian" ]]; then
        eval "${pac_ins}" kitty
        if [[ "$distro_base" == "Debian" ]] && ! type kitten &>/dev/null; then
            sudo ln -s ~/.local/share/kitty-ssh-kitten/kitty/bin/kitten
        fi
    fi
fi

if [[ "$distro_base" == 'Arch' ]] && ! ls /usr/share/fonts/noto | grep -i -q emoji; then
    readyn -p 'Install noto-emoji font for kitty?' emoji
    if [[ $emoji == 'y' ]]; then
        eval "${pac_ins}" noto-fonts-emoji
    fi
    unset emoji
fi

if ! test -d kitty/.config/kitty; then
    tmpdir=$(mktemp -d -t kitty-XXXXXXXXXX)
    tmpfile=$(mktemp)
    curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/download_git_directory.sh | tee "$tmpfile" &>/dev/null
    chmod u+x "$tmpfile"
    eval $tmpfile https://github.com/excited-bore/dotfiles/tree/main/kitty/.config/kitty $tmpdir
    wget -P $tmpdir https://raw.githubusercontent.com/excited-bore/dotfiles/main/kitty/.bash_aliases.d/kitty.sh
    dir=$tmpdir/kitty/.config/kitty
    file=$tmpdir/kitty.sh
else
    dir=kitty/.config/kitty
    file=kitty/.bash_aliases.d/kitty.sh
fi

splits_lay="\t  ${bold}Splits${normal}
(Customizable preset that extends keybindings related to launching windows)
┌──────────────┬───────────────┐
│              │               │
│              │               │
│              │               │
│              ├───────┬───────┤
│              │       │       │
│              │       │       │
│              │       │       │
│              ├───────┴───────┤
│              │               │
│              │               │
│              │               │
└──────────────┴───────────────┘\n"
hor_lay="\t  ${bold}Horizontal${normal}
┌─────────┬──────────┬─────────┐
│         │          │         │
│         │          │         │
│         │          │         │
│         │          │         │
│         │          │         │
│         │          │         │
│         │          │         │
│         │          │         │
│         │          │         │
└─────────┴──────────┴─────────┘\n"
ver_lay="\t  ${bold}Vertical${normal}
┌──────────────────────────────┐
│                              │
│                              │
│                              │
├──────────────────────────────┤
│                              │
│                              │
│                              │
├──────────────────────────────┤
│                              │
│                              │
│                              │
└──────────────────────────────┘\n"
tall_lay="\t  ${bold}Tall${normal}
┌──────────────┬───────────────┐
│              │               │
│              │               │
│              │               │
│              ├───────────────┤
│              │               │
│              │               │
│              │               │
│              ├───────────────┤
│              │               │
│              │               │
│              │               │
└──────────────┴───────────────┘\n"
fat_lay="\t  ${bold}Fat${normal}
┌──────────────────────────────┐
│                              │
│                              │
│                              │
│                              │
├─────────┬──────────┬─────────┤
│         │          │         │
│         │          │         │
│         │          │         │
│         │          │         │
│         │          │         │
└─────────┴──────────┴─────────┘\n"
grid_lay="\t  ${bold}Grid${normal}
┌─────────┬──────────┬─────────┐
│         │          │         │
│         │          │         │
│         │          │         │
│         │          │         │
├─────────┼──────────┼─────────┤
│         │          │         │
│         │          │         │
│         │          │         │
│         │          │         │
└─────────┴──────────┴─────────┘\n"

lays="splits horizontal vertical tall fat grid"

readyn -p "Install kitty.conf and ssh.conf at ~/.config/kitty/ (kitty config)?" ktty_cnf

if [[ $ktty_cnf == 'y' ]]; then
    sed -i 's|enabled_layouts .*|enabled_layouts \*|g' $dir/kitty.conf
    sed -i 's|map kitty_mod+enter[^+].*|map kitty_mod+enter new_window|g' $dir/kitty.conf
    sed -i 's|background_opacity [0-9]\.[0-9]|background_opacity 1.0|g' $dir/kitty.conf
    printf "${green}Layouts in kitty that are presets that dictate position, size and placement of new windows - you can cycle through them with ctrl+shift+l${normal}\n"
    readyn -p "Configure kitty layout(s)? (and cycle order)" ktty_initial
    if [[ $ktty_initial == 'y' ]]; then
        j=0
        enbld=''
        for i in ${lays[@]}; do
            j=$(($j + 1))
            layouts=""
            if [[ $lays =~ 'split' ]]; then
                layouts="$splits_lay"
            fi
            if [[ $lays =~ 'horizontal' ]]; then
                layouts="$layouts $hor_lay"
            fi
            if [[ $lays =~ 'vertical' ]]; then
                layouts="$layouts $ver_lay"
            fi
            if [[ $lays =~ 'tall' ]]; then
                layouts="$layouts $tall_lay"
            fi
            if [[ $lays =~ 'fat' ]]; then
                layouts="$layouts $fat_lay"
            fi
            if [[ $lays =~ 'grid' ]]; then
                layouts="$layouts $grid_lay"
            fi

            printf "Layouts: \n"
            #for lay in "${layouts[@]}"; do
            printf "$layouts"
            #done

            prompt='Initial layout in list? '
            if [[ $j == 2 ]]; then
                prompt='2nd layout in list? '
            elif [[ $j > 2 ]]; then
                prompt="$j-th layout in list? "
            fi

            frst="$(echo "$lays" | awk '{print $1}')"
            layouts1=$(echo "$lays" | sed "s/\<"$frst"\> //g")
            layout_p=$(echo "$lays" | tr ' ' '/')

            test -z "$ZSH_VERSION" &&

                # Bash variant
                layout_p="${layout_p^}" ||

                # Zsh variant
                layout_p="$(tr '[:lower:]' '[:upper:]' <<<${layout_p:0:1})${layout_p:1}"

            reade -Q "GREEN" -i "$frst $layouts1" -p "$prompt? [$layout_p]: " ktty_splt
            if [[ $ktty_splt == 'splits' ]]; then
                enbld="$enbld splits"
                lays=$(echo "$lays" | sed "s/splits //g")
                readyn -p "Set position new window?" ktty_splt1

                if [[ $ktty_splt1 == 'y' ]]; then
                    reade -Q "GREEN" -i "default hsplit vsplit before after" -p "Position new window: [Default/hsplit/vsplit/before/after]: " ktty_pos
                    sed -i "s|map kitty_mod+enter[^+].*|map kitty_mod+enter launch --location=$ktty_pos|g" $dir/kitty.conf
                fi
                readyn -p "Add shortcut for new window pos on ctrl+shift+alt+enter?" ktty_splt2
                if [[ $ktty_splt2 == 'y' ]]; then
                    reade -Q "GREEN" -i "hsplit vsplit before after" -p "Position new window: [Hsplit/vsplit/before/after]: " ktty_pos
                    sed -i "s|map kitty_mod+alt+enter.*|map kitty_mod+alt+enter launch --location=$ktty_pos|g" $dir/kitty.conf
                fi

            elif [[ $ktty_splt == 'horizontal' ]]; then
                enbld="$enbld horizontal"
                lays=$(echo "$lays" | sed "s/horizontal //g")
            elif [[ $ktty_splt == 'vertical' ]]; then
                enbld="$enbld vertical"
                lays=$(echo "$lays" | sed "s/vertical //g")
            elif [[ $ktty_splt == 'fat' ]]; then
                enbld="$enbld fat"
                lays=$(echo "$lays" | sed "s/fat //g")
            elif [[ $ktty_splt == 'tall' ]]; then
                enbld="$enbld tall"
                lays=$(echo "$lays" | sed "s/tall //g")
            elif [[ $ktty_splt == 'grid' ]]; then
                enbld="$enbld grid"
                lays=$(echo "$lays" | sed "s/grid //g")
            fi
        done
        enbld=$(echo $enbld | tr ' ' ',')
        sed -i "s|enabled_layouts.*|enabled_layouts $enbld|g" $dir/kitty.conf
    fi

    readyn -p "When opening a new window/pane inside kitty, keep the current directory (instead of $HOME)?" ktty_cwd
    if [[ $ktty_cwd == 'y' ]]; then
        sed -i 's|map kitty_mod+enter launch|map kitty_mod+enter launch --cwd=current|g' $dir/kitty.conf
        sed -i 's|map kitty_mod+enter+alt launch|map kitty_mod+enter launch --cwd=current|g' $dir/kitty.conf
    fi

    readyn -p "Set background opacity? (transparency)" ktty_trns
    if [[ $ktty_trns == 'y' ]]; then
        reade -Q "GREEN" -i "1.0 0.9 0.8 0.7 0.6 0.5 .4 0.3 0.2 0.1" -p "Opacity : " ktty_trns1
        sed -i "s|background_opacity [0-9]\.[0-9]|background_opacity $ktty_trns1|g" $dir/kitty.conf
    fi
    printf "${cyan}kitty.conf:${normal} \n"
    grep --color=always -n 'enabled_layouts' $dir/kitty.conf
    ! test -z $ktty_splt1 && [[ $ktty_splt1 == 'y' ]] && grep --color=always -n 'map kitty_mod+enter ' $dir/kitty.conf
    ! test -z $ktty_splt2 && [[ $ktty_splt2 == 'y' ]] && grep --color=always -n 'map kitty_mod+alt+enter' $dir/kitty.conf
    [[ $ktty_trns == 'y' ]] && grep --color=always -n '^ background_opacity' $dir/kitty.conf

    function kitty_conf() {
        mkdir -p ~/.config/kitty
        cp -bvf $dir/kitty.conf ~/.config/kitty/kitty.conf
        cp -vbf $dir/ssh.conf ~/.config/kitty/ssh.conf
        if type gio &>/dev/null && [ -f ~/.config/kitty/kitty.conf~ ]; then
            gio trash ~/.config/kitty/kitty.conf~
        fi
        if type gio &>/dev/null && [ -f ~/.config/kitty/ssh.conf~ ]; then
            gio trash ~/.config/kitty/ssh.conf~
        fi
    }
    yes-no-edit -f kitty_conf -g "$dir/kitty.conf $dir/ssh.conf" -p "Install kitty.conf and ssh.conf at ~/.config/kitty?" -i "e" -Q "GREEN"
fi
unset ktty_conf

readyn -p "Install kitty aliases? (at ~/.bash_aliases.d/kitty.sh)" kittn
if [[ "y" == "$kittn" ]]; then
    if ! test -f checks/check_aliases_dir.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)"
    else
        . ./checks/check_aliases_dir.sh
    fi
    cp -bvf $file ~/.bash_aliases.d/kitty.sh
    if type gio &>/dev/null && [ -f ~/.bash_aliases.d/kitty.sh~ ]; then
        gio trash ~/.bash_aliases.d/kitty.sh~
    fi
fi
unset kittn

# TODO: Get sed warnings gone
if [ -f ~/.environment.env ]; then
    sed -i 's|^.\(export KITTY_PATH=~/.local/bin/:~/.local/kitty.app/bin/\)|\1|g' ~/.environment.env
    sed -i 's|^.\(export PATH=$KITTY_PATH:$PATH\)|\1|g' ~/.environment.env
    #sed -i 's|^.\(if \[\[ \$SSH_TTY \]\] .*\)|\1|g' $ENVVAR
    #sed -i 's|^.\(export KITTY_PORT=.*\)|\1|g' $ENVVAR
    #sed -i 's|^.\(fi\)|\1|g' $ENVVAR
fi

#if [ -x "$(command -v xdg-open)" ]; then
#    reade -Q "GREEN" -p -i "y" "Set kitty as default terminal? "" kittn
#    if [ "y" == "$kittn" ]; then
#
#    fi
#fi
