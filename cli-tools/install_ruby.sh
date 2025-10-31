# https://www.ruby-lang.org/en/

hash ruby &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi


if [[ "$distro_base" == "Arch" ]]; then
    eval "${pac_ins_y} ruby ruby-build rbenv"
elif [[ $distro_base == "Debian" ]]; then
    if (! hash ruby &>/dev/null || ! apt list --installed 2> /dev/null | grep -q 'ruby-dev') || ! hash gem &> /dev/null || ! hash rbenv &> /dev/null; then 
        eval "${pac_up}"
        eval "${pac_rm_y} ruby"       
        eval "${pac_ins_y} ruby-build ruby-dev rbenv"
    fi
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will create /var/lib/gems and set the ownership to $USER:$USER"
sudo mkdir /var/lib/gems
sudo chown -R $USER:$USER /var/lib/gems/

if test -f ~/.environment.env; then
    sed -i 's|.export GEM_HOME="$(ruby -e '\''puts Gem.user_dir'\'')"|export GEM_HOME="$(ruby -e '\''puts Gem.user_dir'\'')"|' ~/.environment.env 
    sed -i 's|.export PATH=$PATH:$GEM_HOME/bin|export PATH=$PATH:$GEM_HOME/bin|' ~/.environment.env 
else
    echo 'export GEM_HOME="$(ruby -e '\''puts Gem.user_dir'\'')"' >> ~/.bashrc
    echo 'export PATH=$PATH:$GEM_HOME/bin' >> ~/.bashrc
    echo 'export GEM_HOME="$(ruby -e '\''puts Gem.user_dir'\'')"' >> ~/.zshrc
    echo 'export PATH=$PATH:$GEM_HOME/bin' >> ~/.zshrc
fi

if test -f ~/.bashrc && ! grep -q 'eval "$(rbenv init -)' ~/.bashrc; then
    printf "eval \"\$(rbenv init -)\"\n" >>~/.bashrc
fi

if test -f ~/.zshrc && ! grep -q 'eval "$(rbenv init -' ~/.zshrc; then
    printf "eval \"\$(rbenv init - --no-rehash zsh)\"\n" >>~/.zshrc
fi

unset latest vers all


test -n "$BASH_VERSION" && source ~/.bashrc
test -n "$ZSH_VERSION" && source ~/.zshrc

printf "Ruby version: "
ruby --version

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

#rver=$(echo $(ruby --version) | awk '{print $2}' | cut -d. -f-2)'.0'
#paths=$(gem environment | awk '/- GEM PATH/{flag=1;next}/- GEM CONFIGURATION/{flag=0}flag' | sed 's|     - ||g' | paste -s -d ':')
#if grep -q "GEM" $ENV; then
#    sed -i "s|.export GEM_|export GEM_|g" $ENV
#    sed -i 's|.export PATH=$PATH:$GEM_PATH|export PATH=$PATH:$GEM_PATH|g' $ENV
#    sed -i "s|export GEM_HOME=.*|export GEM_HOME=$HOME/.gem/ruby/$rver|g" $ENV
#    sed -i "s|export GEM_PATH=.*|export GEM_PATH=$paths|g" $ENV
#    sed -i 's|export PATH=$PATH:$GEM_PATH.*|export PATH=$PATH:$GEM_PATH:$GEM_HOME/bin|g' $ENV
#else
#    printf "export GEM_HOME=$HOME/.gem/ruby/$rver\n" >> $ENV
#    printf "export GEM_PATH=$paths\n" >> $ENV
#    printf "export PATH=\$PATH:\$GEM_PATH:\$GEM_HOME/bin\n" >> $ENV
#fi

#
