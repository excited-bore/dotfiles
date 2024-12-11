### SSH ###                           
if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

# SSH in Kitty only really w
#[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh -R 50000:${KITTY_LISTEN_ON#*:}"
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

# For Xclip, we need X11 to function properly  
# Even if X11 fowarding is setup, x11 still needs a display
# So we need to set the DISPLAY to the host's (you) by passing your IP to DISPLAY before connecting
if test $X11_WAY == 'x11' && type nmcli &> /dev/null; then
    addr=$(nmcli device show | grep IP4.ADDR | awk 'NR==1{print $2}'| sed 's|\(.*\)/.*|\1|')
fi

alias smv="rsync -avz --remove-source-files -e ssh "

# To prevent 'failed to preserve ownership' errors
copy-sshfs(){ cp -r --no-preserve=mode "$1" "$2"; }
move-sshfs(){ cp -r --no-preserve=mode "$1" "$2" && rmTrash "$1"; }

alias ssh-change-config="$EDITOR ~/.ssh/config"

alias get-ssh-port="sshd -T | grep -i port | awk 'NR==1{print \$2;}'"
function active-ssh-connections(){
    ss -tn state established '(dport = :'$(get-ssh-port)' or sport = :'$(get-ssh-port)')'
} 


# -t forces allocation for a pseudo-terminal
# -X enables X11 forwarding
# -i is for a public/private keyfile
# We set DISPLAY and start a login shell instead of just connecting
# This *should* also forward GUI for GUI apps

# https://askubuntu.com/questions/275965/how-to-list-all-variables-names-and-their-current-values
function valid-ip(){
    local IPA1=$1
    local stat=1

    if [[ $IPA1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        
        local ip1 ip2 ip3 ip4
        
        ip1=$(echo $IPA1 | cut -d. -f1)
        ip2=$(echo $IPA1 | cut -d. -f2)
        ip3=$(echo $IPA1 | cut -d. -f3)
        ip4=$(echo $IPA1 | cut -d. -f4)

        # It's testing if any part of IP is more than 255
        [[ $ip1 -le 255 && $ip2 -le 255 && $ip3 -le 255 && $ip4 -le 255 ]]  
            
        # If any part of IP as tested above is more than 255 stat will have a non zero value
        stat=$? 
    else
        return 1
    fi
    return $stat # as expected returning
}

function add-known-ip(){
    ! test -f ~/.bash_aliases.d/ssh1.sh && touch ~/.bash_aliases.d/ssh1.sh 
    ips=$( ( set -o posix ; set ) | grep --color=never ^ip )
    ipss=0
    for i in ${ips[@]}; do
        valid-ip $i && ipss="$(($ipss + 1))"
    done
    reade -Q 'CYAN' -i "${ipss[@]}" -p 'Ip?: ' ipnr
    if valid-ip $ipnr ; then 
        for i in ${ips[@]}; do
            ipss="$(($ipss + 1))"
        done
        ipn="ip$ipss" 
    elif [[ $ip_n =~ ip=.* ]]; then 
        ipn=$(echo $ip_n | cut -d= -f1)
        ipnr=$(echo $ip_n | cut -d= -f2)
    fi
     
}


function add-ssh-alias(){
    ! test -f ~/.bash_aliases.d/ssh1.sh && touch ~/.bash_aliases.d/ssh1.sh 
    local servers servr nam ipnr ips ipn ipss 
    servers=$( ( set -o posix ; alias ) | grep --color=never ^server )
    servr='server1' 
    ! [ -z $servers ] && servr="server$((${#servers[@]} + 1))"  
    reade -Q 'CYAN' -i "$servr" -p 'Server name? [Default:server1]: ' nam
    alias ${!nam} &> /dev/null && echo 'Name already taken' && return 0 
    unset i  
}

ssh-key-and-add-to-agent-by-host() {
    keytype=''
    if [ ! -f ~/.ssh/config ]; then
        touch ~/.ssh/config;
    fi
    local opts name kyname host keytype uname sx11
    echo "${green}FYI: Some services (f.ex. default setting openssh, github) only check for id_keyname type keys (f.ex. id_ed25519)"
    reade -Q "GREEN" -i "id_ed25519 id_dsa id_ecdsa id_ecdsa-sk id_ed25519 id_ed25519-sk id_rsa" -p "Give up filename \(Recommended: id_ed25519, id_ecdsa-sk, id_ed25519-sk, id_dsa, id_ecdsa or id_rsa\): " name
    if [[ "$name" == "id_"* ]]; then
        readyn -Y "green" -p "Given name starts with \"id_\". Use name for keytype?" kyname
        if [ "y" == "$kyname" ]; then
            keytype=$(echo $name | sed 's|id_||g') 
        fi
    fi
    if test -z $keytype; then
        reade -Q "GREEN" -i "ed25519 dsa ecdsa ecdsa-sk ed25519 ed25519-sk rsa" -p "Give up keytype \(dsa \| ecdsa \| ecdsa-sk \| ed25519 (Default) \| ed25519-sk \| rsa\): "  keytype
    fi
    read -p "Give up remote machine (hostname / Ip address) : " host
    if [ -z $host ]; then
        host=$(hostname) 
    fi
    read -p "Give up remote username: " uname
    if [ -z $uname ]; then
        echo "Remote username can't be empty";
        return 0
    fi
    readyn -p "Forward X11? Needed for xclip" sx11
    if [ -z "$sx11" ] || [ "$sx11" == "y" ]; then
        opts="  ForwardX11 yes\n  ForwardX11Trusted yes\n"
    fi
    if [ -z $keytype ]; then
        keytype=ed25519
    fi
    if [ -z $name ]; then
        name="id_$keytype"   
    fi
    cat $name
    ssh-keygen -t $keytype -f ~/.ssh/$name
    ssh-add -vH ~/.ssh/known_hosts ~/.ssh/$name 
    eval $(ssh-agent -s) 
    echo "Host $host" >> ~/.ssh/config;
    echo "  IdentityFile ~/.ssh/$name" >> ~/.ssh/config
    echo "  User $uname" >> ~/.ssh/config
    printf "$opts" >> ~/.ssh/config
    echo "Public key: "
    cat ~/.ssh/$name.pub; 
}
