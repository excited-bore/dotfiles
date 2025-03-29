$USER=$env:USERNAME
$PATH=$env:Path


# PSDotFiles

$DotFilesPath = "C:\Users\$USER\dotfiles\powershell\"

# FZF

$env:FZF_DEFAULT_OPTS='--height=33% --layout=reverse-list --hscroll-off=50 --filepath-word --cycle --color=dark,fg:cyan'
$env:_PSFZF_FZF_DEFAULT_OPTS=$env:FZF_DEFAULT_OPTS
#$env:FZF_CTRL_T_COMMAND=$env:FZF_DEFAULT_OPTS
$env:FZF_ALT_C_OPTS=$env:FZF_DEFAULT_OPTS
