ListBanned_Command:
    type: command
    name: listbanned
    debug: false
    description: Lists the banned players on the server.
    usage: /listbanned
    permission: behrry.moderation.listbanned
    script:
    # % ██ [ Verify args ] ██
        - if <context.args.first||null> != null:
            - inject Command_Syntax Instantly

    # % ██ [ Check for banned players ] ██
        - define BannedList <server.banned_players>
        - if <[BannedList].size> == 0:
            - narrate format:Colorize_red "There are no banned players."
        - else:
            - repeat <[BannedList].size.div[8].round_up>:
                - define Math1 <[Value].add[<[Value].sub[1].mul[7]>]>
                - define Math2 <[Value].add[<[Value].sub[1].mul[8]>].add[7]>
                - foreach <[BannedList].get[<[Math1]>].to[<[Math2]>]> as:Player:
                    - narrate "<&e><[Player].name> <&b>| <&3><[Player].ban_reason>"
