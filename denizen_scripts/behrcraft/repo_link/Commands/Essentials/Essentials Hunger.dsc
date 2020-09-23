Hunger_Command:
    type: command
    name: hunger
    debug: false
    description: Hungers or satiates a player's hunger.
    usage: /hunger (player) <&lt>#<&gt>
    permission: Behr.Essentials.Hunger
    tab complete:
        - define Blacklist <list[<player>]>
        - inject Online_Player_Tabcomplete
    script:
    # % ██ [  Check args ] ██
        - if <context.args.is_empty> || <context.args.size> > 2:
            - inject Command_Syntax

    # % ██ [  Check if using self or named player ] ██
        - if <context.args.size> == 1:
            - define User <player>
            - define Level <context.args.first>
        - else:
            - define User <context.args.first>
            - inject Player_Verification
            - define Level <context.args.get[2]>

    # % ██ [  Verify number ] ██
        - if !<[Level].is_integer>:
            - Define Reason "Hunger must be a number."
            - inject Command_Error

        - if <[Level]> > 20:
            - Define Reason "Hunger must be less than 20."
            - inject Command_Error

        - if <[Level]> < 0:
            - Define Reason "Hunger must be between 0-20."
            - inject Command_Error

        - if <[Level].contains_text[.]>:
            - Define Reason "Hunger cannot be a decimal."
            - inject Command_Error

    # % ██ [  Check food adjustment direction & narrate ] ██
    # % ██ [  Satiated hunger ] ██
        - if <[User].food_level> > <[Level]>:
            - if <[User]> != <player>:
                - narrate "<proc[Display_Name_Simple].context[<[User]>]><proc[Colorize].context['s hunger was satiated.|green]>"
            - narrate targets:<[User]> format:Colorize_Green "Your hunger was satiated."

    # % ██ [  Did nothing / stayed the same ] ██
        - else if <[User].food_level> == <[Level]>:
            - narrate format:Colorize_yellow "Nothing interesting happens."
            - stop

    # % ██ [  Player was starved ] ██
        - else if <[User].food_level> < <[Level]>:
            - if <[User]> != <player>:
                - narrate "<proc[Display_Name_Simple].context[<[User]>]><proc[Colorize].context['s hunger was increased.|green]>"
            - narrate targets:<[User]> format:Colorize_Red "Your hunger intensifies."

    # % ██ [  Adjust hunger ] ██
        - adjust <[User]> food_level:<[Level]>
