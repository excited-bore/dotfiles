# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#using-fzf-as-interactive-ripgrep-launcher

# 1. Search for text in files using Ripgrep
# 2. Interactively restart Ripgrep with reload action
# 3. Open the file in Vim

ripgrep-dir(){
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case"
    RG_PREFIX_HIDDEN="rg --column --line-number --hidden --no-heading --color=always --smart-case"
    RG=$RG_PREFIX
    INITIAL_QUERY="${*:-}"
    : | fzf --height 80% --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG {q}" \
        --bind "ctrl-t:transform:[[ $RG =~ 'hidden' ]] && 
        echo \"unbind(change)+RG=$RG_PREFIX+rebind(change)\" ||
        echo \"unbind(change)+RG=$RG_PREFIX_HIDDEN+rebind(change)\"" \
        --bind "change:reload:sleep 0.1; $RG {q} || true" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind "enter:become($EDITOR {1} +{2})"
}
