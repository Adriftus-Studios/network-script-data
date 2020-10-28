drown_command:
    type: command
    name: Drown
    usage: /drown (player)
    description: Plays a drown animation
    permission: adriftus.staff
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
    - narrate "<&e>Drowning <[user].display_name><&c>... you monster."
    - repeat 3:
        - animate animation:HURT_DROWN <[user]>
        - wait 14t
