# !/bin/bash
 (mkdir ~/.local/share/fonts && cd ~/.local/share/fonts && wget https://github.com/vorillaz/devicons/archive/master.zip && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hermit.zip && unzip master.zip Hermit.zip && rm -f master.zip Hermit.zip && sudo fc-cache -fv)
