 # !/bin/bash
 PATHVAR=~/.bashrc
 if [ -f ~/.bash_aliases.d/00-pathvariables.sh ]; then
     PATHVAR=~/.bash_aliases.d/00-pathvariables.sh
 fi
 PATHVAR_R=/root/.bashrc
 if sudo test -f /root/.bash_aliases.d/00-pathvariables.sh; then
     PATHVAR_R=/root/.bash_aliases.d/00-pathvariables.sh
 fi
