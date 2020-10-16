Friend_Command:
    type: command
    name: friend
    debug: false
    description: Adds or removes a player to or from your friends list.
    usage: /friend <&lt>Player<&gt> (Remove)
    permission: Behr.Essentials.Friend
    script:
    # % ██ [ Check for args ] ██
        - if !<list[1|2].contains[<context.args.size>]>:
            - inject Command_Syntax

    # % ██ [ Check for player ] ██
        - define User <context.args.first>
        - inject Player_Verification_Offline

    # % ██ [ Check for removal arg ] ██
        - if <context.args.size> == 2:
            - if <list[Remove|Delete|DeFriend].contains[<context.args.get[2]>]>:
                - inject Command_Syntax

        # % ██ [ Check if player has a friends list ] ██
            - if !<player.has_flag[Behr.Essentials.Friends]>:
                - narrate "<proc[Colorize].context[There are no players on your friends list.|red]>"
                - stop

        # % ██ [ Check if player is on the friends list ] ██
            - if !<player.flag[Behr.Essentials.Friends].contains[<[User]>]>:
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is not in your friends list.|red]>"
                - stop

        # % ██ [ Remove player ] ██
            - flag player Behr.Essentials.Friends:<-:<[User]>
            - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[was removed from your friends list.|green]>"

    # % ██ [ Run process to add friend ] ██
        - else:

        # % ██ [ Check if player has a friends list ] ██
            - if <player.has_flag[Behr.Essentials.Friends]>:
                - narrate "<proc[Colorize].context[There are no players on your friends list.|red]>"
                - stop
                
            # % ██ [ Check if player is already a friend ] ██
                - if <player.flag[Behr.Essentials.Friends].contains[<[User]>]>:
                    - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is already your friend.|red]>"
                    - stop

            # % ██ [ Check if player is on ignore list ] ██
                - if <player.flag[Behr.Essentials.IgnoreList].contains[<[User]>]>:
                    - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is on your ignore list.|red]>"
                    - stop
        
        # % ██ [ Add player to friends list ] ██
            - flag player Behr.Essentials.Friends:->:<[User]>
            - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[was added to your friends list.|green]>"
