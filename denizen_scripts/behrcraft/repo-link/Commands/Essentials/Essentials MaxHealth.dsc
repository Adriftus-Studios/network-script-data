MaxHealth_Command:
    type: command
    name: maxhealth
    debug: false
    description: Adjusts a player's max health up to 100.
    usage: /maxhealth <&lt>Player<&gt> <&lt>#<&gt>
    aliases:
        - maxhp
    permission: Behr.Essentials.MaxHealth
    tab complete:
        - define Blacklist <server.online_players.filter[has_flag[Behrry.Moderation.Hide]].include[<Player>]>
        - inject Online_Player_Tabcomplete
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.is_empty> || <context.args.size> > 2:
            - inject Command_Syntax
        
        # % ██ [ Default Self ] ██
        - if <context.args.size> == 1:
            - define User <player>
            - define NewHealth <context.args.first>
    # % ██ [ Check if specifying another User ] ██
        - else:
            - define User <context.args.first>
            - inject Player_Verification
            - define NewHealth <context.args.get[2]>

    # % ██ [ Check Health Arg ] ██
        - if !<[NewHealth].is_integer>:
            - define Reason "Health is measured as a number."
            - inject Command_Error

        - if <[NewHealth]> < 1:
            - define Reason "Health cannot be negative or below 1."
            - inject Command_Error

        - if <[NewHealth].contains[.]>:
            - define Reason "Health cannot have a decimal."
            - inject Command_Error

        - if <[NewHealth]> > 100:
            - define Reason "Health can range up to 100."
            - inject Command_Error

    
    # % ██ [ Adjust Health ] ██
        - adjust <[User]> max_health:<[NewHealth]>
        - narrate targets:<[User]> "<proc[Colorize].context[Maximum Health adjusted to:|green]> <&e><[NewHealth]>"
        - if <context.args.get[2]||null> != null:
            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Maximum Health set to:|green]> <&e><[NewHealth]>"
