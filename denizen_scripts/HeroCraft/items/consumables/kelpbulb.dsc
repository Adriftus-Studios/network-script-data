kelpbulbobtain:
    type: world
    debug: false
    events:
        on player breaks kelp_plant chance:6:
            - determine kelp_bulb



kelp_bulb:
    type: item
    material: sugar
    debug: false
    display name: <yellow>Kelp Bulb
    lore:
    - <&6>The root of a kelp plant.
    - <&e>Right click <&6>to breathe the air within
    mechanisms:
        custom_model_data: 1
    data:
        recipe_book_category: misc.kelp_bulb
    recipes:
        1:
            type: shaped
            output_quantity: 1
            input:
            - kelp|kelp|kelp
            - kelp|air|kelp
            - kelp|kelp|kelp


kelpbulbevents:
    type: world
    debug: false
    events:
        on player right clicks block with:kelp_bulb:
                - if <player.oxygen.in_seconds> < 9:
                    - oxygen 120 mode:add
                    - take iteminhand quantity:1
                    - playsound sound:ENTITY_PLAYER_BURP <player>
                - else:
                    - actionbar "<red>Wait Longer"
                    - stop

