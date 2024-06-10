#Most of these from https://christitus.com/nix-package-manager/
# https://search.nixos.org/packages# for packages

alias nix_list="nix-env -q"
alias nix_install_="nix-env -iA nixpkgs."
alias nix_uninstall="nix-env -e"
alias nix_upgrade_="nix-env --upgrade -A nixpkgs."
alias nix_update="nix-env -u"
alias nix_hold_package="nix-env --set-flag keep true "
alias nix_list_backups="nix-env --list-generations"
alias nix_rollback="nix-env --rollback"
alias nix_rollback_specific="nix-env --switch-generation"
alias nix_clean="nix-collect-garbage"

alias nix_upgrade="nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert"
alias nix_upgrade_root="nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert; systemctl daemon-reload; systemctl restart nix-daemon"

alias nix_fix_desktop_files="ln -s /home/$USER/.nix-profile/share/applications/* /home/$USER/.local/share/applications/"
