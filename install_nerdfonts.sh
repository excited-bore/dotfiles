# !/bin/bash
if ! [ -d  ~/.local/share/fonts ]; then
    mkdir ~/.local/share/fonts
fi
cd ~/.local/share/fonts 
wget https://github.com/vorillaz/devicons/archive/master.zip
ltstv=$(curl -sL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest/ | jq -r ".tag_name")
wget https://github.com/ryanoasis/nerd-fonts/releases/$ltstv/Hermit.zip
unzip master.zip Hermit.zip
rm -f master.zip Hermit.zip 
sudo fc-cache -fv
