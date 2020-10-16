Head_Command:
    type: command
    name: head
    debug: false
    description: Gives you a player's head.
    usage: /head <&lt>Name<&gt> (UUID)
    permission: Behrry.Essentials.Head
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.is_empty> || <context.args.get[3]||null> != null:
            - inject Command_Syntax Instantly

    # % ██ [ Check if specifying UUID ] ██
        - define PlayerName <context.args.first>
        - if <context.args.get[2]||null> == null:
            - if <[PlayerName]> == Behr_Riley:
                - narrate <&c>no
                - stop
            - give player_head[skull_skin=<[PlayerName]>]
        - else:
            - define UUID <context.args.get[2]>
            - give player_head[skull_skin=<[PlayerName]>|<[UUID]>]


HeadFixer:
    type: world
    events:
        on player right clicks player_head:
            - if <player.gamemode> == creative && <player.is_sneaking>:
                - adjust <player> item_in_hand:<item[player_head].with[skull_skin=<player.location.cursor_on.skull_skin.full>]>
