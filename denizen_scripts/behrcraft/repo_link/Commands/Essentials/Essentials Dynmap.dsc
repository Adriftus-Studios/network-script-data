Dynmap_Command:
    type: command
    name: dynmap
    debug: false
    description: Gives you the dynmap link.
    usage: /dynmap
    permission: Behr.Essentials.Dynmap
    script:
    # % ██ [ Check Args ] ██
        - if !<context.args.is_empty>:
            - if <player.name> != Behr_Riley:
                - inject Command_Syntax
            - stop

    # % ██ [ Print Dynmap Link ] ██
        - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[https://banditcraft.pro/dynmap|blue]>"
        - define Text "<proc[Colorize].context[Click for the Link to:|yellow]> <&3><&n>D<&b><&n>ynmap"
        - define URL http://76.119.243.194:8123/index.html
        - narrate <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
