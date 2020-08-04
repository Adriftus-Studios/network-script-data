RunSpeed_Command:
    type: command
    name: runspeed
    debug: false
    description: Adjusts your run-speed up to Plaid-Speed (10). Default is (2).
    admindescription: Adjusts yours or another player's run-speed up to Plaid-Speed (10). Default is (2).
    usage: /runspeed #/Default
    adminusage: /runspeed (Player) #/Default
    aliases:
        - fs
    permission: Behr.Essentials.RunSpeed
    tab complete:
        - if <player.groups.in_group[Moderation]>:
            - define Arg2 <list[Lightspeed|ludicrous|Plaid]>
            - if <context.args.size||0> == 0:
                - determine <server.players.parse[name].exclude[<player.name>]>
            - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <server.players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.first>]]>
            - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <[Arg2].filter[starts_with[<context.args.get[2]>]]>
    script:
        - if <context.args.is_empty>:
            - inject Command_Syntax
        - else if <context.args.size> > 2:
            - inject Command_Syntax

        - if <context.args.size> == 2:
            - if <player.groups.contains[Moderation]>:
                - define User <context.args.first>
                - inject Player_Verification
                - define Speed <context.args.get[2]>
            - else:
                - inject Command_Syntax

        - else:
            - define User <player>
            - define Speed <context.args.first>

        - if !<[Speed].is_integer>:
            - choose <[Speed]>:
                - case Lightspeed:
                    - adjust <[User]> walk_speed:0.5
                    - narrate targets:<[User]> "<proc[Colorize].context[Run Speed adjusted to:|green]> <&e>Lightspeed"
                    - if <[User]> != <player>:
                        - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Run Speed set to:|green]> <&e>Lightspeed"
                - case ludicrous:
                    - adjust <[User]> walk_speed:0.7
                    - narrate targets:<[User]> "<proc[Colorize].context[Run Speed adjusted to:|green]> <&e>Ludicrous"
                    - if <[User]> != <player>:
                        - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Run Speed set to:|green]> <&e>Ludicrous"
                - case Plaid:
                    - adjust <[User]> walk_speed:1.0
                    - narrate targets:<[User]> "<element[Going Plaid!].rainbow[ca]>"
                    - if <[User]> != <player>:
                        - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Run Speed set to:|green]> <&c>P<&a>l<&c>a<&a>d<&c>!"
                - case default:
                    - adjust <[User]> walk_speed:0.2
                    - narrate targets:<[User]> "<proc[Colorize].context[Run Speed adjusted to:|green]> <&e>1"
                    - if <[User]> != <player>:
                        - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Run Speed set to:|green]> <&e>1"
                - default:
                    - define Reason "Run speeds are numbers."
                    - inject Command_Error
            - stop

        - if <[Speed]> < 0:
            - define Reason "Run speeds cannot be negative."
            - inject Command_Error

        - if <[Speed]> > 10:
            - define Reason "Run speeds range up to 10."
            - inject Command_Error

        - adjust <[User]> walk_speed:<[Speed].div[10]>
        - if <[Speed]> == 10:
            - narrate targets:<[User]> "<element[Going Plaid!].rainbow[ca]>"
        - else:
            - narrate targets:<[User]> "<proc[Colorize].context[Run Speed adjusted to:|green]> <&e><[Speed]>"

        - if <[User]> != <player>:
            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Run Speed set to:|green]> <&e><[Speed]>"
