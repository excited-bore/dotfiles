if [ ! -f ~/.bash_aliases.d/rlwrap_scripts.sh ]; then
    . ../aliases/rlwrap_scripts.sh
else
    . ~/.bash_aliases.d/rlwrap_scripts.sh
fi

publickey_mails=$("$GPG" --list-keys | grep --color=never \< | cut -d'<' -f2- | cut -d'>' -f1)
privatekey_mails=$("$GPG" --list-secret-keys | grep --color=never \< | cut -d'<' -f2- | cut -d'>' -f1)

keyservers_all=$(grep --color=never "keyserver" ~/.gnupg/gpg.conf | awk '{print $2}' | tr '\n' ' ')
first_keysrv=$(echo "$keyservers_all" | awk '{print $1;}')
keyservers=$(echo "$keyservers_all" | cut -d " " -f2-)

fingerprints_all=$("$GPG" --list-keys --list-options show-only-fpr-mbox | awk '{print $1;}')
first_fgr=$(echo "$fingerprints_all" | awk 'NR==1{print $1}')
fingerprints=$(echo "$fingerprints_all" | awk 'NR>1{print $1}')

alias gpg-generate-key-only-name-email="$GPG --generate-key"

alias gpg-generate-key-full="$GPG --full-generate-key"

function gpg-generate-key-full(){
     reade -Q "CYAN" -i "n" -p "Expert mode (allow things like generating unusual keytypes)? [N/y]: " "y" xprt
     if test "$xprt" == "y"; then
         $GPG --expert --full-generate-key
     else
         $GPG --full-generate-key
     fi
}

alias gpg-list-public-keys="$GPG --list-public-keys" 
alias gpg-list-secret-keys="$GPG --list-secret-keys"

alias gpg-edit-key="$GPG --edit-key"

function gpg-list-packets-from-key(){
    if test -z "$@"; then
        reade -Q "GREEN" -i "public" -p "Public keys, Private (Secret) keys or Private Subkeys? [Public/private/private-sub]: " "private private-sub" keytype
        if test "$keytype" == "public"; then
            export_keys="--export" 
            reade -Q "GREEN" -i "all" -p "By name or all?: " "$publickey_mails" mail
        elif test "$keytype" == "private"; then
            export_keys="--export-secret-keys" 
            reade -Q "GREEN" -i "all" -p "By name or all?: " "$privatekey_mails" mail
        elif test "$keytype" == "private-sub"; then
            export_keys="--export-secret-subkeys" 
            reade -Q "GREEN" -i "all" -p "By name or all?: " "$privatekey_mails" mail
        fi
        if ! test $mail == 'all'; then
            "$GPG" $export_keys "$mail" | "$GPG" --list-packets | $PAGER 
        else
            "$GPG" $export_keys | "$GPG" --list-packets | $PAGER  
        fi
        
    else
        "$GPG" --list-packets "$@" 
    fi
}

alias gpg-list-keyfile-info="$GPG --import-options show-only" 

alias gpg-delete-both-keys="$GPG --delete-secret-and-public-keys"
alias gpg-delete-only-secret-key="$GPG --delete-secret-keys"
alias gpg-delete-only-public-key="$GPG --delete-keys"

alias gpg-list-public-fingerprints-mail="$GPG --list-keys --list-options show-only-fpr-mbox" 
alias gpg-list-public-keyid-long-mail="$GPG --list-public-keys --list-options show-only-fpr-mbox | awk '{ \$1 = substr(\$1, 25, 40) } 1'" 
alias gpg-list-public-keyid-short-mail="$GPG --list-public-keys --list-options show-only-fpr-mbox | awk '{ \$1 = substr(\$1, 33, 40) } 1'" 
alias gpg-list-public-fingerprints="$GPG --list-keys --list-options show-only-fpr-mbox | awk '{print \$1;}'" 
alias gpg-list-public-keyid-long="$GPG --list-public-keys --list-options show-only-fpr-mbox | awk '{ \$1 = substr(\$1, 25, 40) } 1' | awk '{print \$1;}'" 
alias gpg-list-public-keyid-short="$GPG --list-public-keys --list-options show-only-fpr-mbox | awk '{ \$1 = substr(\$1, 33, 40) } 1' | awk '{print \$1;}'"

function gpg-search-keys-and-import() {
    if test -z "$1"; then 
        reade -Q "GREEN" -p "Name/Email/Fingerprint/Keyid?: " "" mail
    else
        mail="$1"
    fi
    reade -Q "GREEN" -i "n" -p "Set keyserver? (Otherwise looks for last defined keyserver in ~/.gnupg/gpg.conf) [N/y]: " "y" c_srv
    if test "$c_srv" == "y"; then
        #reade -Q "GREEN" -i "hkp://keys.openpgp.org" -p "Keyserver?: " "hkp://keyserver.ubuntu.com hkp://pgp.mit.edu hkp://pool.sks-keyservers.net hkps://keys.mailvelope.com hkps://api.protonmail.ch" serv 
        reade -Q "GREEN" -i "all" -p "Keyserver?: " "$keyservers_all" serv 
        if test "$serv" == "all"; then
            for srv in $keyservers_all; do
                echo "Searching ${bold}${magenta}$srv${normal}"
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
    if test -z "$1"; then 
        reade -Q "GREEN" -i "$first_fgr" -p "Fingerprint?: " "$fingerprints" fingrprnt
    else
        fingrprnt="$1"
    fi
    #$GPG --list-keys --list-options show-only-fpr-mbox
    reade -Q "GREEN" -i "n" -p "Set keyserver? (Otherwise looks for last defined keyserver in ~/.gnupg/gpg.conf) [N/y]: " "y" c_srv
    if test "$c_srv" == 'y'; then
        #reade -Q "GREEN" -i "hkp://keys.openpgp.org" -p "Keyserver?: " "hkp://keyserver.ubuntu.com hkp://pgp.mit.edu hkp://pool.sks-keyservers.net hkps://keys.mailvelope.com hkps://api.protonmail.ch" serv 
        reade -Q "GREEN" -i "all" -p "Keyserver?: " "$keyservers_all" serv 
        if test "$serv" == 'all'; then
            for srv in $keyservers_all; do
                echo "Searching ${bold}${magenta}$srv${normal}"
                "$GPG" --verbose --keyserver "$srv" --receive-keys "$fingrprnt"  
            done
        else
            "$GPG" --verbose --keyserver "$serv" --receive-keys "$fingrprnt"  
        fi
    else 
        "$GPG" --verbose --receive-keys "$fingrprnt"  
    fi
}
