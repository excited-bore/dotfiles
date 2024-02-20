 # !/bin/bash
 PATHVAR=~/.bashrc
 if [ -f ~/.pathvariables.sh ]; then
     PATHVAR=~/.pathvariables.sh
 fi
 echo "This next $(tput setaf 1)sudo$(tput sgr0) checks for the file '/root/.pathvariables.sh'.";
 PATHVAR_R=/root/.bashrc
 if sudo test -f /root/.pathvariables.sh; then
     PATHVAR_R=/root/.pathvariables.sh
 fi
