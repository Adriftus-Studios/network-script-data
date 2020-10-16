teleportation_crystal_recipe_item:
    type: item
    material: paper
    display name: <&a>Recipe<&co> Teleportation Crystal
    mechanisms:
        nbt: teleportgoesweeeee

teleportation_crystal_recipe_handler:
    type: world
    events:
        on player right clicks with:recipe_item_name:
        - if !<player.has_flag[teleportation_recipe]>:
            - flag teleportation_recipe
            - take scriptname:teleportation_crystal_recipe_item
        - else
            - narrate "You can't use this item again"
            - determine cancelled
