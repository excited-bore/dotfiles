### VIM ###
alias nvim="nvim -u ~/.config/nvim/init.vim"
alias vim="nvim -u ~/.config/nvim/init.vim" 
alias svim="sudo nvim"
#alias snvim="sudo nvim"
function rvim(){ nvr --remote $@; }
alias vim_noconf="nvim -Nu NONE"
alias vim_check_health="nvim +checkhealth"
alias vim_plugin_install="nvim +PluginInstall +qall"
