Discordc_Command:
    type: command
    name: discordc
    usage: /discordc restart
    permission: behrry.essentials.discordc
    description: Controls the discordbots.
    aliases:
        - dc
    script:
        - choose <context.args.first||null>:
            - case start:
                - inject Discord_Handler path:StartBots
            - case restart:
                - inject Discord_Handler path:RestartBots
            - case stop:
                - inject Discord_Handler path:StopBots

            - case Test:
                - if <context.args.get[3]||null> == null:
                    - inject Command_Syntax Instantly
                - discord id:<context.args.get[2]> message channel:623758713056133120 "<context.raw_args.after[<context.args.get[2]><&sp>]>"
            - case default:
                - inject Command_Syntax Instantly
