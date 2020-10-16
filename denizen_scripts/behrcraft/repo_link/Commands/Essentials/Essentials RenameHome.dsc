RenameHome_Command:
    type: command
    name: renamehome
    debug: false
    description: Renames a specified home.
    permission: Behr.essentials.renamehome
    aliases:
      - h
    usage: /home <&lt>HomeName<&gt> (NewHomeName)
    tab complete:
        - if <context.args.is_empty>:
          - determine <player.flag[Behr.Essentials.homes].parse[before[/]]||>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <player.flag[Behr.Essentials.homes].parse[before[/]].filter[starts_with[<context.args.first>]]||>
    script:
    # % ██ [ Verify args ] ██
        - if <context.args.get[3]||null> != null:
            - inject Command_Syntax

    # % ██ [ Open GUI without args ] ██
        - if <context.args.is_empty>:
            - run Home_GUI def:Rename
            - stop

    # % ██ [ Check for existing homes ] ██
        - if !<player.has_flag[Behr.Essentials.homes]>:
            - narrate "<proc[Colorize].context[You have no homes.|red]>"
            - stop

    # % ██ [ Check first home ] ██
        - define Name <context.args.first>
        - if !<player.flag[Behr.Essentials.homes].parse[before[/]].contains[<[Name]>]||null>:
            - narrate "<proc[Colorize].context[Home does not exist.|red]>"
            - stop

    # % ██ [ Check for new name ] ██
        - if <context.args.get[2]||null> != null:
            - define NewName <context.args.get[2]>

        # % ██ [ Check new home name ] ██
            - if <[Name]> == <[NewName]>:
                - narrate format:Colorize_Yellow "Nothing interesting happens."
                - stop
            - if <player.flag[Behr.Essentials.homes].parse[before[/]].contains[<[NewName]>]||null>:
                - narrate format:Colorize_Red "This home name already exists."
                - stop
            - if !<[NewName].matches[[a-zA-Z0-9-_]+]>:
                - narrate format:Colorize_Red "Home names should only be alphanumerical."
                - stop
            - if <[NewName]> == Remove:
                - narrate format:Colorize_Red "Invalid home name."
                - stop
        
        # % ██ [ Rename old to new ] ██
            - define Location <player.flag[Behr.Essentials.homes].map_get[<[Name]>].as_location>
            - flag player Behr.Essentials.homes:<-:<[Name]>/<[Location]>
            - flag player Behr.Essentials.homes:->:<[NewName]>/<[Location]>
            - narrate "<&2>H<&a>ome <proc[Colorize].context[[<[Name]>]|yellow]> <&2>R<&a>enamed<&2> <&2>t<&a>o<&2>: <proc[Colorize].context[[<[NewName]>]|yellow]>"
            - stop

    # % ██ [ Start chat listener ] ██
        - flag player Behr.Essentials.homerename:<[Name]>
        - narrate format:Colorize_green "Type a new Home Name."
        - while <player.is_online> && <player.has_flag[Behr.Essentials.homerename]>:
            - actionbar "<&2>Type a new Home Name<&a>. <&b>| <&7>'<&8>Cancel<&7>' <&8>to cancel."
            - wait 5s
