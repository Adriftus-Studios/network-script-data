resourcepack_Command:
    type: command
    name: resourcepack
    debug: false
    description: Injects the resource pack.
    usage: /resourcepack
    permission: behrry.essentials.resourcepack
    script:
    # @ ██ [  Check for args ] ██
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        
    # @ ██ [  check if they have a resourcepack location ] ██
        - adjust <player> "resource_pack:https://cdn.discordapp.com/attachments/625076684558958638/681593572222566419/withdiscordemoji.zip"



