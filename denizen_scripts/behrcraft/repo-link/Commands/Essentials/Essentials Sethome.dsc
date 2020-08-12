SetHome_Command:
    type: command
    name: sethome
    debug: false
    description: Sets a home location.
    aliases:
        - seth
    usage: /sethome <&lt>HomeName<&gt>
    permission: Behr.Essentials.Sethome
    tab complete:
        - if <player.has_flag[Behr.Essentials.homes]>:
            - if <context.raw_args.contains_any[<player.flag[Behr.Essentials.homes].parse[before[/]]>]>:
                - determine "<proc[Colorize].context[This Home Exists Already!|red]>"
    script:
    # % ██ [ Verify args ] ██
        - if <context.args.is_empty>:
            - inject Command_Syntax

    # % ██ [ Define name/loc ] ██
        - define Name <context.args.first>
        - define Location <player.location.simple.as_location.add[0.5,0,0.5].with_yaw[<player.location.yaw>].with_pitch[<player.location.pitch>]>

    # % ██ [ Check args ] ██
        - if !<[Name].matches[[a-zA-Z0-9-_]+]>:
            - narrate format:Colorize_Red "Home names should only be alphanumerical."
            - stop

        - if <player.flag[Behr.Essentials.homes].parse[before[/]].contains[<[Name]>]||null>:
            - narrate "<proc[Colorize].context[This home name already exists.|red]>"
            - stop

        - if <[Name]> == Remove:
            - narrate format:Colorize_Red "Invalid home name."
            - stop

    # % ██ [ Set Home ] ██
        - flag <player> Behr.Essentials.homes:->:<[Name]>/<[Location]>
        - narrate "<proc[Colorize].context[New home set:|green]> <&6>[<&e><[Name]><&6>]"
