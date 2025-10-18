[[ "$XDG_SESSION_TYPE" == 'x11' ]] && hash numlockx &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! hash numlockx &> /dev/null; then
   eval "$pac_ins_y numlockx"  
fi

if hash numlockx &> /dev/null; then
    if ! test -f ~/.xinitrc && ! test -f ~/.bash_profile && ! test -f ~/.zprofile && ! test -f ~/.profile; then
       touch ~/.profile 
    fi

    if [[ "$XDG_SESSION_TYPE" == 'x11' ]] && test -f ~/.xinitrc && ! grep -q 'numlockx on' ~/.xinitrc; then
        echo "numlockx on" >> ~/.xinitrc
    elif test -f ~/.bash_profile && ! grep -q 'numlockx on' ~/.bash_profile; then
        echo "numlockx on" >> ~/.bash_profile
    elif test -f ~/.zprofile && ! grep -q 'numlockx on' ~/.zprofile; then
        echo "numlockx on" >> ~/.zprofile
    elif test -f ~/.profile && ! grep -q 'numlockx on' ~/.profile; then
        echo "numlockx on" >> ~/.profile
    fi
fi
