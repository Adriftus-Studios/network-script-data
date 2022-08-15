xp_finder_enchantment:
  type: enchantment
  id: xp_finder
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[5]>
  data:
    effect:
      - Randomly converts stones to xp.
      - <empty>
      - Costs extra durability to use. Incompatible with fortune/silk touch/crystallizing
    item_slots:
      - pickaxe
  category: digger
  full_name: <&7>XP Finder <context.level.to_roman_numerals>
  min_level: 1
  max_level: 7
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_pickaxe]>
  is_compatible: <context.enchantment_key.advanced_matches[minecraft:fortune|minecraft:silk_touch|denizen:crystallizing].not>
  treasure_only: true

xp_finder_enchant_handler:
  type: world
  debug: false
  events:
    on player breaks sandstone|stone|red_sandstone|andesite|granite|diorite|deepslate|endstone|tuff|dripstone_block with:item_enchanted:xp_finder:
      - ratelimit <player> 2t
      - stop if:<util.random_chance[<context.item.enchantment_map.get[xp_finder].mul[10]>].not>
      - determine passively NOTHING
      - determine passively <context.item.enchantment_map.get[xp_finder].mul[<util.random.int[1].to[3]>]>
      - playeffect at:<context.location> effect:sneeze quantity:30 offset:0.1,0.1,0.1
      - playsound <context.location> sound:entity_experience_orb_pickup volume:2.0 pitch:2.0
      - define slot <player.held_item_slot>
      - if <context.item.max_durability.sub[<context.item.durability>]> > 10:
        - inventory adjust slot:<[slot]> durability:<[slot].durability.add[10]>
        - stop
      - take slot:<[slot]>