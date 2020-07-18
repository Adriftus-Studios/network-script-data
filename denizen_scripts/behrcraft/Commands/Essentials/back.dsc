Back_Command:
    type: command
    name: back
    debug: false
    description: Returns you back to your last location.
    usage: /back
    permission: Behr.Essentials.Back
    script:
    # % ██ [  Check Args ] ██
        - if <context.args.size> != 0:
            - inject Command_Syntax Instantly
        
    # % ██ [  check if they have a back location ] ██
        - if <player.has_flag[Behrry.Essentials.Teleport.Back]>:
            - define BackLoc <player.flag[Behrry.Essentials.Teleport.Back].as_location>
            - narrate format:Colorize_Green "Returning to last location"
            - flag <player> Behrry.Essentials.Teleport.Back:<player.location>
            - chunkload <[BackLoc].chunk>
            - define Add 0
            - while <[BackLoc].above[<[Add]>].material.name> != air && <[BackLoc].highest.above[2].y> > <[BackLoc].above[<[Add]>].y>:
                - define add:+:1
            #- else:
            #    - repeat stop
            - teleport <player> <[BackLoc].above[<[Add]>]>
        - else:
            - narrate format:Colorize_Red "No back location to return to"


