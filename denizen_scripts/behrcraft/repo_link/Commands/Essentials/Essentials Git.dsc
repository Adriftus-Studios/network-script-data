Github_Command:
    type: command
    name: github
    debug: false
    description: Gives you the Github link.
    usage: /git
    permission: Behr.Essentials.github
    aliases:
    - git
    script:
    # % ██ [ Check Args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax
        
    # % ██ [ Print github Link ] ██
        - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[https://github.com/BehrRiley/The-Network|blue]>"
        - define Text "<proc[Colorize].context[Click for the Link to:|yellow]> <&3><&n>G<&b><&n>ithub"
        - define URL https://github.com/BehrRiley/The-Network
        - narrate <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
