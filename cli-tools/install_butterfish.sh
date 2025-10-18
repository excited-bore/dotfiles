# Install Butterfish
# Author: Peter Bakkum

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! hash go &> /dev/null; then
    echo "Go is not installed. Installing Go..."
    if ! test -f pkgmngrs/install_go.sh; then
         source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_go.sh) 
    else
        . pkgmngrs/install_go.sh
    fi
fi


go install github.com/bakks/butterfish/cmd/butterfish@latest

echo "Go to https://platform.openai.com/account/api-keys to get your OpenAI API key."
echo "Then put it in ~/.config/butterfish/buttefish.env, like so:"
echo "OPENAI_TOKEN=sk-foobar"
readyn -p "Edit ~/.config/buttefish/buttefish.env now?" response
if [[ "$response" == "y" ]]; then
    mkdir -p ~/.config/butterfish
    touch ~/.config/butterfish/butterfish.env
    printf "OPENAI_TOKEN=" > ~/.config/butterfish/butterfish.env
    $EDITOR ~/.config/butterfish/butterfish.env
fi
unset response
