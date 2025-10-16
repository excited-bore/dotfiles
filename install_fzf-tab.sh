hash git &> /dev/null && SYSTEM_UPDATED="TRUE"

if ! [ -f checks/check_all.sh ]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if ! test -f checks/check_completions_dir.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi

if ! hash git &> /dev/null; then
    echo "${CYAN}git${normal} not installed. Installing..." 
    eval "$pac_ins_y git" 
fi

git clone https://github.com/Aloxaf/fzf-tab ~/.zsh_completion.d/fzf-tab
mv ~/.zsh_completion.d/fzf-tab/fzf-tab.plugin.zsh ~/.zsh_completion.d
sed -i 's|source "${0:A:h}/fzf-tab.zsh"|source "${0:A:h}/fzf-tab/fzf-tab.zsh"|g' ~/.zsh_completion.d/fzf-tab.plugin.zsh
