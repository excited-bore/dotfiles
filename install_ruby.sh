#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)"
    else
        continue
    fi
else
    . ./checks/check_all.sh
fi

if ! type ruby &>/dev/null || ! type gem &> /dev/null || ! type rbenv &> /dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        eval "${pac_ins} ruby ruby-build rbenv"
    elif [[ $distro_base == "Debian" ]]; then
        eval "${pac_ins} ruby ruby-dev rbenv"
    else
        eval "${pac_ins}" ruby rbenv
    fi

    if ! grep -q 'eval "$(rbenv init -)' ~/.bashrc; then
        printf "eval \"\$(rbenv init -)\"\n" >>~/.bashrc
    fi

    if ! grep -q 'eval "$(rbenv init -' ~/.zshrc; then
        printf "eval \"\$(rbenv init - --no-rehash zsh)\"\n" >>~/.zshrc
    fi

fi

[[ "$SSHELL" == "bash" ]] && source ~/.bashrc
[[ "$SSHELL" == "zsh" ]] && source ~/.zshrc &>/dev/null

#if type rbenv &>/dev/null; then
#    all="$(rbenv install -l)"
#    latest="$(rbenv install -l | grep -v - | tail -1)"
#    all1="$(echo $all | tr '\n' ' ')"
#    printf "Ruby versions:\n${CYAN}$all${normal}\n"
#    reade -Q 'GREEN' -i "$latest $all1" -p "Which version to install? : " vers
#    if ! test -z $vers; then
#        rbenv install "$vers"
#        rbenv global "$vers" &>/dev/null
#        eval "$(rbenv init - --no-rehash $SSHELL)"
#        rbenv shell "$vers" &>/dev/null
#    fi
#fi
unset latest vers all

printf "Ruby version: "
ruby --version

#rver=$(echo $(ruby --version) | awk '{print $2}' | cut -d. -f-2)'.0'
#paths=$(gem environment | awk '/- GEM PATH/{flag=1;next}/- GEM CONFIGURATION/{flag=0}flag' | sed 's|     - ||g' | paste -s -d ':')
#if grep -q "GEM" $ENVVAR; then
#    sed -i "s|.export GEM_|export GEM_|g" $ENVVAR
#    sed -i 's|.export PATH=$PATH:$GEM_PATH|export PATH=$PATH:$GEM_PATH|g' $ENVVAR
#    sed -i "s|export GEM_HOME=.*|export GEM_HOME=$HOME/.gem/ruby/$rver|g" $ENVVAR
#    sed -i "s|export GEM_PATH=.*|export GEM_PATH=$paths|g" $ENVVAR
#    sed -i 's|export PATH=$PATH:$GEM_PATH.*|export PATH=$PATH:$GEM_PATH:$GEM_HOME/bin|g' $ENVVAR
#else
#    printf "export GEM_HOME=$HOME/.gem/ruby/$rver\n" >> $ENVVAR
#    printf "export GEM_PATH=$paths\n" >> $ENVVAR
#    printf "export PATH=\$PATH:\$GEM_PATH:\$GEM_HOME/bin\n" >> $ENVVAR
#fi
#
#source $ENVVAR
