# https://github.com/Aloxaf/fzf-tab

hash git &> /dev/null && SYSTEM_UPDATED="TRUE"

TOP=$(git rev-parse --show-toplevel)

if ! [ -f $TOP/checks/check_all.sh ]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! test -f $TOP/checks/check_completions_dir.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)
else
    . $TOP/checks/check_envvar_aliases_completions_keybinds.sh
fi

if ! hash git &> /dev/null; then
    echo "${CYAN}git${normal} not installed. Installing..." 
    eval "$pac_ins_y git" 
fi

if ! test -f ~/.zsh_completion.d/fzf-tab.plugin.zsh; then
    git clone https://github.com/Aloxaf/fzf-tab ~/.zsh_completion.d/fzf-tab
    mv ~/.zsh_completion.d/fzf-tab/fzf-tab.plugin.zsh ~/.zsh_completion.d
    sed -i 's|source "${0:A:h}/fzf-tab.zsh"|source "${0:A:h}/fzf-tab/fzf-tab.zsh"|g' ~/.zsh_completion.d/fzf-tab.plugin.zsh
fi
