pip3 install argcomplete
activate-global-python-argcomplete --dest=$HOME/.bash_completion.d
#pip install shtab

if ! grep -q activate-global-python-argcomplete ~/.bashrc; then
    echo 'activate-global-python-argcomplete --dest=$HOME/.bash_completion.d' >> ~/.bashrc
fi
