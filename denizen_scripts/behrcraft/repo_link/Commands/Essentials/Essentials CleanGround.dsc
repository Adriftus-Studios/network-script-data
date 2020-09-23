groundclean_Command:
    type: command
    name: groundclean
    debug: false
    description: Cleans the ground of dropped items.
    usage: /groundclean
    permission: Behr.Essentials.GroundClean
    aliases:
        - cleanground
    script:
    # % ██ [ Check Args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax

    # % ██ [ Find Entnties ] ██
        - define Entities <player.location.find.entities[DROPPED_ITEM].within[128]>
        - remove <[Entities]>
        - narrate "<proc[Colorize].context[Removed:|green]><&e> <[Entities].size> entities"
