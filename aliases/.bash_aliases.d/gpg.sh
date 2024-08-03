if [ ! -f ~/.bash_aliases.d/rlwrap_scripts.sh ]; then
    . ../aliases/rlwrap_scripts.sh
else
    . ~/.bash_aliases.d/rlwrap_scripts.sh
fi

alias gpg-generate-key-only-name-email='gpg --generate-key'
alias gpg-generate-key-full='gpg --full-generate-key'

alias gpg-list-keys='gpg --list-keys' 

alias gpg-delete-both-keys='gpg --delete-secret-and-public-keys'
alias gpg-delete-only-secret-key='gpg --delete-secret-keys'
alias gpg-delete-only-public-key='gpg --delete-keys'

alias gpg-list-fingerprints-by-mail='gpg --list-keys --list-options show-only-fpr-mbox' 

keyservers_all=$(grep --color=never 'keyserver' ~/.gnupg/gpg.conf | awk '{print $2}' | tr '\n' ' ')
first_keysrv=$(echo "$keyservers_all" | awk '{print $1;}')
keyservers=$(echo "$keyservers_all" | cut -d " " -f2-)

fingerprints_all=$(gpg --list-keys --list-options show-only-fpr-mbox | awk '{print $1;}')
first_fgr=$(echo "$fingerprints_all" | awk 'NR==1{print $1}')
fingerprints=$(echo "$fingerprints_all" | awk 'NR>1{print $1}')


function gpg-search-keys-and-import-using-email() {
    reade -Q "GREEN" -p "Email?: " "" mail
    reade -Q "GREEN" -i "n" -p "Set keyserver? (Otherwise looks for last defined keyserver in ~/.gnupg/gpg.conf) [N/y]: " "y" c_srv
    if test "$c_srv" == 'y'; then
        #reade -Q "GREEN" -i "hkp://keys.openpgp.org" -p "Keyserver?: " "hkp://keyserver.ubuntu.com hkp://pgp.mit.edu hkp://pool.sks-keyservers.net hkps://keys.mailvelope.com hkps://api.protonmail.ch" serv 
        reade -Q "GREEN" -i "all" -p "Keyserver?: " "$keyservers_all" serv 
        if test "$serv" == 'all'; then
            for srv in $keyservers_all; do
                echo "Searching $srv"
                "$GPG" --verbose --keyserver "$srv" --search "$mail"  
            done
        else
            "$GPG" --verbose --keyserver "$serv" --search "$mail"  
        fi
    else 
        "$GPG" --verbose --search "$mail"  
    fi
}


function gpg-receive-keys-using-fingerprint() {
    gpg --list-keys --list-options show-only-fpr-mbox
    reade -Q "GREEN" -i "$first_fgr" -p "Fingerprint?: " "$fingerprints" fingrprnt
    reade -Q "GREEN" -i "n" -p "Set keyserver? (Otherwise looks for last defined keyserver in ~/.gnupg/gpg.conf) [N/y]: " "y" c_srv
    if test "$c_srv" == 'y'; then
        #reade -Q "GREEN" -i "hkp://keys.openpgp.org" -p "Keyserver?: " "hkp://keyserver.ubuntu.com hkp://pgp.mit.edu hkp://pool.sks-keyservers.net hkps://keys.mailvelope.com hkps://api.protonmail.ch" serv 
        reade -Q "GREEN" -i "all" -p "Keyserver?: " "$keyservers_all" serv 
        if test "$serv" == 'all'; then
            for srv in $keyservers_all; do
                echo "Searching $srv"
                "$GPG" --verbose --keyserver "$srv" --receive-keys "$fingrprnt"  
            done
        else
            "$GPG" --verbose --keyserver "$serv" --receive-keys "$fingrprnt"  
        fi
    else 
        "$GPG" --verbose --receive-keys "$fingrprnt"  
    fi
}

