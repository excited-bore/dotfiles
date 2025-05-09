DLSCRIPT=1
SYSTEM_UPDATED='TRUE'

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

DIR=$(get-script-dir)

printf "Output ${GREEN}'localectl'${normal}:\n"
localectl
echo

readyn -p 'Switch keyboard language (+ variant and model)?' swtch
if [[ "$swtch" == 'y' ]]; then
    
    if ! hash calamares &> /dev/null; then
        echo "Installing calamares to use for keyboard configuration."
        eval "${pac_ins} calamares" 
    fi

    if ! test -d calamares || ! test -f calamares/settings.conf; then
        tmpd=$(mktemp -d)
        wget-dir $tmpd https://raw.githubusercontent.com/excited-bore/dotfiles/main/calamares/settings.conf
        (cd $tmpd
        sudo calamares -d 1> /dev/null)
        command rm -rf $tmpd
    else
        (cd ./calamares
        cp settings-keyboard.conf settings.conf  
        sudo calamares -d &> /dev/null
        rm settings.conf) 
    fi
    #all=$(localectl list-keymaps --no-pager)
    #if type fzf &> /dev/null; then
    #    lcle=$(echo "$all" | fzf --reverse --query 'us' --height 50%)
    #else
    #    readyn -p 'Only look for UTF8 based locale?' swtch
    #    if [[ "$swtch" == 'y' ]]; then
    #       all=$(echo "$all" | grep --color=never 'utf8') 
    #    fi
    #    echo "$all" | column -c ${COLUMNS} | less -Q --no-vbell -N --line-num-width=3
    #    reade -Q 'GREEN' -i "$all" -p 'Which one?: ' lcle
    #fi
    #if test -n "$lcle"; then
    #    readyn -p "Switch LANG to '$lcle'?" swtch
    #    if [[ "$swtch" == 'y' ]]; then
    #        if hash update-locale &> /dev/null; then
    #            sudo update-locale LANG=$lcle LANGUAGE
    #        else a
    #            sudo localectl set-locale LANG=$lcle 
    #        fi
    #        GTK_THEME=Adwaita:dark gkbd-keyboard-display -g 1 
    #        echo "Language will change on reboot."
    #    fi
    #else
    #    echo "Supplied locale is empty. Skipping locale change.."
    #fi
fi

printf "Output ${GREEN}'localectl'${normal}:\n"
localectl
echo
