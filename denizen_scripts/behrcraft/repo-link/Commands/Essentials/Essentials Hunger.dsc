Hunger_Command:
    type: command
    name: hunger
    debug: false
    description: Hungers or satiates a player's hunger.
    usage: /hunger (player) <&lt>#<&gt>
    permission: Behrry.Essentials.Hunger
    tab complete:
        - inject Online_Player_Tabcomplete Instantly
    script:
    # @ ██ [  Check args ] ██
        - if <context.args.size> > 2:
            - inject Command_Syntax Instantly
            
    # @ ██ [  Check if using self or named player ] ██
        - if <context.args.size> == 1:
            - define User <player>
            - define Level <context.args.get[1]>
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification
            - define Level <context.args.get[2]>
        
    # @ ██ [  Verify number ] ██
        - if !<[Level].is_integer>:
            - narrate format:Colorize_Red "Hunger must be a number."
            - stop
        - if <[Level]> > 20:
            - narrate format:Colorize_Red "Hunger must be less than 20."
            - stop
        - if <[Level]> < 0:
            - narrate format:Colorize_Red "Hunger must be between 0-20."
            - stop
        - if <[Level].contains[.]>:
            - narrate format:Colorize_Red "Hunger cannot be a decimal."
            - stop

    # @ ██ [  Check food adjustment direction & narrate ] ██
    # @ ██ [  Satiated hunger ] ██
        - if <[User].food_level> > <[Level]>:
            - if <[User]> != <player>:
                - narrate "<proc[Display_Name_Simple].context[<[User]>]><proc[Colorize].context['s hunger was satiated.|green]>"
            - narrate targets:<[User]> format:Colorize_Green "Your hunger was satiated."

    # @ ██ [  Did nothing / stayed the same ] ██
        - else if <[User].food_level> == <[Level]>:
            - narrate format:Colorize_yellow "Nothing interesting happens."
            - stop
            
    # @ ██ [  Player was starved ] ██
        - else if <[User].food_level> < <[Level]>:
            - if <[User]> != <player>:
                - narrate "<proc[Display_Name_Simple].context[<[User]>]><proc[Colorize].context['s hunger was increased.|green]>"
            - narrate targets:<[User]> format:Colorize_Red "Your hunger intensifies."
        - adjust <[User]> food_level:<[Level]>
