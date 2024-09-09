##### GPG ####

if ! type reade &> /dev/null ; then
    source ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

type gpg2 &> /dev/null && export GPG='gpg2' || export GPG='gpg'
if test -z $GNUPGHOME; then
    GNUPGHOME=$HOME/.gnupg
fi

# Arch specific issue
# https://forum.gnupg.org/t/problem-with-socket-connection-refused/4669/2
if grep -q '^log-file socket://' $GNUPGHOME/gpg.conf; then
    sed -i 's|^log-file socket://|#log-file socket://|g' $GNUPGHOME/gpg.conf
fi

#publickey_mails=$("$GPG" --list-keys 2>/dev/null | grep --color=never \< | cut -d'<' -f2- | cut -d'>' -f1)
#privatekey_mails=$("$GPG" --list-secret-keys 2>/dev/null | grep --color=never \< | cut -d'<' -f2- | cut -d'>' -f1)
alias gpg-refresh-keys='gpg --refresh-keys'
alias gpg-list-publickey-mails="$GPG --list-keys | grep --color=never \< | cut -d'<' -f2- | cut -d'>' -f1"
alias gpg-list-privatekey-mails="$GPG --list-secret-keys | grep --color=never \< | cut -d'<' -f2- | cut -d'>' -f1"
alias gpg-list-known-keyservers="grep --color=never "^keyserver" $GNUPGHOME/gpg.conf | grep -v --color=never "keyserver-" | awk '{print $2}' | tr '\n' ' '"


#fingerprints_all=$("$GPG" --list-keys --list-options show-only-fpr-mbox 2>/dev/null | awk '{print $1;}')
alias gpg-list-key-fingerprints="$GPG --list-keys --list-options show-only-fpr-mbox | awk '{print $1;}'"

mailregex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"

function receive-mails-csv-file(){
        if test -z $1; then
            reade -Q "GREEN" -p "Passwords.csv file?: " -e file 
            if ! test -f "$file"; then
                printf "File doesnt't exist!\n"
                return 1
            fi
        elif test -f $1; then
            file=$1
        fi
        s='firefox'
        d="[Firefox/chrome]"
        if [[ $file =~ 'Chrome' ]]; then
            s='chrome'
            d="[Chrome/firefox]"
        fi
        reade -Q "GREEN" -i "$s" -p "Chrome or firefox based? $d: " "chrome" based
        
        if test $based == 'firefox'; then
            b=$(cat "$file" | tr ',' ' '| awk '{print $2;}')
        else
            b=$(cat "$file" | tr ',' ' '| awk '{print $3;}')
        fi
        b=$(echo -e "$b" | sort -u)
        o=''
        for i in $b ; do
            if echo $i | grep -q "@" && [[ $i =~ $mailregex ]]; then
                o="$o $i"
            fi
        done
        echo "$o"
        unset b o d i s file
}


