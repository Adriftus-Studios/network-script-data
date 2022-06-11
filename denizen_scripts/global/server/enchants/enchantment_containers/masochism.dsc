masochism_enchantment:
  type: enchantment
  id: masochism
  debug: false
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[2]>
  max_cost: <context.level.mul[3]>
  data:
    effect:
      - Attacking drains 1 life per level per stack.
      - <empty>
      - At 4 stacks, they are channeled into 7x damage.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Masochism <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
  after attack:
  - ratelimit <player> 12t
  - if !<context.victim.is_spawned>:
    - stop
  - if !<player.has_flag[temp.custom_enchant_masochism]>:
    - hurt <player> <context.level> cause:void
    - flag <player> temp.custom_enchant_masochism:1 expire:5s
    - stop
  - if <player.has_flag[temp.custom_enchant_masochism]> && <player.flag[temp.custom_enchant_masochism]> < 4:
    - flag <player> temp.custom_enchant_masochism:++ expire:5s
    - hurt <player> <context.level> cause:void
    - playeffect <player.location> effect:villager_angry quantity:<player.flag[temp.custom_enchant_masochism].mul[<context.level>]>
    - stop
  - if <player.flag[temp.custom_enchant_masochism]> == 4:
    - playeffect effect:damage_indicator quantity:<context.level.mul[2]> <context.victim.location>
    - flag <player> temp.custom_enchant_masochism:!
    - hurt <context.victim> <context.level.mul[7]> cause:void
