deathback_Command:
    type: command
    name: deathback
    debug: false
    description: Returns you back your death location.
    permission: Behr.Essentials.DBack
    usage: /deathback
    aliases:
        - dback
    script:
    # % ██ [ Check Args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax

    # % ██ [ Check if player has death-back ] ██
        - if !<player.has_flag[Behr.Essentials.Teleport.DeathBack]>:
            - narrate format:Colorize_Red "No death location to return to."
            - stop
        
    # % ██ [ Teleport Player ] ██
        - narrate format:Colorize_Green "Returning to death location."
        - define BackLoc <player.flag[Behr.Essentials.Teleport.DeathBack].as_location>
        - flag <player> Behr.Essentials.Teleport.DeathBack:<player.location>
        - chunkload <[BackLoc].chunk>
        - if <[BackLoc].below.points_between[<[BackLoc].highest.above>].filter[material.is_solid.not].is_empty>:
            - teleport <player> <[BackLoc]>
        - else:
            - teleport <player> <[BackLoc].below.points_between[<[BackLoc].highest.above>].filter[material.is_solid.not].first>
