storage_enchantment:
  type: enchantment
  id: storage
  debug: false
  slots:
  - mainhand
  rarity: very_rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - These items contain an extra inventory.
      - <empty>
      - Pairs well with Siphon
    item_slots:
      - tools
  category: breakable
  full_name: <&7>storage <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_hoe|*_shovel|*_pickaxe|*_axe|shears]>

storage_handler:
  type: world
  debug: false
  events:
    on player right clicks block with:item_enchanted:storage_enchantment using:hand:
      - define items <list[<context.item.has_flag[enchantment.storage].if_null[air]>]>
      - choose <context.level>:
        - case 1:
          - define contents <list[standard_filler|standard_filler].include[<[items]>].include[standard_filler|standard_filler]>
        - case 2:
          - define contents <list[standard_filler].include[<[items]>].include[standard_filler]>
        - case 3:
          - define contents <[items]>
      - define padding <context.level>
      - define items <context.item.flag[enchantment.storage]>
      - inventory open destination:storage_enchantment_inventory_<context.level>

    on player closes storage_enchantment_inventory:
      - flag <player.item_in_hand> <context.inventory.exclude_item[standard_filler].list_contents>
#TODO add handling to prevent player from moving their item in hand and fucking stuff up.
#TODO add handling to check that its a proper material for the tool to be holding.
    on player clicks in storage_enchantment_inventory:
      - if <context.item>

storage_enchantment_inventory:
  type: inventory
  inventory: hopper
  debug: false
  title: Storage
