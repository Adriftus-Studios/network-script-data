Sculk_Harvester_enchantment:
  type: enchantment
  id: sculk_harvester
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[3]>
  data:
    effect:
      - Increases EXP gained from breaking sculk blocks
    item_slots:
      - hoe
  category: digger
  full_name: <&7>Sculk Harvester <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_hoe]>
  is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:silk_touch].not>
  treasure_only: true

Sculk_Harvester_enchant_handler:
  type: world
  debug: false
  events:
    on player breaks sculk with:item_enchanted:sculk_harvester:
    - define multiplier <util.random.decimal[1].to[<player.item_in_hand.enchantment_map.get[sculk_harvester].add[2].div[2]>]>
    - determine <context.xp.mul[<[multiplier]>]>