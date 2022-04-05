
hammers_events:
  type: world
  debug: false
  data:
    allowed_blocks:
    - stone
    - granite
    - andesite
    - diorite
    - polished*
    - *stone
    - *_ore
    - *deepslate
    - tuff
    - *erracotta
    - dripstone_block
    - *basalt
    - netherrack
    - *quartz*
    - bone_block
    - *brick*
    - calcite
    - *sandstone*
  events:
    on player breaks block bukkit_priority:highest:
    - if <player.item_in_hand.enchantment_types.parse[name].contains[area_dig]>:
      - ratelimit <player> 1t
      - define loc <context.location.face[<context.location.relative[<player.location.forward.sub[<player.location>].round>]>]>
      - define cuboid <[loc].up.right.to_cuboid[<[loc].down.left>]>
      - define blocks <[cuboid].blocks[<script.data_key[data.allowed_blocks].separated_by[|]>]>
      - ~modifyblock <[blocks]> air naturally:<player.item_in_hand> source:<player>
      - if <player.item_in_hand.enchantment_map.contains[unbreaking]>:
        - if <proc[calculate_durability_damage].context[<player.item_in_hand.enchantment_map.get[unbreaking]>].is_more_than[<util.random.decimal[0].to[1]>]>:
          - inventory set d:<player.inventory> slot:<player.held_item_slot> o:<player.item_in_hand.with[durability=<player.item_in_hand.durability.add[1]>]>
      - else:
        - inventory set d:<player.inventory> slot:<player.held_item_slot> o:<player.item_in_hand.with[durability=<player.item_in_hand.durability.add[1]>]>
      - if <player.item_in_hand.durability> > <player.item_in_hand.max_durability>:
        - inventory set d:<player.inventory> slot:<player.held_item_slot> o:<item[air]>

hammer_diamond:
  type: item
  material: diamond_pickaxe
  data:
    recipe_book_category: tools.hammer2
    repair_reagent_requirement_multiplier: 9
    repair_reagent: diamond
  mechanisms:
    custom_model_data: 1
    enchantments:
      area_dig: 1
  display name: <&e>Diamond Hammer
  recipes:
    1:
      type: shaped
      recipe_id: diamond_hammer_1
      output_quantity: 1
      input:
      - material:diamond_block|material:diamond_block|material:diamond_block
      - air|material:stick|air
      - air|material:stick|air

hammer_netherite:
  type: item
  material: netherite_pickaxe
  data:
    recipe_book_category: tools.hammer3
    repair_reagent_requirement_multiplier: 9
    repair_reagent: netherite_ingot
  mechanisms:
    custom_model_data: 1
    enchantments:
      area_dig: 1
  display name: <&e>Netherite Hammer
  recipes:
    1:
      type: shaped
      recipe_id: netherite_hammer_1
      output_quantity: 1
      input:
      - material:netherite_block|material:netherite_block|material:netherite_block
      - air|material:stick|air
      - air|material:stick|air

hammer_iron:
  type: item
  material: iron_pickaxe
  data:
    recipe_book_category: tools.hammer1
    repair_reagent_requirement_multiplier: 9
    repair_reagent: iron_ingot
  mechanisms:
    custom_model_data: 1
    enchantments:
      area_dig: 1
  display name: <&e>Iron Hammer
  recipes:
    1:
      type: shaped
      recipe_id: iron_hammer_1
      output_quantity: 1
      input:
      - material:iron_block|material:iron_block|material:iron_block
      - air|material:stick|air
      - air|material:stick|air

enchantment_area_dig:
  type: enchantment
  id: area_dig
  slots:
  - mainhand
  rarity: VERY_RARE
  category: BREAKABLE
  full_name: Area Dig
  min_level: 1
  max_level: 1
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: false
  is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:mending|minecraft:efficiency].not>
  can_enchant: <context.item.material.name.contains[pickaxe]>
  damage_bonus: 0.0
  damage_protection: 0
  # after attack:
  # - narrate "You attacked <context.victim.name> with a <context.level> enchantment!"
  # after hurt:
  # - adjust <player> gliding:false