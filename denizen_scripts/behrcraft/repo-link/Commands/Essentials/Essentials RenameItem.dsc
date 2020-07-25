RenameItem_Command:
    type: command
    name: renameitem
    debug: false
    description:  Applies a custom Display Name to the item in hand.
    usage: /RenameItem <&lt>Display Name<&gt>
    permission: Behr.Essentials.RenameItem
    tab complete:
        - determine ""
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.size> == 0:
            - inject Command_Syntax Instantly
    # % ██ [ Check Item ] ██
        - if <player.item_in_hand.material.name> == air:
            - narrate colorize_red "Hold a valid item."
            - stop
        
    # % ██ [ Format Lore ] ██
        - define DisplayName <context.raw_args.parse_color>

    # % ██ [ Adjust Item ] ██
        - inventory adjust slot:<player.held_item_slot> display_name:<[DisplayName]>
        - playsound <player> entity_ender_eye_death

                                        
