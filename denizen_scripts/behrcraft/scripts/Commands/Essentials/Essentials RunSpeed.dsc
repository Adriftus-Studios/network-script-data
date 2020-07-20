# | ███████████████████████████████████████████████████████████
# % ██    /runspeed - Changes the speed you run at.
# | ██
# % ██  [ Command ] ██
runSpeed_Command:
    type: command
    name: runspeed
    debug: false
    description: Adjusts your run-speed up to Plaid-Speed (10). Default is (2).
    admindescription: Adjusts yours or another player's run-speed up to Plaid-Speed (10). Default is (2).
    usage: /runspeed #/Default
    adminusage: /runspeed (Player) #/Default
    aliases:
        - walkspeed
    permission: behrry.essentials.runspeed
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - if !<player.has_flag[behrry.essentials.tabofflinemode]>:
                - if <context.args.size||0> == 0:
                    - determine <server.list_online_players.parse[name].exclude[<player.name>]>
                - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                    - determine <server.list_online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
            - else:
                - if <context.args.size||0> == 0:
                    - determine <server.list_players.parse[name].exclude[<player.name>]>
                - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                    - determine <server.list_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.get[3]||null> != null:
            - inject Command_Syntax Instantly
        
    # @ ██ [  Check if specifying another User ] ██
        - if <context.args.get[2]||null> != null:
            - if <player.groups.contains[Moderation]>:
                - define User <context.args.get[1]>
                - inject Player_Verification Instantly
                - define Speed <context.args.get[2]>
            - else:
                - inject Command_Syntax Instantly
        - else:
        # @ ██ [  Set Player as Default ] ██
            - define User <player>
            - define Speed <context.args.get[1]>

    # @ ██ [  Check Speed Arg ] ██
        - if !<[Speed].is_integer>:
        # @ ██ [  Check if speed is a valid speed Style ] ██
            - if <list[Lightspeed|ludicrous|Plaid].contains[<[Speed]>]>:
                - if <[Speed]> == Default:
                    - define Speed 2
                - else:
                    - define Reason "Run speeds are numbers."
                    - inject Command_Error Instantly
            - else:
            # @ ██ [  Determine Speed by Name ] ██
                - choose <[Speed]>:
                    - case Lightspeed:
                        - adjust <[User]> walk_speed:0.5
                        - narrate targets:<[User]> "<proc[Colorize].context[Run Speed adjusted to:|green]> <&e>Lightspeed"
                    - case ludicrous:
                        - adjust <[User]> walk_speed:0.7
                        - narrate targets:<[User]> "<proc[Colorize].context[Run Speed adjusted to:|green]> <&e>Ludicrous"
                    - case Plaid:
                        - adjust <[User]> walk_speed:1.0
                        - narrate targets:<[User]> "<&c>G<&a>o<&c>i<&a>n<&c>g <&c>P<&a>l<&c>a<&a>d<&c>.<&a>.<&c>."
                - stop
    # @ ██ [  Speed Values ] ██
        - if <[Speed]> < 0 || <[Speed]> > 10:
            - define Reason "Run speeds range up to 10."
            - inject Command_Error Instantly
    
    # @ ██ [  Adjust Player ] ██
        - adjust <[User]> walk_speed:<[Speed].div[10]>
        - if <[Speed]> == 10:
            - narrate targets:<[User]> "<&c>G<&a>o<&c>i<&a>n<&c>g <&c>P<&a>l<&c>a<&a>d<&c>.<&a>.<&c>."
        - else:
            - narrate targets:<[User]> "<proc[Colorize].context[Run Speed adjusted to:|green]> <&e><[Speed]>"
        
        - if <context.args.get[2]||null> != null:
            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Run Speed set to:|green]> <&e><[Speed]>"
        