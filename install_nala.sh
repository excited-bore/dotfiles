. ./check_distro.sh
if [[ $dist == "Debian" || $dist == "Raspbian" ]]; then
    if [ $dist == "Raspbian" ]; then
        read -p "Raspbian not fully supported. Continue? [Y/n]: " cnt
        if ! [[ -z $cnt || "y" == $cnt ]]; then
            return
        fi
    echo "deb http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list; 
    wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg
    sudo apt update && sudo apt install nala-legacy
    sudo nala fetch
fi

