
lumber_axe_events:
    type: world
    debug: false
    data:
        allowed_blocks:
        - oak_wood
        - oak_log
        - spruce_wood
        - spruce_log
        - jungle_wood
        - jungle_log
        - birch_wood
        - birch_log
        - acacia_wood
        - acacia_log
        - dark_oak_wood
        - dark_oak_log
    events:
        on player breaks block:
        - define item <player.item_in_hand>
        - define slot <player.held_item_slot>
        - define material <context.material.name>
        - if <[item].enchantment_map.contains[tree_feller].not||true>:
            - stop
        - if <player.flag[lumber_axe_queue].state.equals[stopping].not||false>:
            - stop
        - if !<script.data_key[data.allowed_blocks].contains[<[material]>]>:
            - stop
        - define start <context.location.up.left.forward.to_cuboid[<context.location.backward.right.down>]>
        - define blocks <[start].blocks[<script.data_key[data.allowed_blocks].separated_by[|]>]>
        - flag <player> lumber_axe_queue:<queue> expire:1h
        - while <[blocks].size.equals[0].not>:
            - define new_blocks <[blocks]>
            - foreach <[blocks]> as:b:
                - if <player.is_online.not> || <player.is_spawned.not> || <player.inventory.slot[<[slot]>].enchantment_map.contains[tree_feller].not||true>:
                    - stop
                - define new_blocks <[new_blocks].exclude[<[b]>]>
                - drop <item[<[b].material.name>]> <context.location.center>
                - modifyblock <[b]> air source:<player>
                - wait 1t
                - if <[b].material.name.equals[air]>:
                    - if <player.inventory.slot[<[slot]>].enchantment_map.contains[unbreaking]>:
                        - if <proc[calculate_durability_damage].context[<player.inventory.slot[<[slot]>].enchantment_map.get[unbreaking]>].is_more_than[<util.random.decimal[0].to[1]>]>:
                            - inventory set d:<player.inventory> slot:<[slot]> o:<player.inventory.slot[<[slot]>].with[durability=<player.inventory.slot[<[slot]>].durability.add[1]>]>
                    - else:
                        - inventory set d:<player.inventory> slot:<[slot]> o:<player.inventory.slot[<[slot]>].with[durability=<player.inventory.slot[<[slot]>].durability.add[1]>]>
                    - if <player.inventory.slot[<[slot]>].durability.is_more_than[<player.inventory.slot[<[slot]>].max_durability>]>:
                        - inventory set d:<player.inventory> slot:<[slot]> o:<item[air]>
                    - adjustblock <[b].up.left.forward.to_cuboid[<[b].backward.right.down>].blocks[*leaves]> persistent:false
                    - define new_blocks:|:<[b].up.left.forward.to_cuboid[<[b].backward.right.down>].blocks[<script.data_key[data.allowed_blocks].separated_by[|]>]>
            - define blocks <[new_blocks].deduplicate>
        - flag <player> lumber_axe_queue:!

lumber_axe_iron:
    type: item
    material: iron_axe
    mechanisms:
        enchantments:
            tree_feller: 1
            unbreaking: 5
    display name: <&e>Iron Lumber Axe
    recipes:
        1:
            type: shaped
            recipe_id: iron_lumber_axe_1
            output_quantity: 1
            input:
            - material:iron_block|material:iron_block
            - material:iron_block|material:stick
            - air|material:stick
        2:
            type: shaped
            recipe_id: iron_lumber_axe_2
            output_quantity: 1
            input:
            - material:iron_block|material:iron_block
            - material:stick|material:iron_block
            - material:stick|air

lumber_axe_diamond:
    type: item
    material: diamond_axe
    mechanisms:
        enchantments:
            tree_feller: 1
            unbreaking: 5
    display name: <&e>Diamond Lumber Axe
    recipes:
        1:
            type: shaped
            recipe_id: diamond_lumber_axe_1
            output_quantity: 1
            input:
            - material:diamond_block|material:diamond_block
            - material:diamond_block|material:stick
            - air|material:stick
        2:
            type: shaped
            recipe_id: diamond_lumber_axe_2
            output_quantity: 1
            input:
            - material:diamond_block|material:diamond_block
            - material:stick|material:diamond_block
            - material:stick|air

lumber_axe_netherite:
    type: item
    material: netherite_axe
    mechanisms:
        enchantments:
            tree_feller: 1
            unbreaking: 5
    display name: <&e>Netherite Lumber Axe
    recipes:
        1:
            type: shaped
            recipe_id: netherite_lumber_axe_1
            output_quantity: 1
            input:
            - material:netherite_block|material:netherite_block
            - material:netherite_block|material:stick
            - air|material:stick
        2:
            type: shaped
            recipe_id: netherite_lumber_axe_2
            output_quantity: 1
            input:
            - material:netherite_block|material:netherite_block
            - material:stick|material:netherite_block
            - material:stick|air

enchantment_tree_feller:
    type: enchantment
    id: tree_feller
    slots:
    - mainhand
    rarity: VERY_RARE
    category: BREAKABLE
    full_name: Tree Feller
    min_level: 1
    max_level: 1
    min_cost: <context.level.mul[1]>
    max_cost: <context.level.mul[1]>
    treasure_only: true
    is_curse: false
    is_tradable: false
    is_discoverable: false
    is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:mending].not>
    can_enchant: <context.item.material.name.contains[axe].and[<context.item.material.name.contains[pickaxe].not>]>
    damage_bonus: 0.0
    damage_protection: 0
