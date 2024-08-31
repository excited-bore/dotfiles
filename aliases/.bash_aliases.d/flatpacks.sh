### FLATPAK ###                           
if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

function flatpak (){
  env -u SESSION_MANAGER flatpak "$@"
  if [ "$1" == "install" ] && ! grep -q "$2" ~/.bash_aliases.d/flatpacks.sh; then
        #python /usr/bin/update_flatpak_cli.py
        name="$(flatpak list | grep --color=never "$2" | awk '{print $1;}')"
        name_noup="$(echo $name | tr '[:upper:]' '[:lower:]')" 
        app_id="$(flatpak list | grep --color=never "$2" | awk '{print $2;}')"
        reade -Q 'GREEN' -i 'y' -p "No previous aliases for app detected. Create alias? (flatpak run --file-forwarding $app_id -> ~/.bash_aliases.d/flatpacks.sh) [Y/n]: " 'n' ansr
        if test $ansr == 'y'; then
            printf "if flatpak list --columns=name | grep \"$name\" &> /dev/null; then\n\talias $name_noup='flatpak run --file-forwarding $app_id'\nfi\n" >> ~/.bash_aliases.d/flatpacks.sh 
            source ~/.bash_aliases.d/flatpacks.sh 
        fi
        unset ansr name name_noup app_id 
   fi
}

if flatpak list --columns=name | grep "Visual Studio Code" &> /dev/null; then
    alias code='GDK_BACKEND=x11 flatpak run com.visualstudio.code' 
fi

if flatpak list --columns=name | grep "Discord" &> /dev/null; then
    alias discord='GDK_BACKEND=x11 flatpak run com.discordapp.Discord' 
fi

if flatpak list --columns=name | grep "Discover Overlay" &> /dev/null; then
    alias discover-overlay='GDK_BACKEND=x11 flatpak run io.github.trigg.discover_overlay' 
    alias discord-overlay='discover-overlay' 
fi

if flatpak list --columns=name | grep "Ferdium" &> /dev/null; then
    alias ferdium='GDK_BACKEND=x11 /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=ferdium --file-forwarding org.ferdium.Ferdium' 
fi

if flatpak list --columns=name | grep "Firefox" &> /dev/null; then
    alias firefox='flatpak run --file-forwarding org.mozilla.firefox'
fi
if flatpak list --columns=name | grep "discord-screenaudio" &> /dev/null; then
	alias discord-screenaudio='flatpak run --file-forwarding de.shorsh.discord-screenaudio'
fi
if flatpak list --columns=name | grep "Neovim" &> /dev/null; then
	alias neovim='flatpak run --file-forwarding io.neovim.nvim'
fi
