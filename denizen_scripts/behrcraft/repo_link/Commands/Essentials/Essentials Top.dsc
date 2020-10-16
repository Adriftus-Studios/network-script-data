Top_Command:
    type: command
    name: top
    debug: false
    description: Takes you to the top!
    usage: /top
    permission: Behr.Essentials.top
    script:
    # % ██ [ Check for args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax

    # % ██ [ check if they're already at the top ] ██
        - if <player.location.y> > <player.location.highest.y>:
            - narrate "<proc[Colorize].context[Nothing Interesting Happens.|yellow]>"
            - stop
        - else:
            - flag player behr.essentials.teleport.back:<map.with[location].as[<player.location>].with[world].as[<player.world.name>]>
            - narrate "<proc[Colorize].context[Taking you to the top.|green]>"
            - teleport <player> <player.location.highest.add[0,2,0]>
