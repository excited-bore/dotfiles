### VIM ###
# Use vimtutor for a tutorial
alias vim="nvim -u ~/.config/nvim/init.vim" 
alias svim="sudo nvim"
function rvim(){ nvr --remote $@; }
alias vim_magic="vim +\"help magic\""
alias vim_noconf="nvim -Nu NONE"
alias vim_check_health="nvim +checkhealth"
alias vim_plugin_install="nvim +PluginInstall +qall"
alias vim_plugin_update="nvim +PluginUpdate +qall"