function gpg-publish-key() {
    keyservers_all=$(grep --color=never "^keyserver" $GNUPGHOME/gpg.conf | grep -v --color=never "keyserver-" | awk '{print $2}' | tr '\n' ' ')
    printf "${CYAN}Hint: If rlwrap is installed, tab completion is enabled${normal}\n"
    if ! test -z "$1"; then 
        dir="--homedir $1"
    else
        reade -Q "GREEN" -p "Homedirectory where gpg-files are stored? (could be thunderbird profilefolder f.ex. / leave empty for $GNUPGHOME): " -e dir 
        if ! test -d $dir; then
            printf "$dir not a dir!\n"
            return 1 
        elif ! test -z $dir; then
            dir="--homedir $dir"
        fi
    fi 
    if test -z "$2"; then 
        mails=$($GPG $dir --list-keys --list-options show-only-fpr-mbox | awk '{print $2;}')
        reade -Q "GREEN" -i "' '" -p "Get fingerprints from which mails? (All is option - Separate by spaces and add quotation marks around if using multiple fingerprints): " "all $mails" keyid
        keyid=$($GPG --list-keys --list-options show-only-fpr-mbox $keyid | awk '{print $1;}' )
    else
        keyid="$2"
    fi
    reade -Q "GREEN" -i "n" -p "Set keyserver? (Otherwise looks for last defined keyserver in \$GNUPGHOME/.gnupg/gpg.conf) [N/y]: " "y" c_srv
    if test "$c_srv" == "y"; then
        printf "Known keyservers from \$GNUPGHOME/gpg.conf: \n"
        for i in $keyservers_all; do
            printf "\t- ${CYAN}$i${normal}\n"
        done
        reade -Q "GREEN" -i "' '" -p "Keyserver? (separate by spaces and add quotation marks around if using multiple servers; f.ex. 'keys.openpgp.org keys.mailvelope.com' ): " "all $keyservers_all" serv 
        if test "$serv" == "all"; then
            for srv in $keyservers_all; do
                succeeded=0
                while test $succeeded == 0; do
                    printf "Trying to send ${bold}${magenta}$srv${normal} fingerprint(s)/keyid(s)\n ${CYAN}$keyid${normal}\n"
                    "$GPG" $dir --verbose --keyserver "$srv" --send-key $keyid  
                    if [[ $? > 0 ]]; then
                        reade -Q "YELLOW" -i "y" -p "Failed sending key to server. Retry? [Y/n]: " "n" retry 
                        if test $retry == 'n'; then
                            succeeded=1    
                        fi
                    else
                        succeeded=1
                    fi
                done
            done
        else
            for s in $serv; do
                succeeded=0
                echo $keyid
                while test $succeeded == 0; do
                    printf "Trying to send ${bold}${magenta}$s${normal} fingerprint(s)/keyid(s):\n ${CYAN}$keyid${normal}\n"
                    "$GPG" $dir --verbose --keyserver "$s" --send-key $keyid  
                    if [[ $? > 0 ]]; then
                        reade -Q "YELLOW" -i "y" -p "Failed sending key to server. Retry? [Y/n]: " "n" retry 
                        if test $retry == 'n'; then
                            succeeded=1    
                        fi
                    else
                        succeeded=1
                    fi
                done
            done
        fi
    else 
        succeeded=0
        while test $succeeded == 0; do
            printf "Trying to send fingerprint(s)/keyid(s):\n ${CYAN}$keyid${normal}\n"
            "$GPG" $dir --verbose --send-key $keyid  
            if [[ $? > 0 ]]; then
                reade -Q "YELLOW" -i "y" -p "Failed sending key to server. Retry? [Y/n]: " "n" retry 
                if test $retry == 'n'; then
                    succeeded=1    
                fi
            else
                succeeded=1
            fi
        done
    fi
    unset c_serv keyid serv srv i s keyservers_all succeeded retry keyid dir mails
}


