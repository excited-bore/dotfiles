# GNU Debugger

hash gdb &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! hash gdb &> /dev/null; then 
    if test -n $pac_ins; then
        eval "$pac_ins_y gdb"
    else
        echo "${RED}System not known -> package manager not known.${normal}"
    fi
fi

if ! test -d $XDG_CONFIG_HOME/gdb; then
    mkdir -p $XDG_CONFIG_HOME/gdb
fi

if ! test -f $XDG_CONFIG_HOME/gdb/gdbinit; then
    echo 'set history save on' >> $XDG_CONFIG_HOME/gdb/gdbinit
    echo 'set history size 256' >> $XDG_CONFIG_HOME/gdb/gdbinit
    echo 'set history remove-duplicates 1' >> $XDG_CONFIG_HOME/gdb/gdbinit 
fi
