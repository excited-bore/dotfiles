wget 'https://github.com/walles/moar/releases/download/v1.11.4/moar-v1.11.4-linux-386'
chmod a+x moar-*-*-*
sudo mv moar-* /usr/local/bin/moar

printf "\nDon't forget to put: \n     export MOAR='--statusbar=bold -colors 256'\n     export PAGER=/usr/local/bin/moar\n       export SYSTEMD_PAGER=$PAGER\n in your ~/.bashrc\n"
