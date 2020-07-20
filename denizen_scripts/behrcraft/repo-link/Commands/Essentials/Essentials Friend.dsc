Friend_Command:
    type: command
    name: friend
    debug: false
    description: Adds or removes a player to or from your friends list.
    usage: /friend <&lt>Player<&gt> (Remove)
    permission: behrry.Essentials.Friend
    script:
    # @ ██ [  Check for args ] ██
        - if !<list[1|2].contains[<context.args.size>]>:
            - inject Command_Syntax Instantly
        
    # @ ██ [  Check for player ] ██
        - define User <context.args.get[1]>
        - inject Player_Verification_Offline
        
    # @ ██ [  Check for removal arg ] ██
        - if <context.args.size> == 2:
            - if <context.args.get[2]> != remove:
                - inject Command_Syntax Instantly

        # @ ██ [  Check if player is on the friends list ] ██
            - if !<player.flag[Behrry.Essentials.Friends].contains[<[User]>]||false>:
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is not in your friends list.|red]>"
                - stop
            
        # @ ██ [  Remove player ] ██
            - flag player Behrry.Essentials.Friends:<-:<[User]>
            - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[was removed from your friends list.|green]>"
        
    # @ ██ [  Run process to add friend ] ██
        - else:
        # @ ██ [  Check if player is already a friend ] ██
            - if <player.flag[Behrry.Essentials.Friends].contains[<[User]>]||false>:
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is already your friend.|red]>"
                - stop
        
        # @ ██ [  Check if player is on ignore list ] ██
            - if <player.flag[Behrry.Essentials.IgnoreList].contains[<[User]>]||false>:
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is on your ignore list.|red]>"
                - stop
        
        # @ ██ [  Add player to friends list ] ██
            - flag player Behrry.Essentials.Friends:->:<[User]>
            - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[was added to your friends list.|green]>"
