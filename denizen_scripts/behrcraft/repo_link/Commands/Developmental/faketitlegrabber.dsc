faketitlegrabber:
    type: command
    name: grabtitlelol
    description: wee
    usage: /grabtitlelol
    permission: fuckit
    tab complete:
        - define Args <yaml[titles].list_keys[titles]>
        - inject OneArg_Command_Tabcomplete
    script:
        - if <context.args.is_empty>:
            - inject Command_Syntax

        - else if !<yaml[titles].contains[titles.<context.args.first>]>:
            - inject command_Syntax
        - else:
            - run title_unlock def:<context.args.first>
