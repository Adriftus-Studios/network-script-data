Github_Command:
    type: command
    name: github
    debug: false
    description: Gives you the Github link.
    usage: /git
    permission: Behrry.Essentials.github
    aliases:
    - git
    script:
        #@ Check Args
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        
        #@ Print github Link
        - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[https://github.com/BehrRiley/The-Network|blue]>"
        - define Text "<proc[Colorize].context[Click for the Link to:|yellow]> <&3><&n>G<&b><&n>ithub"
        - define URL "https://github.com/BehrRiley/The-Network"
        - narrate <proc[msgUrl].context[<def[Hover]>|<def[Text]>|<def[URL]>]>