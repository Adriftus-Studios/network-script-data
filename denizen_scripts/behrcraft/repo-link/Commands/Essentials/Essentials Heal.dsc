Heal_Command:
    type: command
    name: heal
    debug: false
    description: Heals a player
    usage: /heal (player)
    permission: Behr.Essentials.Heal
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - define Blacklist <player>
            - inject Online_Player_Tabcomplete
    script:
    # % ██ [  Verify args ] ██
        - if <context.args.is_empty>:
            - define User <player>
        - else if <context.args.size> == 1:
            - define User <context.args.first>
            - inject Player_Verification
        - else:
            - inject Command_Syntax

    # % ██ [  Heal Player ] ██
        - heal <[User]>
        - adjust <[User]> food_level:20
        - if <[User]> != <player>:
            - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[was healed.|green]>"
        - narrate targets:<[User]> format:Colorize_Green "You were healed."
