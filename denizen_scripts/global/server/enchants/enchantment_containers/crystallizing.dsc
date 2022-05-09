Crystallizing_enchantment:
  type: enchantment
  id: crystallizing
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[5]>
  data:
    effect:
      - Occasionaly turns basic stones into gems
      - <empty>
      - Costs extra durability to use. Incompatible with fortune/silk touch
    item_slots:
      - pickaxd
  category: digger
  full_name: <&7>Crystallizing <context.level.to_roman_numerals>
  min_level: 1
  max_level: 5
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_pickaxe]>
  is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:fortune|minecraft:silk_touch].not>
  treasure_only: true

crystallizing_enchant_handler:
  type: world
  debug: false
  events:
    on player breaks sandstone|stone|red_sandstone|andesite|granite|diorite|deepslate|endstone|tuff|dripstone_block with:item_enchanted:crystallizing:
      - ratelimit <player> 2t
      - if <util.random.int[0].to[100].add[<player.item_in_hand.enchantment_map.get[crystallizing]>]> < 100 || <player.has_flag[custom_enchantment.crystallized_recently]>:
        - stop
      - define item <list[diamond|emerald|redstone_dust|lapis_lazuli|glass|glowstone_dust].random>
      - determine <[item]>
      - flag <player> custom_enchantment.crystallized_recently expire:1200t
      - define slot <player.held_item_slot>
      - if <context.item.max_durability.sub[<context.item.durability>]> > 10:
        - inventory adjust slot:<[slot]> durability:<[slot].durability.add[10]>
        - stop
      - take slot:<[slot]>
