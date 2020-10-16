Fly_Command:
    type: command
    name: fly
    debug: false
    description: Grants Flight
    usage: /fly (player) (on/off)
    permission: Behr.Essentials.Fly
    tab complete:
        - if <player.in_group[Moderation]>:
            - define Blacklist <list[<player>]>
            - inject Online_Player_Tabcomplete
    script:
        - if <context.args.is_empty>:
            - define User <player>
            - define Toggle <player.can_fly.not>

        - else if <context.args.size> == 1:
            - if <list[On|Off|True|False].contains[<context.args.first>]>:
                - define Toggle <context.args.first>
                - define User <player>
            - else:
                - define User <context.args.first>
                - inject Player_Verification
                - define Toggle <[User].can_fly.not>

        - else if <context.args.size> == 2:
            - if <list[On|Off|True|False].contains[<context.args.first>]>:
                - define User <context.args.get[2]>
            - else if <list[On|Off|True|False].contains[<context.args.get[2]>]>:
                - define User <context.args.first>
            - else:
                - define User <context.args.first>
            - inject Player_Verification
            - define Toggle <[User].can_fly.not>
            
        - else:
            - inject Command_Syntax

        - if <[Toggle]> == On:
            - define Toggle True
        - else if <[Toggle]> == Off:
            - define Toggle False

        - if <[User].can_fly>:
            - if <[Toggle]>:
                - if <[User]> != <player>:
                    - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Flight mode:|green]> <&e>Disabled"
                - narrate targets:<[User]> "<proc[Colorize].context[Flight mode:|green]> <&e>Disabled"
                - adjust <[User]> can_fly:false
            - else:
                - if <[User]> != <player>:
                    - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Flight mode is already on.|yellow]>"
                - else:
                    - narrate targets:<[User]> "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
        - else:
            - if <[Toggle]>:
                - if <[User]> != <player>:
                    - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Flight mode:|green]> <&e>Enabled"
                - narrate targets:<[User]> "<proc[Colorize].context[Flight mode:|green]> <&e>Enabled"
                - adjust <[User]> can_fly:true
            - else:
                - if <[User]> != <player>:
                    - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Flight mode is not on.|yellow]>"
                - else:
                    - narrate targets:<[User]> "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
