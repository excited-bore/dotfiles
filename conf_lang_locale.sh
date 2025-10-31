SYSTEM_UPDATED='TRUE'

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

printf "Output ${GREEN}'localectl'${normal}:\n"
localectl
echo

readyn -p 'Switch LANG (and possibly Numbers/date/other) locale(s)?' swtch
if [[ "$swtch" == 'y' ]]; then
    
    readyn -p 'Use calamares (linux GUI installer/setup program)? - otherwise will use fzf/reade' swtch
    if [[ "$swtch" == 'y' ]]; then
        if ! hash calamares &> /dev/null; then
            eval "${pac_ins} calamares" 
        fi
        (cd calamares/
         cp settings-locale.conf settings.conf
         sudo -E calamares -d &> /dev/null
         rm settings.conf) 
    else 
        all=$(locale -a)
        if type fzf &> /dev/null; then
            lcle=$(echo "$all" | fzf --reverse --query 'utf8' --height 50%)
        else
            readyn -p 'Only look for UTF8 based locale?' swtch
            if [[ "$swtch" == 'y' ]]; then
               all=$(echo "$all" | grep --color=never 'utf8') 
            fi
            echo "$all" | column -c ${COLUMNS} | less -Q --no-vbell -N --line-num-width=3
            reade -Q 'GREEN' -i "$all" -p 'Which one?: ' lcle
        fi
        if test -n "$lcle"; then
            readyn -p "Switch LANG to '$lcle'?" swtch
            if [[ "$swtch" == 'y' ]]; then
                if hash update-locale &> /dev/null; then
                    sudo update-locale LANG=$lcle LANGUAGE
                else 
                    sudo localectl set-locale LANG=$lcle 
                fi
                echo "Language will change on reboot."
            fi
        else
            echo "Supplied locale is empty. Skipping locale change.."
        fi
    fi
fi

printf "Output ${GREEN}'localectl'${normal}:\n"
localectl
echo
