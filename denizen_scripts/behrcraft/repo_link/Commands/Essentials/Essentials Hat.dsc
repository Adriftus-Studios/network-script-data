Hat_Command:
    type: command
    name: hat
    debug: true
    description: Places a held item as a hat
    usage: /hat
    permission: Behr.Essentials.Hat
    script:
    # % ██ [  Check Args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax
        
    # % ██ [  Check item ] ██
        - if <player.item_in_hand.material.name> == air:
            - narrate format:Colorize_Red "No item in hand."
            - stop
        
    # % ██ [  Check if player is wearing a hat already ] ██
        - if <player.equipment.helmet.material.name> != air:
            - narrate format:Colorize_Red "You must remove your current hat first."
            - stop
        
    # % ██ [  Receive Hat ] ██
        - equip <player> head:<player.item_in_hand.with[quantity=1]>
        - take iteminhand quantity:1
