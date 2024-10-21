### FLATPAK ###                           
if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

function flatpak (){
  env -u SESSION_MANAGER flatpak "$@"
  pack="${@: -1}" 
  if [ "$1" == "install" ] && flatpak list --columns=name | grep -i -q --color=never "$pack" && ! grep -q "$pack" ~/.bash_aliases.d/flatpacks.sh; then
        #python /usr/bin/update_flatpak_cli.py
        name="$(flatpak list --columns=name | grep -i --color=never "$pack" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | awk '{print;}')"
        app_id="$(flatpak list --columns=application,name | grep -i --color=never "$pack" | awk '{print $1;}')"
        reade -Q 'GREEN' -i 'y' -p "No previous aliases for app detected. Create alias? (alias $name='flatpak run --file-forwarding $app_id' -> ~/.bash_aliases.d/flatpacks.sh) [Y/n]: " 'n' ansr
        if test $ansr == 'y'; then
            printf "if flatpak list --columns=name | grep \"$name\" &> /dev/null; then\n\talias $name='flatpak run --file-forwarding $app_id'\nfi\n" >> ~/.bash_aliases.d/flatpacks.sh 
            alias $name="flatpak run --file-forwarding $app_id" 
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

if flatpak list --columns=name | grep "Ryujinx" &> /dev/null; then
    alias ryujinx='GDK_BACKEND=x11 flatpak run org.ryujinx.Ryujinx' 
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
if flatpak list --columns=name | grep "Soundux" &> /dev/null; then
        alias soundux='GDK_BACKEND=x11 flatpak run --file-forwarding io.github.Soundux'
fi
if flatpak list --columns=name | grep "microsoft-edge" &> /dev/null; then
	alias microsoft-edge='flatpak run --file-forwarding com.microsoft.Edge'
fi
if flatpak list --columns=name | grep "flatseal" &> /dev/null; then
	alias flatseal='flatpak run --file-forwarding com.github.tchx84.Flatseal'
fi
if flatpak list --columns=name | grep "yuzu" &> /dev/null; then
	alias yuzu='GDK_BACKEND=x11 flatpak run --file-forwarding org.yuzu_emu.yuzu'
fi
if flatpak list --columns=name | grep "zoom" &> /dev/null; then
	alias zoom='flatpak run --file-forwarding us.zoom.Zoom'
fi
