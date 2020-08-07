Back_Command:
    type: command
    name: back
    debug: false
    description: Returns you back to your last location.
    usage: /back
    permission: Behr.Essentials.Back
    script:
    # % ██ [ Check Args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax

    # - ██ [ Temporary Event Handle ] ██
        - if <player.has_flag[Event.InEvent]>:
            - narrate format:Colorize_Red "You cannot do that during an event."
            - stop

    # % ██ [ check if they have a back location ] ██
        - if !<player.has_flag[Behr.Essentials.Teleport.Back]>:
            - narrate format:Colorize_Red "No back location to return to"
            - stop

    # % ██ [  Teleport Player ] ██
        - define BackLoc <player.flag[Behr.Essentials.Teleport.Back].as_location>
        - narrate format:Colorize_Green "Returning to last location"
        - flag <player> Behr.Essentials.Teleport.Back:<player.location>
        - chunkload <[BackLoc].chunk>
        - if <[BackLoc].below.points_between[<[BackLoc].highest.above>].filter[material.is_solid.not].is_empty>:
            - teleport <player> <[BackLoc]>
        - else:
            - teleport <player> <[BackLoc].below.points_between[<[BackLoc].highest.above>].filter[material.is_solid.not].first>
