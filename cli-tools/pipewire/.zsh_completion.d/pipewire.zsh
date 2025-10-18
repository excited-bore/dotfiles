if hash pw-cli &> /dev/null; then

    _pw_cli_complete() {
      local -a cmds
      cmds=(
        help h
        load-module lm
        unload-module um
        connect con
        disconnect dis
        list-remotes lr
        switch-remotes sr
        list-objects ls
        info i
        create-device cd
        create-node cn
        destroy d
        create-link cl
        export-node en
        enum-params e
        set-param s
        permissions sp
        get-permissions gp
        send-command c
        quit q
      )
      compadd "$@" $cmds
    }
    
    compdef _pw_cli_complete pw-cli
fi

if hash wpctl &> /dev/null; then
    compdef '_wpctl_complete() { compadd status get-volume inspect set-default set-volume set-mute set-profile set-route clear-default settings set-log-level -h --help }' wpctl
fi
