heal_command:
    type: command
    name: heal
    usage: /heal (player)
    description: Heals a player
    permission: adriftus.staff
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - define Blacklist <[<player>]>
            - inject Online_Player_Tabcomplete
    script:
    # % ██ [  Verify arguments ] ██
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
            - narrate "<[user].display_name><&e> has been healed."
            - narrate "<player.display_name><&e> has healed you" targets:<[user]>
        - else:
            - narrate targets:<[User]>  "<&e>You have been healed."
