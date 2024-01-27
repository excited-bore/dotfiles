
if [ ! -d ~/.bash_aliases.d/ ]; then
    mkdir ~/.bash_aliases.d/
fi

if ! grep -q "~/.bash_aliases.d" ~/.bashrc; then

    echo "if [[ -d ~/.bash_aliases.d/ ]]; then" >> ~/.bashrc
    echo "  for alias in ~/.bash_aliases.d/*.sh; do" >> ~/.bashrc
    echo "      . \"\$alias\" " >> ~/.bashrc
    echo "  done" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi

cp -bfv checks/check_distro.sh ~/.bash_aliases.d/check_distro.sh
cp -bfv readline/rlwrap_scripts.sh ~/.bash_aliases.d/rlwrap_scripts.sh
gio trash ~/.bash_aliases.d/check_distro.sh~ ~/.bash_aliases.d/rlwrap_scripts.sh~


if ! sudo test -d /root/.bash_aliases.d/ ; then
    sudo mkdir /root/.bash_aliases.d/
fi

if ! sudo grep -q "~/.bash_aliases.d" /root/.bashrc; then
    printf "\nif [[ -d ~/.bash_aliases.d/ ]]; then\n  for alias in ~/.bash_aliases.d/*.sh; do\n      . \"\$alias\" \n  done\nfi" | sudo tee -a /root/.bashrc > /dev/null
fi

sudo cp -fvb checks/check_distro.sh /root/.bash_aliases.d/check_distro.sh
sudo cp -fvb readline/rlwrap_scripts.sh /root/.bash_aliases.d/rlwrap_scripts.sh 
sudo gio trash /root/.bash_aliases.d/check_distro.sh~ /root/.bash_aliases.d/rlwrap_scripts.sh~
