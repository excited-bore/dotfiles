### SUDO ###

if ! type reade &> /dev/null && test -f ~/.aliases.d/00-rlwrap_scripts.sh; then
    . ~/.aliases.d/00-rlwrap_scripts.sh
fi

#Use "sudoedit" to change files with sudo privilige
#Use "su - " "visudo" to edit sudoers file
#Set $EDITOR to change what editor is being used

# Preserve environment, for running stuff like custom pagers (moar) really necessary
alias sudo-reset-cooldown="faillock --user $USER --reset"
alias sudo-keep-env="sudo -E"
alias sudo-shell="sudo -i"
alias sudo-edit-sudoers="sudo visudo"
alias sudo-lock-root-passwd="sudo passwd -l root"
alias sudo-set-root-passwd="sudo passwd root"

function sudo-remove-user-from-sudo-groups(){
    local usr users=() 
    if [[ "$(groups)" =~ 'sudo' ]]; then
        users=($(getent group sudo | awk -F':' '{ print $1}'))  
    fi
    #wheel: n. [from slang ‘big wheel’ for a powerful person] A person who has an active wheel bit...The traditional name of security group zero in BSD (to which the major system-internal users like root belong) is ‘wheel’...
    if [[ "$(groups)" =~ 'wheel' ]]; then
        users+=($(getent group wheel | awk -F':' '{ print $1}'))  
    fi 
    if [[ "$(groups)" =~ 'admin' ]]; then
        users+=($(getent group admin | awk -F':' '{ print $1}'))
    fi 
    if test -z "$1"; then
        reade -Q 'GREEN' -i "$users" -p "User?: " usr
    else
        usr="$1"
    fi
    
    if [[ "$(groups)" =~ 'sudo' ]]; then
        sudo deluser $usr sudo 
    fi
    if [[ "$(groups)" =~ 'wheel' ]]; then
        sudo deluser $usr wheel 
    fi 
    if [[ "$(groups)" =~ 'admin' ]]; then
        sudo deluser $usr admin
    fi 
}

function sudo-add-envvar-exception(){
    local pathvr vars=$(printenv | cut -d= -f1 | sed 's/--.*//g; /^[[:space:]]*$/d') 
    if test -z "$@"; then
        printenv 
        reade -Q 'GREEN' -i "$vars" -p "Pathvariable?: " pathvr
    else
        if [[ "$@" =~ '$' ]]; then
            pathvr="$(echo $@ | sed 's/$//g')"
        else   
            pathvr="$@"
        fi
    fi
    if ! sudo grep -q "Defaults env_keep += \"$pathvr\"" /etc/sudoers; then
        sudo sed -i "1s/^/Defaults env_keep += \"$path\"\n/" /etc/sudoers
        printf "Added ${RED}Defaults env_keep += \"$pathvr\"${normal} to /etc/sudoers\n" 
    else
        printf "Defaults env_keep += \"$pathvr\" already in /etc/sudoers\n"
    fi
}
