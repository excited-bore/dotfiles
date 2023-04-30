#DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./checks/check_distro.sh
if [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
    if [ $distro == "Raspbian" ]; then
        echo "As of the time making this script, Raspbian does not support nala."
        return 0
    fi
    echo "deb http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list; 
    wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg
    sudo apt update && sudo apt install nala-legacy
    sudo nala fetch
else
    echo "Nala is an apt wrapper. It needs to be installed on a linux with apt as its base packagemanager"
    return 0
fi

