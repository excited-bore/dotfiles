# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#using-fzf-as-interactive-ripgrep-launcher

# https://github.com/junegunn/fzf/issues/3998

# 1. Search for text in files using Ripgrep
# 2. Interactively restart Ripgrep with reload action
# 3. Change to include hidden files with ctrl-t
# 4. Select and open the file in EDITOR

#--bind "enter:become(echo {} +{2})" \
ripgrep-dir() {
    test -z $EDITOR && 
        (command -v nano && export EDITOR=/usr/bin/nano || export EDITOR=/usr/bin/vi) 
    RG_PREFIX="rg --fixed-strings --follow --column --line-number --no-heading --color=always --smart-case --glob='!.git*'" 
    INITIAL_QUERY="${*:-}"
    DEFAULT_PROMPT="Dir (hidden) > "
    local files="$(fzf \
    --ansi \
    --multi \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "ctrl-t:transform:[[  \$FZF_PROMPT != \"$DEFAULT_PROMPT\"  ]] &&
    echo \"change-prompt($DEFAULT_PROMPT)+reload:$RG_PREFIX --no-ignore --hidden \{q} || true\" ||
    echo \"change-prompt(Dir > )+reload:$RG_PREFIX \{q} || true\"" \
    --bind "change:transform:[[ \$FZF_PROMPT == \"$DEFAULT_PROMPT\"  ]] &&
    echo \"reload:sleep 0.1; $RG_PREFIX \{q} || true\" ||
    echo \"reload:sleep 0.1; $RG_PREFIX --no-ignore --hidden \{q} || true\"" \
    --delimiter : \
    --disabled \
    --height 80% \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --prompt "$DEFAULT_PROMPT" \
    --query "$INITIAL_QUERY")"
    test -n "$files" && 
        $EDITOR $(echo "$files" | cut -d: -f-1)   
}
