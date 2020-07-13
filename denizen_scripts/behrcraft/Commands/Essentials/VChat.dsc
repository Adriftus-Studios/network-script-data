VChat_Command:
    type: command
    name: vchat
    debug: false
    description: Enables or disables VChat
    permission: behrry.essentials.vchat
    usage: /vc ((on/off)/(Message))/<&lt>Message<&gt>
    tab complete:
        - define Arg1 <list[on|off]>
        - inject OneArg_Command_Tabcomplete Instantly
    aliases:
        - vc
    chat:
        - define Targets <server.list_online_players_flagged[behrry.essentials.vchat]>
        - define Prefix "<&b>┤<proc[Colorize].context[<player.display_name.strip_color>:|Blue]>"
        - define Message "<&2><context.raw_args.parse_color>"
        - narrate targets:<[Targets]> "<[Prefix]> <[Message]>"
        
        - define DiscordMessage "**<player.name.display_name.strip_color>**: <[Message].strip_color.escaped>"
        - bungeerun Discord Discord_Message def:519612225854504962|<[DiscordMessage]>
    script:
    # @ ██ [  Check Args ] ██
        - if <list[On|off].contains[<context.args.get[1]>]> || <context.args.get[1]||null> == null:
            - if <context.args.get[2]||null> == null:
                - define Arg <context.args.get[1]||null>
                - define ModeFlag "behrry.essentials.vchat"
                - define ModeName " <&b>┤VChat"
                - inject Activation_Arg Instantly
            - else:
                - inject locally Chat Instantly
        - else if <context.args.get[2]||null> != null:
            - inject locally Chat Instantly
        - else:
            - inject Command_Syntax Instantly