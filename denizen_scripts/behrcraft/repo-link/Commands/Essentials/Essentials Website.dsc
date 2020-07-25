Website_Command:
    type: command
    name: website
    debug: false
    description: Gives you the website link.
    usage: /website
    permission: Behr.Essentials.website
    script:
    # % ██ [ Check Args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax

    # % ██ [ Send Website Link ] ██
        - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[https://Adriftus.com/|blue]>"
        - define Text "<proc[Colorize].context[Click for the Link to:|yellow]> <&3><&n>A<&b><&n>driftus.com"
        - define URL https://Adriftus.com/
        - narrate <proc[msgUrl].context[<[Hover]>|<[Text]>|<[URL]>]>
