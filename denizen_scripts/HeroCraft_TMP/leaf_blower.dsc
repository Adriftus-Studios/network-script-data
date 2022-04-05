
leaf_blower_bow_events:
    type: world
    debug: false
    events:
        on projectile hits block:
        - if <context.projectile.has_flag[item]> && <context.projectile.has_flag[shooter]> && <context.projectile.flag[item].enchantment_map.contains[leaf_blower]>:
            - if <context.location.material.name.advanced_matches_text[*leaves]>:
                - define vel <context.projectile.velocity>
                - define location <context.projectile.location>
                - define item <context.projectile.flag[item]>
                - define shooter <context.projectile.flag[shooter]>
                - modifyblock <context.location.flood_fill[3].types[*leaves]> air source:<[shooter]> naturally:<[item]>
                - remove <context.projectile>
                - if <context.location.material.name> != air:
                    - stop
                - spawn arrow <[location]> save:arrow
                - define arrow <entry[arrow].spawned_entity>
                - adjust <[arrow]> velocity:<[vel]>
                - flag <[arrow]> item:<[item]>
                - flag <[arrow]> shooter:<[shooter]>
        on player shoots bow:
        - flag <context.projectile> item:<context.bow>
        - flag <context.projectile> shooter:<player>

leaf_blower_bow:
    type: item
    material: bow
    display name: <&e>Leaf Blower
    data:
        recipe_book_category: tools
    mechanisms:
        enchantments:
            leaf_blower: 1
    recipes:
        1:
            type: shaped
            recipe_id: leaf_blower_1
            output_quantity: 1
            input:
            - air|material:stick|material:string
            - material:stick|material:shears|material:string
            - air|material:stick|material:string

enchantment_leaf_blower:
    type: enchantment
    id: leaf_blower
    slots:
    - mainhand
    rarity: VERY_RARE
    category: BREAKABLE
    full_name: Leaf Blower
    min_level: 1
    max_level: 1
    min_cost: <context.level.mul[1]>
    max_cost: <context.level.mul[1]>
    treasure_only: true
    is_curse: false
    is_tradable: false
    is_discoverable: false
    is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:mending].not>
    can_enchant: <context.item.material.name.contains[bow]>
    damage_bonus: 0.0
    damage_protection: 0