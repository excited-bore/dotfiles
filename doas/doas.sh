# For Tabcompletion 
complete -cf doas

# A trailing space in VALUE causes the next word to be checked for alias substitution when the alias is expanded.
alias doas="doas "

# Doas bc less > more
#alias sudo="doas -n "
function doasedit() { doas $EDITOR $1; }
alias sudoedit='doasedit '

# Check doas.conf works or not
alias check_conf_doas="doas doas -C /etc/doas.conf && echo 'config ok' || echo 'config error'"

alias edit_doas_conf="doasedit /etc/doas.conf && check_conf_doas"
# Or, alternatively
# Preserve env
#alias sudo="sudo -E"

