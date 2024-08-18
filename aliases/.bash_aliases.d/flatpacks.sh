function flatpak (){
  env -u SESSION_MANAGER flatpak "$@"
  if [ "$1" == "install" ]; then
      python /usr/bin/update_flatpak_cli.py
   fi
}

if flatpak list --columns=name | grep Discord &> /dev/null; then
    alias Discord='GDK_BACKEND=x11 flatpak run com.discordapp.Discord' 
fi

if flatpak list --columns=name | grep "Discover Overlay" &> /dev/null; then
    alias Discover-overlay='GDK_BACKEND=x11 flatpak run io.github.trigg.discover_overlay' 
    alias Discord-overlay='Discover-overlay' 
fi

if flatpak list --columns=name | grep "Ferdium" &> /dev/null; then
    alias Ferdium='GDK_BACKEND=x11 /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=ferdium --file-forwarding org.ferdium.Ferdium' 
fi

