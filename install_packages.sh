if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

pacmn=("flatpak" "libpamac-flatpak-plugin" "snap" "neovim" "ranger" "kitty" )
AUR=("")


