rtp_command:
    type: command
    name: rtp
    debug: false
    description: randomly teleports you
    usage: /rtp
    permission: behr.essentials.rtp
    script:
    # % ██ [ check for args ] ██
        - if !<context.args.is_empty>:
            - inject command_syntax

    # % ██ [ define integers ] ██
        - define distance 6000

    # % ██ [ check world ] ██
        - if <player.world.name> != world:
            - narrate format:colorize_red "this cannot be done in this world."
            - stop
        
    # % ██ [ check for cooldown ] ██
        - if <player.has_flag[behr.essentials.rtpcooldown]>:
            - narrate "<proc[colorize].context[you must wait:|red]> <&6><player.flag[behr.essentials.rtpcooldown].expiration.formatted> <proc[colorize].context[to rtp again.|red]>"
            - stop
            
        - flag player behr.essentials.rtpcooldown duration:1m
        - cast levitation power:30 duration:1s
        - wait .8s
    # % ██ [ define bad areas ] ██
    #^  - define blacklist <list[lava|water|leaves|ice]>
    #^  - repeat 100:
        - define x <util.random.int[-<[distance]>].to[<[distance]>]>
        - define z <util.random.int[-<[distance]>].to[<[distance]>]>
        - chunkload <location[<[x]>,0,<[z]>,<player.world.name>].chunk> duration:1t
        - define loc <location[<[x]>,0,<[z]>,<player.world.name>].highest>
    #^      - if <[loc].material.name.contains_any[<[blacklist]>]>:
    #^          #- narrate "bad rtp, retrying... <[loc].material.name>"
    #^          - repeat next
    #^      - else:
        - narrate "<proc[colorize].context[teleporting you randomly!|green]>"
        - flag player behr.essentials.teleport.back:<map.with[location].as[<player.location>].with[world].as[<player.world.name>]>
        - teleport <player> <[loc].with_y[300].with_pitch[90]>
        - cast slow_falling duration:20s power:1
    #^          - repeat stop
