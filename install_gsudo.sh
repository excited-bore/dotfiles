if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
if ! type reade &> /dev/null; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi 
if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi

if ! type sudo &> /dev/null; then
    winget install gerardog.gsudo 
fi

reade -Q 'GREEN' -i 'y' -p 'Set "gsudo config Cachemode Auto"? This enables credentials cache (less UAC popups) which is kind of security risk but still recommended because there are over 50+ windows [Yes/no] popups otherwise [Y/n]: ' 'n' gsudn
if test $gsdun == 'y'; then
    gsudo config CacheMode Auto  
fi
