groundclean_Command:
    type: command
    name: groundclean
    debug: false
    description: Cleans the ground of dropped items.
    usage: /groundclean
    permission: Behrry.Essentials.GroundClean
    aliases:
        - cleanground
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly

    # @ ██ [  Find Entnties ] ██
        - define Entities <player.location.find.entities[DROPPED_ITEM].within[250]>
        - remove <[Entities]>
        - narrate "<proc[Colorize].context[Removed:|green]><&e> <[Entities].size> entities"