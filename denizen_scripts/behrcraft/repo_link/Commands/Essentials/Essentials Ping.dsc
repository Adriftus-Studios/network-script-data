Ping_Command:
    type: command
    name: ping
    debug: false
    description: shows yours, or another player's ping
    usage: /ping (player)
    permission: Behr.essentials.ping
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - define Blacklist <server.online_players.filter[has_flag[Behrry.Moderation.Hide]].include[<Player>]>
            - inject Online_Player_Tabcomplete
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax
        
    # % ██ [ Check if specifying another User ] ██
        - if <context.args.is_empty>:
            - narrate "<proc[Colorize].context[Current Ping:|green]> <&e><Player.ping>"
        - else:
            - define User <context.args.first>
            - inject Player_Verification
            - narrate "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Current Ping:|green]> <&e><[User].ping>"
