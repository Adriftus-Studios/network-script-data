MaxHealth_Command:
    type: command
    name: maxhealth
    debug: false
    description: Adjusts a player's max health up to 100.
    usage: /maxhealth <&lt>Player<&gt> <&lt>#<&gt>
    aliases:
        - maxhp
    permission: Behrry.Essentials.MaxHealth
    tab complete:
        - define Blacklist <server.list_online_players.filter[has_flag[Behrry.Moderation.Hide]].include[<Player>]>
        - inject Online_Player_Tabcomplete Instantly
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.get[3]||null> != null:
            - inject Command_Syntax Instantly
        
    # @ ██ [  Check if specifying another User ] ██
        - if <context.args.get[2]||null> != null:
            - define User <context.args.get[1]>
            - inject Player_Verification Instantly
            - define NewHealth <context.args.get[2]>
        - else:
        # @ ██ [  Default Self ] ██
            - define User <player>
            - define NewHealth <context.args.get[1]>

    # @ ██ [  Check Health Arg ] ██
        - if !<[NewHealth].is_integer>:
            - define Reason "Health is measured as a number."
            - inject Command_Error Instantly
        - if <[NewHealth]> < 1:
            - define Reason "Health cannot be negative or below 1."
            - inject Command_Error Instantly
        - if <[NewHealth].contains[.]>:
            - define Reason "Health cannot have a decimal."
            - inject Command_Error Instantly
        - if <[NewHealth]> > 100:
            - define Reason "Health can range up to 100."
            - inject Command_Error Instantly
    
    # @ ██ [  Adjust Health ] ██
        - adjust <[User]> max_health:<[NewHealth]>
        - narrate targets:<[User]> "<proc[Colorize].context[Maximum Health adjusted to:|green]> <&e><[NewHealth]>"
        - if <context.args.get[2]||null> != null:
            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Maximum Health set to:|green]> <&e><[NewHealth]>"
