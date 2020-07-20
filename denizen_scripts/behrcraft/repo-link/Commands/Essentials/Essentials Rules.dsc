Rules_Command:
    type: command
    name: rules
    debug: false
    description: Lists the rules for the server.
    usage: /rules
    permission: behrry.essentials.rules
    script:
    # @ ██ [  Check for args ] ██
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        
    # @ ██ [  print ] ██
        - narrate "<&e>1<&6>.<&r> <&a>Use common sense."


