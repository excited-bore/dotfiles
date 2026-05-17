function ripgrep-dir {
    param(
        [string]$INITIAL_QUERY = ""  # default value of "" built into the parameter
    )

    $EDITOR = 'nvim'

    $RG_PREFIX = "rg --fixed-strings --follow --column --line-number --no-heading --color=always --smart-case --glob=!.git*"
    $DEFAULT_PROMPT = 'Dir> '

    if ($INITIAL_QUERY){
        $files = fzf `
                --ansi `
                --multi `
                --bind "start:reload:$RG_PREFIX {q}" `
                --bind "ctrl-t:transform:if not `"%FZF_PROMPT%`" == `"%DEFAULT_PROMPT%`" ( echo change-prompt($DEFAULT_PROMPT)+reload:$RG_PREFIX --no-ignore --hidden {q} ) ELSE ( echo change-prompt(Dir (-hidden) ^> )+reload:$RG_PREFIX {q} )" `
                --bind "change:transform:if not `"%FZF_PROMPT%`" == `"%DEFAULT_PROMPT%`" (echo reload:$RG_PREFIX {q}) else (echo reload:$RG_PREFIX --no-ignore --hidden {q})" `
                --delimiter ":" `
                --disabled `
                --height "80%" `
                --preview "bat --color=always {1} --highlight-line {2}" `
                --preview-window "up,60%,border-bottom,+{2}+3/3,~3" `
                --prompt "$DEFAULT_PROMPT" `
                --query "$INITIAL_QUERY"
     } else {
        $files = fzf `
                --ansi `
                --multi `
                --bind "start:reload:$RG_PREFIX {q}" `
                --bind "ctrl-t:transform:if not `"%FZF_PROMPT%`" == `"%DEFAULT_PROMPT%`" ( echo change-prompt($DEFAULT_PROMPT)+reload:$RG_PREFIX --no-ignore --hidden {q} ) ELSE ( echo change-prompt(Dir (-hidden) ^> )+reload:$RG_PREFIX {q} )" `
                --bind "change:transform:if not `"%FZF_PROMPT%`" == `"%DEFAULT_PROMPT%`" (echo reload:$RG_PREFIX {q}) else (echo reload:$RG_PREFIX --no-ignore --hidden {q})" `
                --delimiter ":" `
                --disabled `
                --height "80%" `
                --preview "bat --color=always {1} --highlight-line {2}" `
                --preview-window "up,60%,border-bottom,+{2}+3/3,~3" `
                --prompt "$DEFAULT_PROMPT"
     }

    if ($files) {
        $filesToOpen = $($files | ForEach-Object { ($_ -split ":")[0] })                                      & $EDITOR $filesToOpen
    }
}
