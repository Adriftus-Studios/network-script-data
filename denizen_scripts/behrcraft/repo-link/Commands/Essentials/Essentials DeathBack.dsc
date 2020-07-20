# | ███████████████████████████████████████████████████████████
# % ██    DeathBack / DBack - similar to /Back, but returns you
# % ██    to your death location alternatively.
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | Add a click button to opt teleporting back to a dangerous location
deathback_Command:
    type: command
    name: deathback
    debug: false
    description: Returns you back your death location.
    permission: Behrry.Essentials.DBack
    usage: /deathback
    aliases:
        - dback
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.size> != 0:
            - inject Command_Syntax Instantly

    # @ ██ [  Check if player has death-back ] ██
        - if !<player.has_flag[Behrry.Essentials.Teleport.DeathBack]>:
            - narrate format:Colorize_Red "No death location to return to."
            - stop
        
    # @ ██ [  Teleport Player ] ██
        - narrate format:Colorize_Green "Returning to death location."
        - define BackLoc <player.flag[Behrry.Essentials.Teleport.DeathBack].as_location>
        - flag <player> Behrry.Essentials.Teleport.DeathBack:<player.location>
        - chunkload <[BackLoc].chunk>
        - define Add 0
        - while <[BackLoc].above[<[Add]>].material.name> != air && <[BackLoc].highest.above[2].y> > <[BackLoc].above[<[Add]>].y>:
            - define add:+:1
        - teleport <player> <[BackLoc].above[<[Add]>]>
