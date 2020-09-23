ClearInventory_Command:
    type: command
    name: clearinventory
    debug: false
    description: Clears yours, or another player's inventory
    usage: /clearinventory
    permission: Behr.Essentials.ClearInventory
    aliases:
        - clearinv
        - invclear
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - define Blacklist <list[<player>]>
            - inject Online_Player_Tabcomplete
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.is_empty>:
            - define User <player>

    # % ██ [ Check User ] ██
        - else if <context.args.size> == 1:
            - define User <context.args.first>
            - inject Player_Verification

        - else:
            - inject Command_Syntax

    # % ██ [ Clear Inventory ] ██
        - if <[User]> != <player>:
            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Inventory Cleared.|green]>"
        - narrate targets:<[User]> format:Colorize_Green "Inventory Cleared."
        - inventory clear d:<[User].inventory>
