alias _="stty -echo && tput cuu1 && history -d -1"
#alias prv="{ echo \"${PS1@P}\" & fc -l -1 0; } | awk '(NR%2==1?\$1=\"\":\$1=\$1){print\$0p}{p=\$0}'"
