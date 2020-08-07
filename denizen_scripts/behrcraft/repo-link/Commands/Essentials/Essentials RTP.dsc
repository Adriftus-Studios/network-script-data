RTP_Command:
    type: command
    name: rtp
    debug: false
    description: Randomly teleports you
    usage: /rtp
    permission: Behr.Essentials.Rtp
    script:
    # % ██ [ Check for args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax

    # - ██ [ Temporary Event Handle ] ██
        - if <player.has_flag[Event.InEvent]>:
            - narrate format:Colorize_Red "You cannot do that during an event."
            - stop

    # % ██ [ Define integers ] ██
        - define distance 6000

    # % ██ [ Check world ] ██
        - if <player.world.name> != World:
            - narrate "<proc[Colorize].context[This cannot be done in this world.|red]>"
            - stop
        
    # % ██ [ Check for cooldown ] ██
        - if <player.has_flag[Behr.Essentials.rtpcooldown]>:
            - narrate "<proc[Colorize].context[You must wait:|red]> <player.flag[Behr.Essentials.rtpcooldown].expiration.formatted>> <proc[Colorize].context[to RTP again.|red]>"
            - stop
            
        - flag player Behr.Essentials.rtpcooldown duration:1m
        - cast levitation power:30 duration:1s
        - wait .8s
    # % ██ [ Define bad areas ] ██
    #^  - define Blacklist <list[Lava|Water|Leaves|ice]>
    #^  - repeat 100:
        - define x <util.random.int[-<[Distance]>].to[<[Distance]>]>
        - define z <util.random.int[-<[Distance]>].to[<[Distance]>]>
        - chunkload <location[<[x]>,0,<[z]>,<player.world.name>].chunk> duration:1t
        - define Loc <location[<[x]>,0,<[z]>,<player.world.name>].highest>
    #^      - if <[Loc].material.name.contains_any[<[Blacklist]>]>:
    #^          #- narrate "Bad RTP, retrying... <[Loc].material.name>"
    #^          - repeat next
    #^      - else:
        - narrate "<proc[Colorize].context[Teleporting you randomly!|Green]>"
        - flag player Behr.Essentials.teleport.back:<player.location>
        - teleport <player> <[Loc].add[0,50,0].with_pitch[90]>
        - cast SLOW_FALLING duration:20s power:1
    #^          - repeat stop
