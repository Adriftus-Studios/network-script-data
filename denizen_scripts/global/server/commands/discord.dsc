Discord_Command:
  type: command
  name: discord
  debug: false
  description: Gives you the discord link.
  usage: /discord
  permission: Behr.Essentials.Discord
  tab complete:
    - define Args <list[Connect]>
    - inject OneArg_Command_Tabcomplete
  script:
  # % ██ [ Check Args ] ██
    - if <context.args.size> > 1:
      - inject Command_Syntax
    
  # % ██ [ Print Discord Link ] ██
    - if <context.args.is_empty> || ( <context.args.size> == 1 && <list[link|invite].contains[<context.args.first>]> ):
      - define URL https://discord.adriftus.com
      - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
      - define Text "<proc[Colorize].context[Click for the Invite Link to:|yellow]> <&3><&n>D<&b><&n>iscord"
      - narrate <proc[msg_url].context[<def[Hover]>|<def[Text]>|<def[URL]>]>
    - else:
      - if !<list[Connect|SignMeUpCoach].contains_any[<context.args.first>]>:
        - inject Command_Syntax
      - define uuid <util.random.uuid>
      - define url https://discord.com/api/oauth2/authorize?client_id=716381772610273430&redirect_uri=http<&pc>3A<&pc>2F<&pc>2F147.135.7.85<&pc>3A25580<&pc>2FoAuth<&pc>2FDiscord&response_type=code&scope=identify<&pc>20connections&state=<player.uuid>_<[uuid]>
      - define Hover "<proc[Colorize].context[Click Link to link Discord to Minecraft|green]><&nl><proc[Colorize].context[https://discord.com/oauth2/authorize|blue]>"
      - define Text "<proc[Colorize].context[Click Link to link Discord to Minecraft|yellow]>"
      - narrate <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
      - bungeerun relay discord_oauth def:<player.uuid>_<[uuid]>|add
