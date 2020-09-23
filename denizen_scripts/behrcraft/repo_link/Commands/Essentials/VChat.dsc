VChat_Command:
    type: command
    name: vchat
    debug: false
    description: Enables or disables VChat
    permission: Behr.Essentials.vchat
    usage: /vc ((on/off)/(Message))/<&lt>Message<&gt>
    tab complete:
        - define Arg1 <list[on|off]>
        - inject OneArg_Command_Tabcomplete
    aliases:
        - vc
    chat:
        - define Targets <server.online_players_flagged[Behr.Essentials.vchat]>
        - define Prefix "<&b>┤<proc[Colorize].context[<player.display_name.strip_color>:|Blue]>"
        - define Message "<&2><context.raw_args.parse_color>"
        - narrate targets:<[Targets]> "<[Prefix]> <[Message]>"
        
        - define DiscordMessage "**<player.name.display_name.strip_color>**: <[Message].strip_color.escaped>"
        - bungeerun Discord Discord_Message def:519612225854504962|<[DiscordMessage]>
    script:
    # % ██ [   Check Args ] ██
        - if <context.args.is_empty> || <list[On|off].contains[<context.args.first>]>:
            - if <context.args.get[2]||null> == null:
                - define Arg <context.args.first||null>
                - define ModeFlag "Behr.Essentials.vchat"
                - define ModeName " <&b>┤VChat"
                - inject Activation_Arg
            - else:
                - inject locally Chat
        - else if <context.args.size> == 2:
            - inject locally Chat
        - else:
            - inject Command_Syntax
