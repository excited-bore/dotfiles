My Dotfiles
===========

Includes all kinds of installers and configurations. 
Currently only focused on **bash** on **Linux** (On a distro with APT or PACMAN)

## Install.sh

Creates `.pathvariables.sh` for global pathvariables (Helps setting up variables for MAN,LESS,PAGER,EDITOR/VISUAL,SYSTEMD,XDG, etc..)  
Creates `~/.keybinds.d/` and for Bash (readline) keybindings    
Creates `~/.bash_aliases` and `~/.bash_aliases.d/` for bash-aliases 
Creates `~/.bash_completion` and `~/.bash_completion.d/` for bash-completions  

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
        **Noteworthy plugins**:
        - Conquer of completion: https://github.com/neoclide/coc.nvim
        - NERDTree: https://github.com/preservim/nerdtree
        - NERDCommenter: https://github.com/preservim/nerdcommenter 
        - Vim-oscyank: https://github.com/ojroques/vim-oscyank
        - Vim-tmux-kitty-navigator: https://github.com/excited-bore/vim-tmux-kitty-navigator
        - Suda: https://github.com/lambdalisue/suda.vim
        - Which-key: https://github.com/folke/which-key.nvim
        - Toggleterm.nvim: https://github.com/akinsho/toggleterm.nvim 
        - Ranger.vim: https://github.com/francoiscabrol/ranger.vim
        - Lazygit.nvim: https://github.com/kdheepak/lazygit.nvim
        - Fzf.vim: https://github.com/junegunn/fzf.vim
        - Fzf-preview: https://github.com/junegunn/fzf-preview.vim
        - Vim-airline: https://github.com/vim-airline/vim-airline
    - Nvimpager: https://github.com/lucc/nvimpager
    - Tmux: https://github.com/tmux/tmux  
    - Kitty: https://sw.kovidgoyal.net/kitty/ 
    - Lazygit: https://github.com/jesseduffield/lazygit?tab=readme-ov-file#amend-an-old-commit
    - Diff syntax highlighters: 
      - Difftastic: https://difftastic.wilfred.me.uk/
      - Delta: https://github.com/delta-io/delta
      - Riff: https://github.com/walles/riff
      - Ydiff: https://github.com/ymattw/ydiff
      - Diff-so-fancy: https://github.com/so-fancy/diff-so-fancy

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
