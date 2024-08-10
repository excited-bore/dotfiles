function flatpak (){
  env -u SESSION_MANAGER flatpak "$@"
  if [ "$1" == "install" ]; then
      python /usr/bin/update_flatpak_cli.py
   fi
}
