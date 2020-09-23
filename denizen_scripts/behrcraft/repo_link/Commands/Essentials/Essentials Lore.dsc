Lore_Command:
    type: command
    name: lore
    debug: false
    description:  Applies Lore to the item in hand.
    usage: /lore <&lt>Lore Line 1<&gt>/(Lore Line #)*
    permission: Behr.Essentials.Lore
    tab complete:
        - determine <empty>
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.is_empty>:
            - inject Command_Syntax Instantly

    # % ██ [ Check Item ] ██
        - if <player.item_in_hand.material.name> == air:
            - narrate colorize_red "Hold a valid item."
            - stop
        
    # % ██ [ Format Lore ] ██
        - define Lore <context.args.escape_contents.space_separated.unescaped.split[/].parse[trim.parse_color]>

    # % ██ [ Adjust Item ] ██
        - inventory adjust slot:<player.held_item_slot> lore:<[Lore]>
        - playsound <player> entity_ender_eye_death
