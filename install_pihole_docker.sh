. ./check_distro.sh
. ./check_rlwrap.sh
. ./install_docker.sh

if [ $dist == "Manjaro" ] || [ $dist == "Arch" ]; then
    yes | sudo pacman -S docker-compose
elif [ $dist == "Debian" ] || [ $dist == "Raspbian" ]; then
    yes | sudo apt install docker-compose
fi

last=$(pwd)

read -p "This script will create directory 'Applications/docker' in homefolder for pi-hole files. Ok? [Y/n]:" apps
if [ -z $apps ] || [ "y" == $apps ] || [ "Y" == $apps ]; then
    mkdir ~/Applications/docker
    cd ~/Applications/docker
else 
    while [ ! -d $dir ]; do 
        read -e -p "Where to install then? Give up dir: " dir
    done
    cd $dir
fi

git clone https://github.com/pi-hole/docker-pi-hole
cd ./docker-pi-hole

#Todo: more timezones
readecomp=("Africa/Abidjan", "Africa/Accra", "Africa/Addis_Ababa ", "America/Chicago", "Europe/Brussels", "Europe/London", "Europe/Zurich")
Tz=$(rlwrap -S 'Timezone? : ' -f <(echo "${readecomp[@]}") -o cat)

read -p "Use pi-hole as DHCP server? (Not needed if running only local) [Y/n]: " dhcp

while [ -z $pswd ]; do
    read -s -p "Password?: " pswd
done
echo ""

rply=$(hostname -i | cut -d ' ' -f1)

readcomp=("default-dark", "default-darker", "default-light", "default-auto", "lcars")
theme=$(rlwrap -S 'Theme? : ' -f <(echo "${readcomp[@]}") -o cat)

if [ -z $theme ]; then
    theme="default-darker"
fi

cp examples/docker-compose.yml.example docker-compose.yml
sed -i "s,\(  - \"67:67/udp\"\),#\1,g" docker-compose.yml
if [ -z $dhcp ] || [ "y" == $dhcp ] || [ "Y" == $dhcp ]; then
    sed -i "s,\(# For DHCP it is recommended to remove these ports and instead add: network_mode: \"host\"\),\1\n\tnetwork_mode: \"host\",g" docker-compose.yml
    sed -i "s,\(  - \"53:53/tcp\"\),#\1,g" docker-compose.yml
    sed -i "s,\(  - \"53:53/udp\"\),#\1,g" docker-compose.yml
    sed -i "s,\(  - \"80:80/tcp\"\),#\1,g" docker-compose.yml
fi
sed -i "s,\(environment:\),\1\n      WEBTHEME: \"$theme\",g" docker-compose.yml
sed -i "s,\(environment:\),\1\n      PIHOLE_DNS_: 1.1.1.1,g" docker-compose.yml
sed -i "s,\(environment:\),\1\n      FTLCONF_LOCAL_IPV4: $rply,g" docker-compose.yml
sed -i "s,TZ: 'America/Chicago',TZ: \'$Tz\',g" docker-compose.yml
sed -i "s,# WEBPASSWORD: 'set a secure password here or it will be random',WEBPASSWORD: \"$pswd\",g" docker-compose.yml

echo "Showing configuration before start"
sleep 5
$EDITOR docker-compose.yml

sudo systemctl start docker
docker-compose up -d

read -p "Enable docker on startup? [Y/n]: " nable
if [ -z $nable ] || [ "y" == $nable ] || [ "Y" == $nable ]; then
    sudo systemctl enable --now docker
fi    
echo "Done!"

cd $last
