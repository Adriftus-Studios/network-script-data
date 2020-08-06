reloadscripts:
    type: command
    name: reloadscripts
    debug: false
    permission: behrry.development.reloadscripts
    aliases:
        - /r
    script:
        - execute as_server "ex reload"
