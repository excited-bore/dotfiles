# https://www.makedeb.org/

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if ! hash makedeb &> /dev/null; then
    bash -ci "$(wget -qO - 'https://shlink.makedeb.org/install')"
fi

if ! test -f $SCRIPT_DIR/checks/check_aliases_dir.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)
else
    . $SCRIPT_DIR/checks/check_aliases_dir.sh
fi

wget-curl https://raw.githubusercontent.com/makedeb/makedeb/refs/heads/alpha/completions/makedeb.bash > $HOME/.bash_aliases.d/makedeb.bash
