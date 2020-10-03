Back_Command:
    type: command
    name: back
    debug: false
    description: Returns you back to your last location.
    usage: /back
    permission: behr.essentials.back
    script:
    # % ██ [ Check Args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax

    # % ██ [ check if they have a back location ] ██
        - if !<player.has_flag[behr.essentials.teleport.back]>:
            - narrate format:Colorize_Red "No back location to return to."
            - stop

        - if !<server.worlds.parse[name].contains[<player.flag[behr.essentials.teleport.back].as_map.get[world]>]>:
            - narrate format:Colorize_Red "That world is not currently loaded."
            - stop

    # % ██ [  Teleport Player ] ██
        - define back_location <player.flag[behr.essentials.teleport.back].as_map.get[location]>
        - if !<[back_location].chunk.is_loaded>:
            - chunkload <[back_location].chunk>
        - narrate format:Colorize_Green "Returning to last location"
        - flag <player> behr.essentials.teleport.back:<map.with[location].as[<player.location>].with[world].as[<player.world.name>]>
        - if <[back_location].below.points_between[<[back_location].highest.above>].filter[material.is_solid.not].is_empty>:
            - teleport <player> <[back_location]>
        - else:
            - teleport <player> <[back_location].below.points_between[<[back_location].highest.above>].filter[material.is_solid.not].first>