function gpg-get-emails-exported-browserlogins-and-generate-keys(){
    printf "Make sure to check ${cyan}$HOME/.gnupg/gpg.conf${normal} for algorithm preferences.\n"
    printf "At default ECC (Elliptic-curve cryptography) is used for both signing and encryption:\n - ${GREEN}the public-private keypair${normal} is made using ed25519, used for certification and signing\n - ${CYAN}the subkeys for both keys in the pair${normal} are generated use cv25519, used for encryption - these are generated because it would be bad a idea to use the same key for both signing and encryption. So, GPG uses a separate subkey for at least encryption.\nMore on why GPG also generates ${CYAN}subkeys${normal}:\nhttps://rgoulter.com/blog/posts/programming/2022-06-10-a-visual-explanation-of-gpg-subkeys.html\nhttps://serverfault.com/questions/397973/gpg-why-am-i-encrypting-with-subkey-instead-of-primary-key\n"
    #When hashes for fingerprints are generated they are based on your OpenPGP fingerprint Version, wich most likely is V4 and thus are generated using the SHA-1 hashing algorithm. More on how safe this is here: https://security.stackexchange.com/questions/68105/gpg-keys-sha-1)
    printf "${CYAN}Hint: If rlwrap is installed, tab completion is enabled${normal}\n"
    
    if test -z $1; then 
        mails=$(receive-mails-csv-file)
        if test "$mails" == 1; then
            return 1
        fi
    else
        mails=$1
    fi

    reade -Q "GREEN" -p "Homedirectory where gpg-files are stored? (could be thunderbird profilefolder f.ex. / leave empty for $GNUPGHOME): " -e dir_p 
    if ! test -d $dir_p; then
        printf "$dir_p not a dir!\n"
        return 1 
    fi

    if ! test -z $dir_p; then
        dir="--homedir $dir_p"
    fi

    default_key=''
    #reade -Q "CYAN" -i "n" -p "Set custom algorithm? (Default \"ed25519/cert,sign+cv25519/encr\") [N/y]: " "y" algo 
    reade -Q "CYAN" -i "n" -p "Set custom algorithm? (Default Ecc type 'ed25519' for cert,sign and seperate 'cv25519' key for encr) [N/y]: " "y" algo 
    
    if test "$algo" == 'y'; then
        printf "Default suggestions GPG defaults\n"
        reade -Q "GREEN" -i 'ecc' -p "Signing/Certifying key algorithm? (Elliptic-curve/Rivest–Shamir–Adleman/Digital Signature Algorithm) [ecc/rsa/dsa]: " "rsa dsa" pubkey
        if test $pubkey == 'rsa' || test $pubkey == 'dsa'; then   
                reade -Q "GREEN" -i '8192' -p "Set the length (in bits) for the keys. 8192 is given at default because it automatically shifts to the highest amount in bits possible: " "4096 2048 1024" length               
                pubkey="$pubkey$length"
        elif test $pubkey == 'ecc'; then
            reade -Q "GREEN" -i 'ed25519' -p "What Elliptic-curve cryptography keyalgorithm would you like? [ed25519/ed488/nistp256/nistp384/nistp521/brainpoolP256r1/brainpoolP384r1/brainpoolP512r1/secp256k1]: " "ed488 nistp256 nistp384 nistp521 brainpoolP256r1 brainpoolP384r1 brainpoolP512r1 secp256k1" pubkey
        fi

        reade -Q "GREEN" -i 'cert,sign' -p "Keyuse: (Default: signing and certification) [cert,sign/cert/sign]: " "cert sign" cert_sign

        reade -Q "GREEN" -i 'y' -p "Set custom expiration date for primary key? (Default: 3 years) [Y/n]: " "n" exp
        if test $exp == 'y'; then
            printf "${CYAN}\t - Set expiration to a set date\n\t - Set to date including hours, minutes and seconds\n\t - Set by period valid\n\t - Set to never expire \n\t(f.ex. 25/02/2059 vs 2059-11-13T10:39:35 vs 10y vs never)\n"
            reade -Q "GREEN" -i 'period' -p "[Period/date-hour/date/never]?: " "date date-hour never" exp
            year=$(expr $(date --iso-8601 | tr '-' ' ' |  awk '{print $1}') + 3)
            month=$(date --iso-8601 | tr '-' ' ' |  awk '{print $2}')
            day=$(date --iso-8601 | tr '-' ' ' |  awk '{print $3}')
            if test $exp == 'date'; then
                reade -Q "GREEN" -i "$year" -p "Year? : " "" year
                reade -Q "GREEN" -i "$month" -p "Month? : " "" month
                reade -Q "GREEN" -i "$day" -p "Day? : " "" day
                if [[ ${#month} < 2 ]]; then
                    month="0$month"
                fi
                if [[ ${#day} < 2 ]]; then
                    day="0$day"
                fi
                exp="$year-$month-$day"
            elif test $exp == 'date-hour'; then
                reade -Q "GREEN" -i "$year" -p "Year?: " "" year
                reade -Q "GREEN" -i "$month" -p "Month?: " "" month
                reade -Q "GREEN" -i "$day" -p "Day?: " "" day
                reade -Q "GREEN" -i "00" -p "Hour?: " "" hour
                reade -Q "GREEN" -i "00" -p "Minute?: " "" minute
                reade -Q "GREEN" -i "00" -p "Seconds?: " "" seconds
                if [[ ${#month} < 2 ]]; then
                    month="0$month"
                fi
                if [[ ${#day} < 2 ]]; then
                    day="0$day"
                fi
                if [[ ${#hour} < 2 ]]; then
                    hour="0$hour"
                fi
                if [[ ${#minute} < 2 ]]; then
                    minute="0$minute"
                fi
                if [[ ${#seconds} < 2 ]]; then
                    seconds="0$seconds"
                fi
                exp="$year$month$day""T""$hour$minute$seconds"
            elif test $exp == 'period'; then
                reade -Q "GREEN" -i "years" -p "Period? [Years/months/weeks/days/seconds]: " "months weeks days seconds" period
                reade -Q "GREEN" -i "3" -p "Number of $period?: " "" num_period
                exp="$num_period$period"
            fi
        fi

        reade -Q "GREEN" -i 'y' -p "Add encryption subkey? (Using a different key for signing/verifying and encryption/decryption is good practice) [Y/n]: " "n" enckeys
        if test $enckeys == 'y' && ! [[ $pubkey =~ 'dsa' ]]; then
            reade -Q "GREEN" -i 'y' -p "Same algorithm for encryption subkey? [Y/n]: " "n" enckeys
            if test $enckeys == 'n'; then
                reade -Q "GREEN" -i 'elg' -p "Wich encryption algorithm? [elg (ElGamal - Default)/rsa/ecc(Elliptic-curve cryptography)]: " "rsa ecc" enckey
                if test $enckey == 'rsa' || test $enckey == 'elg'; then   
                    reade -Q "GREEN" -i '8192' -p "Set the length (in bits) for the keys. 8192 is given at default because it automatically shifts to the highest amount in bits possible: " "4096 2048 1024" lengthenc            
                    enckey="$enckey$lengthenc"
                elif test $enckey == 'ecc'; then
                    reade -Q "GREEN" -i 'cv25519' -p "What Elliptic-curve cryptography keyalgorithm would you like? [cv25519/cv488/nistp256/nistp384/nistp521/brainpoolP256r1/brainpoolP384r1/brainpoolP512r1/secp256k1]: " "cv488 nistp256 nistp384 nistp521 brainpoolP256r1 brainpoolP384r1 brainpoolP512r1 secp256k1" enckey
                fi   
                #default_key="$pubkey/cert,sign+$enckey/encr"
            fi
        elif [[ $pubkey =~ 'dsa' ]]; then
            printf "Need a different algorithm for encryption (Dsa is only for signing)\n"
            reade -Q "GREEN" -i 'elg' -p "Wich encryption algorithm? [elg (ElGamal - Default)/rsa/ecc(Elliptic-curve cryptography)]: " "rsa ecc" enckey
            if test $enckey == 'rsa' || test $enckey == 'elg'; then   
                reade -Q "GREEN" -i '8192' -p "Set the length (in bits) for the keys. 8192 is given at default because it automatically shifts to the highest amount in bits possible: " "4096 2048 1024" lengthenc            
                enckey="$enckey$lengthenc"
            elif test $enckey == 'ecc'; then
                reade -Q "GREEN" -i 'cv25519' -p "What Elliptic-curve cryptography keyalgorithm would you like? [cv25519/cv488/nistp256/nistp384/nistp521/brainpoolP256r1/brainpoolP384r1/brainpoolP512r1/secp256k1]: " "cv488 nistp256 nistp384 nistp521 brainpoolP256r1 brainpoolP384r1 brainpoolP512r1 secp256k1" enckey
            fi
            #default_key="$pubkey/cert,sign+$enckey/encr"
            #default_key="$pubkey/cert,sign"
        elif [[ $pubkey =~ "ed" ]]; then
            enckey=$(echo $pubkey | sed 's|ed|cv|')
        fi
        
        reade -Q "GREEN" -i 'y' -p "Set custom expiration date for subkey? (Default: 3 years) [Y/n]: " "n" exp
        if test $exp == 'y'; then
            printf "${CYAN}\t - Set expiration to a set date\n\t - Set to date including hours, minutes and seconds\n\t - Set by period valid\n\t - Set to never expire \n\t(f.ex. 25/02/2059 vs 2059-11-13T10:39:35 vs 10y vs never)\n"
            reade -Q "GREEN" -i 'date' -p "[Date/Date-hour/period/never]?: " "date-hour period never" exp
            year=$(expr $(date --iso-8601 | tr '-' ' ' |  awk '{print $1}') + 3)
            month=$(date --iso-8601 | tr '-' ' ' |  awk '{print $2}')
            day=$(date --iso-8601 | tr '-' ' ' |  awk '{print $3}')
            if test $exp == 'date'; then
                reade -Q "GREEN" -i "$year" -p "Year? : " "" year
                reade -Q "GREEN" -i "$month" -p "Month? : " "" month
                reade -Q "GREEN" -i "$day" -p "Day? : " "" day
                if [[ ${#month} < 2 ]]; then
                    month="0$month"
                fi
                if [[ ${#day} < 2 ]]; then
                    day="0$day"
                fi
                exp="$year-$month-$day"
            elif test $exp == 'date-hour'; then
                reade -Q "GREEN" -i "$year" -p "Year?: " "" year
                reade -Q "GREEN" -i "$month" -p "Month?: " "" month
                reade -Q "GREEN" -i "$day" -p "Day?: " "" day
                reade -Q "GREEN" -i "00" -p "Hour?: " "" hour
                reade -Q "GREEN" -i "00" -p "Minute?: " "" minute
                reade -Q "GREEN" -i "00" -p "Seconds?: " "" seconds
                if [[ ${#month} < 2 ]]; then
                    month="0$month"
                fi
                if [[ ${#day} < 2 ]]; then
                    day="0$day"
                fi
                if [[ ${#hour} < 2 ]]; then
                    hour="0$hour"
                fi
                if [[ ${#minute} < 2 ]]; then
                    minute="0$minute"
                fi
                if [[ ${#seconds} < 2 ]]; then
                    seconds="0$seconds"
                fi
                exp="$year$month$day""T""$hour$minute$seconds"
            elif test $exp == 'period'; then
                reade -Q "GREEN" -i "years" -p "Period? [Years/months/weeks/days/seconds]: " "months weeks days seconds" period
                reade -Q "GREEN" -i "3" -p "Number of $period?: " "" num_period
                exp="$num_period$period"
            fi
        fi
        
    fi
    reade -Q "YELLOW" -i "n" -p "Never use passwords when generating keys? [N/y]: " 'y' always_no_pw

    private_mails=$("$GPG" $dir --list-secret-keys | grep --color=never \< | cut -d'<' -f2- | cut -d'>' -f1)
    
    mails_with_gen_keys=""
    
    for i in $mails; do
        # Remove " before and after mail (i)
        i=${i#"\""}
        i=${i%"\""}
        
        # Get name by printing mail with any numbers, cutting away the part after @, replace _/-/. with spaces and then uppercase first letter of each space seperated word
        i_name="$(printf '%s\n' ${i//[[:digit:]]/} | cut -d@ -f1 | sed 's|_| |g' | sed 's|-| |g' | sed 's|\.| |' | sed -r 's/[^[:space:]]*[0-9][^[:space:]]* ?//g' | sed -e 's/\b\(.\)/\u\1/g')"

        if ! echo "$private_mails" | grep $i; then
            reade -Q "GREEN" -i "y" -p "No secret key found for ${CYAN}$i${GREEN}. Generate key? [Y/n]: " "n" gen
            #if ! $same_way; then
            if test $gen == 'y'; then
                mails_with_gen_keys="$mails_with_gen_keys $i"
                reade -Q "GREEN" -i "'$i_name'" -p "Name? (Can remain empty, use 'John Doe' when using spaces): " "" name
                reade -Q "GREEN" -i "''" -p "Comment? (Can remain empty): " "" comment

                if test $always_no_pw == 'n'; then
                    reade -Q "YELLOW" -i "n" -p "No password? [N/y]: " 'y' nopw
                else
                    nopw="$always_no_pw"
                fi

                if ! test -z $comment; then
                    comment="($comment)"
                fi

                if test $nopw == 'y' ; then
                    if ! test -z $pubkey; then
                        echo '' | $GPG $dir --batch --yes --passphrase-fd 0 --quick-generate-key "$name $comment <$i>" $pubkey $cert_sign $exp
                    else
                        echo '' | $GPG $dir  --batch --yes --passphrase-fd 0 --quick-generate-key "$name $comment <$i>"
                    fi
                else
                    if ! test -z $pubkey; then
                        $GPG $dir --quick-generate-key "$name $comment <$i>" $pubkey $cert_sign $exp 
                    else
                        $GPG $dir --quick-generate-key "$name $comment <$i>"  
                    fi 
                fi

                if test $enckeys == 'y'; then
                    fpr=$(gpg --list-options show-only-fpr-mbox --list-secret-keys $i | awk '{print $1;}')
                    if test $nopw == 'y' ; then
                        echo '' | $GPG $dir --batch --yes --passphrase-fd 0 --quick-generate-key $fpr $enckey encrypt $exp_sub
                    else
                        $GPG $dir --batch --pinentry-mode=loopback --quick-add-key $fpr $enckey encrypt $exp_sub
                    fi       
                fi
            fi
        fi
    done
    $GPG $dir --list-secret-keys $mails_with_gen_keys
    
    reade -Q "CYAN" -i "n" -p "Publish keys to keyserver(s)? [N/y]: " "y" publish
    if test $publish == 'y'; then
        printf "Generated keys for these mails:\n ${CYAN}$mails_with_gen_keys${normal}\n"     
        reade -Q "GREEN" -i 'y' -p "Publish keys from these emails? [Y/n]: " "n" add_mail
        if test $add_mail == 'n'; then
            privatekey_mails=$("$GPG" $dir --list-secret-keys | grep --color=never \< | cut -d'<' -f2- | cut -d'>' -f1)
            printf "Known mails: \n$privatekey_mails\n"
            reade -Q "GREEN" -i "' '" -p "Which mails ? (tab completion enabled - leave quotation marks when giving multiple - remove for all): " "all $privatekey_mails" mails_with_gen_keys
            if test "$mails_with_gen_keys" == 'all'; then
                mails_with_gen_keys=''
                for m in $privatekey_mails; do
                    mails_with_gen_keys="$mails_with_gen_keys $m"
                done
            fi
        fi
        printf "Using the key from these mails to send to keyserver(s):\n ${BLUE}$mails_with_gen_keys\n"
        gpg-publish-key $dir_p "$($GPG $dir --list-keys --list-options show-only-fpr-mbox $mails_with_gen_keys | awk '{print $1;}')" 
    fi

    printf "${GREEN}Done!\n"

    reade -Q "GREEN" -i "n" -p "Remove ${CYAN}$file? [N/y]: " "y" rm_file
    if test $rm_file == 'y'; then
        rm -v $file
    fi
    
    printf "If using thunderbird, don't forget to restart and/or reload keycache! ('Tools->OpenPGP KeyManager->File->Reload KeyCache')\n"

    unset b i m regex private_mails rm_file publish add_mail mails_with_gen_keys
}


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
alias gpg-list-config="$GPG --list-config --with-colons"
alias gpg-list-keyfile-info="$GPG --import-options show-only" 

alias gpg-list-public-fingerprints-mail="$GPG --list-keys --list-options show-only-fpr-mbox" 
alias gpg-list-public-keyid-long-mail="$GPG --list-public-keys --list-options show-only-fpr-mbox | awk '{ \$1 = substr(\$1, 25, 40) } 1'" 
alias gpg-list-public-keyid-short-mail="$GPG --list-public-keys --list-options show-only-fpr-mbox | awk '{ \$1 = substr(\$1, 33, 40) } 1'" 
alias gpg-list-public-fingerprints="$GPG --list-keys --list-options show-only-fpr-mbox | awk '{print \$1;}'" 
alias gpg-list-public-keyid-long="$GPG --list-public-keys --list-options show-only-fpr-mbox | awk '{ \$1 = substr(\$1, 25, 40) } 1' | awk '{print \$1;}'" 
alias gpg-list-public-keyid-short="$GPG --list-public-keys --list-options show-only-fpr-mbox | awk '{ \$1 = substr(\$1, 33, 40) } 1' | awk '{print \$1;}'"

function gpg-list-packets-from-key(){
    publickey_mails=$("$GPG" --list-keys | grep --color=never \< | cut -d'<' -f2- | cut -d'>' -f1)
    privatekey_mails=$("$GPG" --list-secret-keys | grep --color=never \< | cut -d'<' -f2- | cut -d'>' -f1)
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
    unset publickey_mails privatekey_mails export_keys 
}

alias gpg-edit-key="$GPG --edit-key"
alias gpg-import="$GPG --import"

function gpg-export-public-keys(){
    reade -Q "GREEN" -i "keys" -p "File name? (Script will add file-extension .asc): " "" name
    mails=$($GPG --list-keys --list-options show-only-fpr-mbox | awk '{print $2;}')
    reade -Q "GREEN" -i "' '" -p "Based on which mails ? (all is a choice - leave quotation marks when giving multiple - tab completion enabled): " "all $mails" mails
    if test "$mails" == "all"; then
       mails='' 
    fi
    $GPG -v --armor --export $mails > $name.asc
    echo "Exported keys to ./$name.asc!"
    reade -Q "GREEN" -i "y" -p "Import to gpg located in other dir? [Y/n]: " "n" dir
    if test $dir == 'y'; then 
        reade -Q "GREEN" -p "Where is other GPG homedir?: " -e dir
        $GPG --homedir $dir --import $name.asc
    fi
}

function gpg-export-secret-keys(){
    reade -Q "GREEN" -i "keys" -p "File name? (Script will add file-extension .asc): " "" name
    mails=$($GPG --list-keys --list-options show-only-fpr-mbox | awk '{print $2;}')
    reade -Q "GREEN" -i "' '" -p "Based on which mails ? (all is a choice - leave quotation marks when giving multiple - tab completion enabled): " "all $mails" mails
    if test "$mails" == "all"; then
       mails='' 
    fi
    $GPG --armor --export-secret-keys $mails > $name.asc
    $GPG --armor --export-secret-subkeys $mails | tee -a $name.asc &> /dev/null
    echo "Exported keys to ./$name.asc!"
    reade -Q "GREEN" -i "y" -p "Import to gpg located in other dir? [Y/n]: " "n" dir
    if test $dir == 'y'; then 
        reade -Q "GREEN" -p "Where is other GPG homedir?: " -e dir
        $GPG --homedir $dir --import $name.asc
    fi 
}

function gpg-export-public-and-secret-keys(){
    reade -Q "GREEN" -i "keys" -p "File name? (Script will add file-extension .asc): " "" name
    mails=$($GPG --list-keys --list-options show-only-fpr-mbox | awk '{print $2;}')
    reade -Q "GREEN" -i "' '" -p "Based on which mails ? (all is a choice - leave quotation marks when giving multiple - tab completion enabled): " "all $mails" mails
    if test "$mails" == "all"; then
       mails='' 
    fi
    $GPG --armor --export $mails > $name.asc 
    $GPG --armor --export-secret-keys $mails | tee -a $name.asc &> /dev/null
    $GPG --armor --export-secret-subkeys $mails | tee -a $name.asc &> /dev/null
    echo "Exported keys to ./$name.asc!"
    reade -Q "GREEN" -i "y" -p "Import to gpg located in other dir? [Y/n]: " "n" dir
    if test $dir == 'y'; then 
        reade -Q "GREEN" -p "Where is other GPG homedir?: " -e dir
        $GPG --homedir $dir --import $name.asc
    fi
}

alias gpg-delete-both-keys="$GPG --yes --delete-secret-and-public-keys"
alias gpg-delete-only-secret-key="$GPG --yes --delete-secret-keys"
alias gpg-delete-only-public-key="$GPG --yes --delete-keys"


function gpg-search-keys-keyserver-by-mail() {
    publickey_mails=$("$GPG" --list-keys | grep --color=never \< | cut -d'<' -f2- | cut -d'>' -f1)
    keyservers_all=$(grep --color=never "^keyserver" $GNUPGHOME/gpg.conf | grep -v --color=never "keyserver-" | awk '{print $2}' | tr '\n' ' ')
    fingerprints_all=$("$GPG" --list-keys --list-options show-only-fpr-mbox | awk '{print $1;}')

    if test -z "$1"; then 
        reade -Q "GREEN" -i "' '" -p "Name/Email/Fingerprint/Keyid?: " "all-mails all-finger $publickey_mails $fingerprints_all" mail
    elif test -f "$1"; then
        mail=$(cat "$1" | awk '{print $2;}')  
    else
        mail="$1"
    fi

    if test "$mail" == 'all-mails'; then
        mail="$publickey_mails"
    elif test "$mail" == 'all-finger'; then
        mail="$fingerprints_all"
    fi
    reade -Q "GREEN" -i "n" -p "Set keyserver? (Otherwise looks for last defined keyserver in \$GNUPGHOME/.gnupg/gpg.conf) [N/y]: " "y" c_srv
    if test "$c_srv" == "y"; then
        #reade -Q "GREEN" -i "hkp://keys.openpgp.org" -p "Keyserver?: " "hkp://keyserver.ubuntu.com hkp://pgp.mit.edu hkp://pool.sks-keyservers.net hkps://keys.mailvelope.com hkps://api.protonmail.ch" serv 
        printf "Known keyservers from \$GNUPGHOME/gpg.conf: \n"
        for i in $keyservers_all; do
            printf "\t- ${CYAN}$i${normal}\n"
        done
        reade -Q "GREEN" -i "all" -p "Keyserver? (Default: all known): " "$keyservers_all" serv 
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
    unset publickey_mails fingerprints_all mail keyservers_all srv i
}

function gpg-receive-keys-keyserver-by-fingerprints() {
    publickey_mails=$("$GPG" --list-keys | grep --color=never \< | cut -d'<' -f2- | cut -d'>' -f1)
    keyservers_all=$(grep --color=never "^keyserver" $GNUPGHOME/gpg.conf | grep -v --color=never "keyserver-" | awk '{print $2}' | tr '\n' ' ')
    fingerprints_all=$("$GPG" --list-keys --list-options show-only-fpr-mbox | awk '{print $1;}')
    
    if test -z "$1"; then 
        reade -Q "GREEN" -i "mail" -p "Lookup fingerprint by mail or select fingerprint directly? [Mail/fingerprint]: " "fingerprint" fingrprnt_mail
        if test $fingrprnt_mail == 'mail' ; then
            reade -Q "GREEN" -i "' '" -p "Mail(s)?: " "all $publickey_mails" mails
            if test $mails == all; then
                mails="$publickey_mails"
            fi
            $GPG --list-keys --list-options show-only-fpr-mbox $mails
            fingerprints_some=$($GPG --list-keys --list-options show-only-fpr-mbox $mails | awk '{print $1;}')
            reade -Q "GREEN" -i "' '" -p "Fingerprint(s)?: " "all $fingerprints_some" fingrprnt
            if test $fingrprnt == all; then
                fingrprnt="$fingerprints_some"
            fi 
        else
            reade -Q "GREEN" -i "' '" -p "Fingerprint(s)?: " "all $fingerprints_all" fingrprnt
        fi
    else
        fingrprnt="$1"
    fi
    if test "$fingrprnt" == 'all'; then
        fingrprnt="$fingerprints_all"
    fi
    reade -Q "GREEN" -i "n" -p "Set keyserver? (Otherwise looks for last defined keyserver in \$GNUPGHOME/.gnupg/gpg.conf) [N/y]: " "y" c_srv
    if test "$c_srv" == 'y'; then
        #reade -Q "GREEN" -i "hkp://keys.openpgp.org" -p "Keyserver?: " "hkp://keyserver.ubuntu.com hkp://pgp.mit.edu hkp://pool.sks-keyservers.net hkps://keys.mailvelope.com hkps://api.protonmail.ch" serv 
        printf "Known keyservers from \$GNUPGHOME/gpg.conf: \n"
        for i in $keyservers_all; do
            printf "\t- ${CYAN}$i${normal}\n"
        done
        reade -Q "GREEN" -i "all" -p "Keyserver? (Default: all known): " "$keyservers_all" serv 
        if test "$serv" == 'all'; then
            for srv in $keyservers_all; do
                echo "Searching ${bold}${magenta}$srv${normal}"
                "$GPG" --verbose --keyserver "$srv" --receive-keys $fingrprnt  
            done
        else
            "$GPG" --verbose --keyserver "$serv" --receive-keys $fingrprnt  
        fi
    else 
        "$GPG" --verbose --receive-keys $fingrprnt  
    fi
    unset publickey_mails fingrprnt fingrprnt_mail fingerprints_all mails fingerprints_some mails srv c_srv keyservers_all 
}


unset publickey_mails privatekey_mails keyservers_all first_keysrv keyservers fingrprnt fingerprints_some mail mails mailregex
