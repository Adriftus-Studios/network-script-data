Top_Command:
    type: command
    name: top
    debug: false
    description: Takes you to the top!
    usage: /top
    permission: behrry.essentials.top
    script:
    # @ ██ [  Check for args ] ██
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
    # @ ██ [  check if they're already at the top ] ██
        - if <player.location.y> > <player.location.highest.y>:
            - narrate "<proc[Colorize].context[Nothing Interesting Happens.|yellow]>"
            - stop
        - else:
            - flag player behrry.essentials.teleport.back:<player.location>
            - narrate "<proc[Colorize].context[Taking you to the top.|green]>"
            - teleport <player> <player.location.highest.add[0,2,0]>