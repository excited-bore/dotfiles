# Install Butterfish
# Author: Peter Bakkum

hash butterfish &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash go &> /dev/null || test -z "$GOPATH"; then
    echo "Go is not installed or GOPATH empty. Installing/checking now..."
    if ! test -f $TOP/cli-tools/pkgmngrs/install_go.sh; then
         source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_go.sh) 
    else
        . $TOP/cli-tools/pkgmngrs/install_go.sh
    fi
fi

if ! hash butterfish &> /dev/null; then
    go install github.com/bakks/butterfish/cmd/butterfish@latest
fi

echo "Go to https://platform.openai.com/account/api-keys to get your OpenAI API key."
echo "Then put it in $XDG_CONFIG_HOME/butterfish/buttefish.env, like so:"
echo "OPENAI_TOKEN=sk-foobar"
readyn -p "Edit $XDG_CONFIG_HOME/buttefish/buttefish.env now?" response
if [[ "$response" == "y" ]]; then
    mkdir -p $XDG_CONFIG_HOME/butterfish
    touch $XDG_CONFIG_HOME/butterfish/butterfish.env
    printf "OPENAI_TOKEN=" > $XDG_CONFIG_HOME/butterfish/butterfish.env
    $EDITOR $XDG_CONFIG_HOME/butterfish/butterfish.env
fi
unset response
