#!/usr/bin/env bash

printf " Based on: ${CYAN} https://github.com/mailvelope/mailvelope/wiki/Creating-the-app-manifest-file-on-macOS-and-Linux
"
 # TODO : FIX FOR CHROMIUM BASED BROWSERS
 # https://github.com/mailvelope/mailvelope/wiki/Creating-the-app-manifest-file-on-macOS-and-Linux
 # No idea what im doing wrong?

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type reade &> /dev/null; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if ! type gpgme-json &> /dev/null; then
    echo "Install gpgme-json first"
    return 1
fi
gpgme_json="$(whereis gpgme-json | awk '{print $2;}')"

if test $machine == 'Mac'; then
    if test -d ~/Library/Application Support/Google/Chrome && ! test -f ~/Library/Application Support/Google/Chrome/NativeMessagingHosts/gpgmejson.json; then
        reade -Q "BLUE" -i "y" -p "Add gpgme-json for google chrome based browsers? "" ggl
        if test $ggl == 'y'; then
            file="{ 
          \"name\": \"gpgmejson\", 
          \"description\": \"JavaScript binding for GnuPG\", 
          \"path\": \"$gpgme_json\", 
          \"type\": \"stdio\", 
          \"allowed_origins\": [\"chrome-extension://kajibbejlbohfaggdiogboambcijhkke/\"] 
           }"
            mkdir -p ~/Library/Application Support/Google/Chrome/NativeMessagingHosts 
            echo $file > ~/Library/Application Support/Google/Chrome/NativeMessagingHosts/gpgmejson.json
        fi
    fi

    if test -d ~/Library/Application Support/Microsoft Edge && ! test -f ~/Library/Application Support/Microsoft Edge/NativeMessagingHosts/gpgmejson.json; then
        reade -Q "BLUE" -i "y" -p "Add gpgme-json for Edge? [Y/n]:" "n" edge
        if test $edge == 'y'; then
            file="{ 
          \"name\": \"gpgmejson\", 
          \"description\": \"JavaScript binding for GnuPG\", 
          \"path\": \"$gpgme_json\", 
          \"type\": \"stdio\", 
          \"allowed_origins\": [\"chrome-extension://dgcbddhdhjppfdfjpciagmmibadmoapc/\"] 
           }"
            mkdir -p ~/Library/Application Support/Microsoft Edge/NativeMessagingHosts
            echo $file > ~/Library/Application Support/Microsoft Edge/NativeMessagingHosts/gpgmejson.json
        fi
    fi
    if test -d ~/Library/Application Support/Mozilla && ! test -f ~/Library/Application Support/Mozilla/NativeMessagingHosts/NativeMessagingHosts/gpgmejson.json; then
        reade -Q "BLUE" -i "y" -p "Add gpgme-json for firefox? "" mozilla
        if test $mozilla == 'y'; then
            file="{ 
          \"name\": \"gpgmejson\", 
          \"description\": \"JavaScript binding for GnuPG\", 
          \"path\": \"$gpgme_json\", 
          \"type\": \"stdio\", 
          \"allowed_extensions\": [\"jid1-AQqSMBYb0a8ADg@jetpack\"] 
           }"
            mkdir -p ~/Library/Application Support/Mozilla/NativeMessagingHosts 
            echo $file > ~/Library/Application Support/Mozilla/NativeMessagingHosts/gpgmejson.json
        fi
    fi
elif test $machine == 'Linux'; then
    if test -d ~/.config/google-chrome/ && ! test -f ~/.config/google-chrome/NativeMessagingHosts/gpgmejson.json; then
        reade -Q "BLUE" -i "y" -p "Add gpgme-json for google chrome based browsers? "" ggl
        if test $ggl == 'y'; then
            file="{ 
          \"name\": \"gpgmejson\", 
          \"description\": \"JavaScript binding for GnuPG\", 
          \"path\": \"$gpgme_json\", 
          \"type\": \"stdio\", 
          \"allowed_origins\": [\"chrome-extension://kajibbejlbohfaggdiogboambcijhkke/\"] 
           }"
            mkdir -p ~/.config/google-chrome/NativeMessagingHosts 
            echo $file > ~/.config/google-chrome/NativeMessagingHosts/gpgmejson.json
        fi
    fi
    if test -d ~/.config/BraveSoftware/Brave-Browser/ && ! test -f ~/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts/gpgmejson.json; then
        reade -Q "BLUE" -i "y" -p "Add gpgme-json for brave browser? "" brave
        if test $brave == 'y'; then
            file="{ 
          \"name\": \"gpgmejson\", 
          \"description\": \"JavaScript binding for GnuPG\", 
          \"path\": \"$gpgme_json\", 
          \"type\": \"stdio\", 
          \"allowed_origins\": [\"chrome-extension://kajibbejlbohfaggdiogboambcijhkke/\"] 
           }"
            mkdir -p ~/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts 
            echo $file > ~/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts/gpgmejson.json
        fi
    fi
    if test -d ~/.config/microsoft-edge/ && ! test -f ~/.config/microsoft-edge/NativeMessagingHosts/gpgmejson.json; then
        reade -Q "BLUE" -i "y" -p "Add gpgme-json for Edge? "" edge
        if test $edge == 'y'; then
            file="{
          \"name\": \"gpgmejson\", 
          \"description\": \"JavaScript binding for GnuPG\", 
          \"path\": \"$gpgme_json\", 
          \"type\": \"stdio\", 
          \"allowed_origins\": [\"chrome-extension://dgcbddhdhjppfdfjpciagmmibadmoapc/\"] 
           }"
            mkdir -p ~/.config/microsoft-edge/NativeMessagingHosts 
            echo $file > ~/.config/microsoft-edge/NativeMessagingHosts/gpgmejson.json
        fi
    fi
    if test -d ~/.mozilla/ && ! test -f ~/.mozilla/native-messaging-hosts/gpgmejson.json; then
        reade -Q "BLUE" -i "y" -p "Add gpgme-json for firefox? "" mozilla
        if test $mozilla == 'y'; then
            file="{
          \"name\": \"gpgmejson\", 
          \"description\": \"JavaScript binding for GnuPG\", 
          \"path\": \"$gpgme_json\", 
          \"type\": \"stdio\", 
          \"allowed_extensions\": [\"jid1-AQqSMBYb0a8ADg@jetpack\"] 
           }"
            mkdir -p ~/.mozilla/native-messaging-hosts
            echo $file > ~/.mozilla/native-messaging-hosts/gpgmejson.json
        fi
    fi
    echo "${GREEN}Done!${normal} Don't forget to restart the ${CYAN}mailvelope${normal} extension if your browser is already running!"       
else
    echo "Sorry,$machine not supported"
    return 1
fi


unset mozilla edge brave ggl 
