. ./checks/check_system.sh
if [ "$distro" == "Manjaro" ]; then
    yes | pamac install python xorg-xrandr xorg-xwininfo wmctrl xdotool
fi

(
cd /tmp
git clone https://github.com/calandoa/movescreen
sudo mv movescreen/movescreen.py /usr/local/bin/
sudo chmod a+rx /usr/local/bin/movescreen.py
)
echo  'Go to Setting -> Keyboard -> Application shortcuts then add one shortcut for each direction:'
echo '/usr/local/bin/movescreen.py left 	Ctrl+Super+Left'
echo '/usr/local/bin/movescreen.py right 	Ctrl+Super+Right'
echo '/usr/local/bin/movescreen.py fit 	        Ctrl+Super+Space'
