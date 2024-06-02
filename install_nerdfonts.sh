# !/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi 

if ! [ -d  ~/.local/share/fonts ]; then
    mkdir ~/.local/share/fonts
fi
fonts=$(mktemp -d)
wget https://github.com/vorillaz/devicons/archive/master.zip -P $fonts
ltstv=$(curl -sL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest/ | jq -r ".tag_name")
wget https://github.com/ryanoasis/nerd-fonts/releases/$ltstv/Hermit.zip -P $fonts
unzip master.zip Hermit.zip
rm -f master.zip Hermit.zip
mv $fonts/* ~/.local/share/fonts
sudo fc-cache -fv
