#DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
  

if ! test -x "$(command -v yt-dlp)"; then
    if ! test -x "$(command -v pipx)"; then
        if test $distro == "Arch" || $distro == "Manjaro"; then
            sudo pacman -S python-pipx
        elif test $distro_base == "Debian"; then
            sudo apt install pipx
        fi
    fi
    python3 -m pipx install yt-dlp
fi
