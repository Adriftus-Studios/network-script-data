Ignore_Command:
    type: command
    name: ignore
    debug: false
    description: Adds or removes a player to or from your ignore list.
    usage: /ignore <&lt>Player<&gt> (Remove)
    permission: Behrry.Essentials.Ignore
    script:
    # @ ██ [  Check for args ] ██
        - if <context.args.get[1]||null> == null || <context.args.get[3]||null> != null:
            - inject Command_Syntax Instantly
        
    # @ ██ [  Check for player ] ██
        - define User <context.args.get[1]>
        - inject Player_Verification_Offline
        
    # @ ██ [  Check for removal arg ] ██
        - if <context.args.get[2]||null> != null:
            - if <context.args.get[2]> != remove:
                - inject Command_Syntax Instantly

        # @ ██ [  Check if player is on the ignore list ] ██
            - if !<player.flag[Behrry.Essentials.IgnoreList].contains[<[User]>]||false>:
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is not in your ignore list.|red]>"
                - stop
            
        # @ ██ [  Remove player ] ██
            - flag player Behrry.Essentials.IgnoreList:<-:<[User]>
            - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[was removed from your ignore list.|green]>"
        
    # @ ██ [  Run process to add player ] ██
        - else:
        # @ ██ [  Check if player is already ignored ] ██
            - if <player.flag[Behrry.Essentials.IgnoreList].contains[<[User]>]||false>:
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is already ignored.|red]>"
                - stop
        
        # @ ██ [  Check if player is on ignore list ] ██
            - if <player.flag[Behrry.Essentials.IgnoreList].contains[<[User]>]||false>:
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is on your ignore list.|red]>"
                - stop
        
        # @ ██ [  Add player to ignore list ] ██
            - flag player Behrry.Essentials.IgnoreList:->:<[User]>
            - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[was added to your ignore list.|green]>"
