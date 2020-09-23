Message_Command:
    type: command
    name: msg
    debug: false
    description: Messages a player
    usage: /msg <&lt>Player<&gt> <&lt>Message<&gt>
    permission: Behr.Essentials.Msg
    aliases:
        - message
        - m
    tab complete:
        - define Blacklist <server.online_players.filter[has_flag[Behrry.Moderation.Hide]].include[<Player>]>
        - inject Online_Player_Tabcomplete
    script:
        - if <context.args.size> < 2:
            - inject Command_Syntax

        - define User <context.args.first>
        - inject Player_Verification
        - if <[User]> == <player>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop

        - flag <[User]> Behrry.Chat.LastReply:<player.name>
        - define Message <context.raw_args.after[<context.args.first><&sp>].parse_color><&r>
        - narrate targets:<player>  "<&7>[<&8><[User].name><&7>]<&1> <&chr[00ab]> <&9><[Message]>"
        - narrate targets:<[User]>  "<&7>[<&8><player.name><&7>]<&1> <&chr[00bb]> <&9><[Message]>"

Reply_Command:
    type: command
    name: r
    debug: false
    description: Replies to the last player who messaged you.
    usage: /r <&lt>Message<&gt>
    permission: Behr.Essentials.Reply
    aliases:
        - reply
    script:
    # % ██ [ Check for Empty Arg ] ██
        - if <context.args.is_empty>:
            - inject Command_Syntax
    # % ██ [ Check if player has a return recip. ] ██
        - if <player.has_flag[Behrry.Chat.LastReply]>:
            - define User <player.flag[Behrry.Chat.LastReply]>
            - inject Player_Verification
        - else:
            - narrate format:Colorize_Red "Nobody to respond to."
            - stop
        - define Message <context.raw_args.parse_color>
        - flag <[User]> Behrry.Chat.LastReply:<player.name>
        - narrate targets:<player>  "<&7>[<&8><[User].name><&7>] <&1><&l><&chr[00ab]>- <&9><[Message]>"
        - narrate targets:<[User]>  "<&7>[<&8><player.name><&7>] <&1><&l>-<&chr[00bb]> <&9><[Message]>"
