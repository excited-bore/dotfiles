
if [ ! -d ~/Applications ]; then
    mkdir ~/Applications
fi
(
cd ~/Applications
wget https://golang.google.cn/dl/go1.20.1.linux-armv6l.tar.gz
sudo tar -C /usr/local -xzf go1.20.1.linux-armv6l.tar.gz
rm go1.14.4.linux-arm64.tar.gz

