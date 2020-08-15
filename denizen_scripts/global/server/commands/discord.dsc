Discord_Command:
    type: command
    name: discord
    debug: false
    description: Gives you the discord link.
    usage: /discord
    permission: Behr.Essentials.Discord
    tab complete:
        - define Args Link
        - inject OneArg_Command_Tabcomplete
    script:
    # % ██ [ Check Args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax
        
    # % ██ [ Print Discord Link ] ██
        - if <context.args.is_empty>:
            - define URL "https://discord.adriftus.com"
            - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
            - define Text "<proc[Colorize].context[Click for the Invite Link to:|yellow]> <&3><&n>D<&b><&n>iscord]>"
            - narrate <proc[msgUrl].context[<def[Hover]>|<def[Text]>|<def[URL]>]>
        - else:
            - if <context.args.get[1]> != link:
                - inject Command_Syntax
            - define url https://discord.com/api/oauth2/authorize?client_id=716381772610273430&redirect_uri=http%3A%2F%2F147.135.7.85%3A25580%2FoAuth%2FDiscord&response_type=code&scope=identify%20connections&state=<player.uuid>_<util.random.uuid>
            - define Hover "<proc[Colorize].context[Click Link to link Discord to Minecraft|green]><&nl><proc[Colorize].context[https://discord.com/oauth2/authorize|blue]>"
            - define Text format:Colorize_Yellow "Click Link to link Discord to Minecraft"
            - narrate <proc[MsgURL].context[<[Hover]>|<[Text]>|<[URL]>]>
