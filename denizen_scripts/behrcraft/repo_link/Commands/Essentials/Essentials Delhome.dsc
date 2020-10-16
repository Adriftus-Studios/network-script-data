DelHome_Command:
    type: command
    name: delhome
    debug: false
    description: Deletes a specified name.
    permission: Behr.Essentials.Delhome
    usage: /delhome <&lt>HomeName<&gt>
    tab complete:
        - if <player.has_flag[Behr.Essentials.Homes]>:
            - define Args <player.flag[Behr.Essentials.Homes].parse[before[/]]>
            - inject OneArg_Command_Tabcomplete
    script:
    # % ██ [ Verify args ] ██
        - if <context.args.is_empty> || <context.args.size> > 1:
            - inject Command_Syntax

    # % ██ [ Check for existing homes ] ██
        - if !<player.has_flag[Behr.Essentials.Homes]>:
            - define Reason "You have no homes."
            - inject Command_Error

    # % ██ [ Re-Route Command ] ██
        - define Home <context.args.first>
        - execute as_player "home <[Home]> remove"
