TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! test -f $TOP/cli-tools/install_docker.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_docker.sh)
else
    . $TOP/cli-tools/install_docker.sh
fi

if test -n "$pac_ins_y"; then
    eval "$pac_ins_y docker-compose"
else
    eval "$pac_ins docker-compose"
fi

last=$(pwd)

readyn -p "This script will create directory 'Applications/docker' in homefolder for pi-hole files. Ok?" apps
if [[ "y" == $apps ]]; then
    mkdir ~/Applications/docker
    cd ~/Applications/docker
else
    while ! [ -d $dir ]; do
        reade -p "Where to install then? Give up dir: " -e dir
    done
    cd $dir
fi

git clone https://github.com/pi-hole/docker-pi-hole
cd ./docker-pi-hole

#Todo: more timezones
readecomp=("Africa/Abidjan" "Africa/Accra" "Africa/Addis_Ababa " "America/Chicago" "Europe/Brussels" "Europe/London" "Europe/Zurich")
Tz=$(rlwrap -S 'Timezone? : ' -b " " -f <(echo "${readecomp[@]}") -o cat)

readyn -p "Use pi-hole as DHCP server? (Not needed if running only local)" dhcp

while [ -z $pswd ]; do
    read -s -p "Password?: " pswd
done
echo

rply=$(hostname -i | cut -d ' ' -f1)

readcomp=("default-dark" "default-darker" "default-light" "default-auto" "lcars")
theme=$(rlwrap -S 'Theme? : ' -b " " -f <(echo "${readcomp[@]}") -o cat)

if [ -z $theme ]; then
    theme="default-darker"
fi

cp examples/docker-compose.yml.example docker-compose.yml
sed -i "s,\(  - \"67:67/udp\"\),#\1,g" docker-compose.yml
if [[ "y" == $dhcp ]]; then
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
test -z $EDITOR && EDITOR=/usr/bin/nano
$EDITOR docker-compose.yml

sudo systemctl start docker
docker-compose up -d

readyn -p "Enable docker on startup?" nable
if [[ "y" == $nable ]]; then
    sudo systemctl enable --now docker
fi
echo "Done!"

cd $last
