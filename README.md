My Dotfiles
===========

Includes all kinds of installers and configurations. 
Currently only focused on bash on Linux

## Install.sh

Creates `.pathvariables.sh` for global pathvariables (Helps setting up variables for MAN,LESS,PAGER,EDITOR/VISUAL,SYSTEMD,XDG, etc..)  
Creates `~/.keybinds.d/` and for Bash (readline) keybindings    
Creates `~/.bash_aliases.d/` and `~/.bash_completion.d/` for bash-aliases and bash-completions respectively  

Then it helps with installing/configuring:  
    - Bash-completions: https://github.com/cykerway/complete-alias/master/complete_alias  
    - Python-completions: https://github.com/kislyuk/argcomplete  
    - Osc clipboard: https://github.com/theimpostor/osc   
    - Bat (Cat clone): https://github.com/sharkdp/bat  
    - Fzf: https://github.com/junegunn/fzf  
    - Autojump: https://github.com/wting/autojump  
    - Starship: https://starship.rs/  
    - Moar: https://github.com/walles/moar  
    - Ranger: https://github.com/ranger/ranger  
    - Neovim: https://neovim.io/  
    - Tmux: https://github.com/tmux/tmux  
    - Kitty: https://sw.kovidgoyal.net/kitty/  

Also helps configuring global gitconfig and global gitignore, and gives the option to install all kinds of bash-aliases/functions

## Install_git.sh
Script to automate setting up pagers, syntax highlighters, lazygit and copy-to. Works remotely with

```
eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_git.sh)"
```

## Install_gitignore.sh
Script to automate setting up local or global gitignore using templates from https://github.com/github/gitignore

## Install_go.sh
Script to automate installation of go, included for installation on distributions with less up-to-date go versions 

## Install_flatpak.sh
Installs flatpak with the added option to set flatpak-wrappers for commandline and install https://github.com/tchx84/Flatseal alongside

## Install_polkit_wheel.sh
Prevents password popups if user in wheel/sudo group

## Install_automount_usb.sh
Script to automate configuring automounting drives in /etc/fstab

## Install_samba.sh
Script to automate the installation of network drives using samba.

## Install_pipewire_switch_on_connect.sh
Setup to autoswitch to newest plugged in audiodevice.
