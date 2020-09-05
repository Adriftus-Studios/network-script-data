drown_command:
    type: command
    name: Drown
    usage: /drown (player)
    description: Plays a drown animation
    permission: adriftus.staff
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - define Blacklist <[<player>]>
            - inject Online_Player_Tabcomplete
    script:
    # % ██ [  Verify argumentss ] ██
    - if <context.args.is_empty>:
        - define User <player>
    - else if <context.args.size> == 1:
        - define User <context.args.first>
        - inject Player_Verification
    - else:
        - inject Command_Syntax

    # % ██ [  Drown Player ] ██
    - narrate Drowning <[user].display_name>
    - repeat 3:
        - animate animation:HURT_DROWN <[user]>
        - wait 14t
