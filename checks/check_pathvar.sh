 # !/bin/bash
 PATHVAR=~/.bashrc
 if [ -f ~/.pathvariables.sh ]; then
     PATHVAR=~/.pathvariables.sh
 fi
 PATHVAR_R=/root/.bashrc
 if sudo test -f /root/.pathvariables.sh; then
     PATHVAR_R=/root/.pathvariables.sh
 fi
