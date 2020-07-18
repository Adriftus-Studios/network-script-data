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
  # % ██ [  Check Args ] ██
    - if !<context.args.is_empty>
      - inject Command_Syntax Instantly

  # % ██ [  Check if player has death-back ] ██
    - if !<player.has_flag[Behr.Essentials.Teleport.DeathBack]>:
      - narrate format:Colorize_Red "No death location to return to."
      - stop
    
  # % ██ [  Teleport Player ] ██
    - narrate format:Colorize_Green "Returning to death location."
    - define BackLoc <player.flag[Behr.Essentials.Teleport.DeathBack].as_location>
    - flag <player> Behr.Essentials.Teleport.DeathBack:<player.location>
    - chunkload <[BackLoc].chunk>
    - define Add 0
    - while ( <[BackLoc].above[<[Add]>].material.name> != air || <[BackLoc].above[<[Add]>].material.is_transparent> ) && <[BackLoc].highest.above[2].y> > <[BackLoc].above[<[Add]>].y>:
      - define add:+:1
    - teleport <player> <[BackLoc].above[<[Add]>]>
