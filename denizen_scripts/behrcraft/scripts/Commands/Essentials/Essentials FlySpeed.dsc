FlySpeed_Command:
    type: command
    name: flyspeed
    debug: false
    description: Adjusts your fly-speed up to Plaid-Speed (10). Default is (1).
    admindescription: Adjusts yours or another player's fly-speed up to Plaid-Speed (10). Default is (1).
    usage: /flyspeed #/Default
    adminusage: /flyspeed (Player) #/Default
    aliases:
        - fs
    permission: Behrry.Essentials.Flyspeed
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - define Arg2 <list[Lightspeed|ludicrous|Plaid]>
            - if <context.args.size||0> == 0:
                - determine <server.list_players.parse[name].exclude[<player.name>]>
            - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <server.list_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
            - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <[Arg2].filter[starts_with[<context.args.get[2]>]]>
    script:
        - if <context.args.get[3]||null> != null || <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly
        - if <context.args.get[2]||null> != null:
            - if <player.groups.contains[Moderation]>:
                - define User <context.args.get[1]>
                - inject Player_Verification Instantly
                - define Speed <context.args.get[2]>
            - else:
                - inject Command_Syntax Instantly
        - else:
            - if <context.args.get[1]||null> == null:
                - inject Command_Syntax Instantly
            - define User <player>
            - define Speed <context.args.get[1]>

        - if !<[Speed].is_integer>:
            - if !<list[Lightspeed|ludicrous|Plaid|Default].contains[<[Speed]>]>:
                - if <[Speed]> == Default:
                    - define Speed 1
                - else:
                    - define Reason "Fly speeds are numbers."
                    - inject Command_Error Instantly
            - else:
                - choose <[Speed]>:
                    - case Lightspeed:
                        - adjust <[User]> fly_speed:0.5
                        - narrate targets:<[User]> "<proc[Colorize].context[Fly Speed adjusted to:|green]> <&e>Lightspeed"
                        - if <[User]> != <player>:
                            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Fly Speed set to:|green]> <&e>Lightspeed"
                    - case ludicrous:
                        - adjust <[User]> fly_speed:0.7
                        - narrate targets:<[User]> "<proc[Colorize].context[Fly Speed adjusted to:|green]> <&e>Ludicrous"
                        - if <[User]> != <player>:
                            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Fly Speed set to:|green]> <&e>Ludicrous"
                    - case Plaid:
                        - adjust <[User]> fly_speed:1.0
                        - narrate targets:<[User]> "<&c>G<&a>o<&c>i<&a>n<&c>g <&c>P<&a>l<&c>a<&a>d<&c>.<&a>.<&c>."
                        - if <[User]> != <player>:
                            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Fly Speed set to:|green]> <&c>P<&a>l<&c>a<&a>d<&c>!"
                    - case default:
                        - adjust <[User]> fly_speed:0.1
                        - narrate targets:<[User]> "<proc[Colorize].context[Fly Speed adjusted to:|green]> <&e>1"
                        - if <[User]> != <player>:
                            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Fly Speed set to:|green]> <&e>1"
                - stop
        - if <[Speed]> < 0 || <[Speed]> > 10:
            - define Reason "Fly speeds range up to 10."
            - inject Command_Error Instantly
    
        - adjust <[User]> fly_speed:<[Speed].div[10]>
        - if <[Speed]> == 10:
            - narrate targets:<[User]> "<&c>G<&a>o<&c>i<&a>n<&c>g <&c>P<&a>l<&c>a<&a>d<&c>.<&a>.<&c>."
        - else:
            - narrate targets:<[User]> "<proc[Colorize].context[Fly Speed adjusted to:|green]> <&e><[Speed]>"
        
        - if <context.args.get[2]||null> != null:
            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Fly Speed set to:|green]> <&e><[Speed]>"
        