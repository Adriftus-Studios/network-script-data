Oxygen_Command:
    type: command
    name: Oxygen
    debug: false
    description: Hungers or satiates a player's oxygen.
    usage: /Oxygen (player) <&lt>#<&gt>
    permission: Behr.Essentials.Oxygen
    tab complete:
        - inject Online_Player_Tabcomplete
    script:
    # % ██ [ Check args ] ██
        - if <context.args.size> > 2:
            - inject Command_Syntax
            
    # % ██ [ Check if using self or named player ] ██
        - if <context.args.size> == 1:
            - define User <player>
            - define Level <context.args.first>
        - else:
            - define User <context.args.first>
            - inject Player_Verification
            - define Level <context.args.get[2]>
        
    # % ██ [ Verify number ] ██
        - if !<[Level].is_integer>:
            - narrate format:Colorize_Red "Oxygen must be a number."
            - stop
        - if <[Level]> > 20:
            - narrate format:Colorize_Red "Oxygen must be less than 20."
            - stop
        - if <[Level]> < 0:
            - narrate format:Colorize_Red "Oxygen must be between 0-20."
            - stop
        - if <[Level].contains[.]>:
            - narrate format:Colorize_Red "Oxygen cannot be a decimal."
            - stop

    # % ██ [ Check food adjustment direction & narrate ] ██
    # % ██ [ Refresh Oxygen ] ██
        - if <[User].food_level> > <[Level]>:
            - if <[User]> != <player>:
                - narrate "<proc[Display_Name_Simple].context[<[User]>]><proc[Colorize].context['s Oxygen level was refreshed.|green]>"
            - narrate targets:<[User]> format:Colorize_Green "Your Oxygen level was refreshed."

    # % ██ [ Did nothing / stayed the same ] ██
        - else if <[User].food_level> == <[Level]>:
            - narrate format:Colorize_yellow "Nothing interesting happens."
            - stop

    # % ██ [ Deplete Oxygen ] ██
        - else if <[User].food_level> < <[Level]>:
            - if <[User]> != <player>:
                - narrate "<proc[Display_Name_Simple].context[<[User]>]><proc[Colorize].context['s Oxygen level was depleted.|green]>"
            - narrate targets:<[User]> format:Colorize_Red "Your Oxygen level depletes."
        - adjust <[User]> food_level:<[Level]>
