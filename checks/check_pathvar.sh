 # !/bin/bash
 PATHVAR=~/.bashrc
 if [ -f ~/.pathvariables.env ]; then
     PATHVAR=~/.pathvariables.env
 fi
 echo "This next $(tput setaf 1)sudo$(tput sgr0) checks for the file '/root/.pathvariables.env'.";
 PATHVAR_R=/root/.bashrc
 if sudo test -f /root/.pathvariables.env; then
     PATHVAR_R=/root/.pathvariables.env
 fi
