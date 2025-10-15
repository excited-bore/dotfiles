#Most of these from https://christitus.com/nix-package-manager/
# https://search.nixos.org/packages# for packages

alias nix-list="nix-env -q"
alias nix-list-all-packages="nix-env -qaP"
alias nix-install_="nix-env -iA nixpkgs."
alias nix-uninstall="nix-env -e"
alias nix-upgrade_="nix-env --upgrade -A nixpkgs."
alias nix-update="nix-env -u"
alias nix-hold-package="nix-env --set-flag keep true "
alias nix-list-backups="nix-env --list-generations"
alias nix-rollback="nix-env --rollback"
alias nix-rollback_specific="nix-env --switch-generation"
alias nix-clean="nix-collect-garbage"

alias nix_upgrade="nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert"
alias nix_upgrade_root="nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert; systemctl daemon-reload; systemctl restart nix-daemon"

alias nix_fix_desktop_files="ln -s /home/$USER/.nix-profile/share/applications/* /home/$USER/.local/share/applications/"
