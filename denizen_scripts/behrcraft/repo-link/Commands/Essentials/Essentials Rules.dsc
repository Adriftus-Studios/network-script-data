Rules_Command:
    type: command
    name: rules
    debug: false
    description: Lists the rules for the server.
    usage: /rules
    permission: Behr.Essentials.Rules
    script:
    # % ██ [ Check for args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax
        
    # % ██ [ print ] ██
        - narrate "<&e>1<&6>.<&r> <&a>Use common sense."
