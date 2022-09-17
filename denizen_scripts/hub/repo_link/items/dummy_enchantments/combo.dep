combo_enchantment:
  type: enchantment
  id: combo
  debug: false
  slots:
  - mainhand
  rarity: common
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Repeated attacks to a target do 1 damage per level per attack.
      - <empty>
      - Stacks up to 2x your enchantment level.
    item_slots:
      - sword
      - axe
      - bows
      - crossbows
  category: breakable
  full_name: <&7>Combo <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_sword|*_axe|bow|crossbow]>
  after attack:
  - ratelimit <player> 12t
  - define victim <context.victim>
  - stop if:<[victim].is_spawned.not>
  - if !<player.has_flag[temp.custom_enchant_combo]> || <context.victim> != <player.flag[combo_target].if_null[rip]>:
    - flag <player> temp.custom_enchant_combo:1 expire:5s
    - flag <player> combo_target:<context.victim> expire:5s
    - stop
  - if <player.flag[temp.custom_enchant_combo]> < <context.level.mul[2]>:
    - flag <player> temp.custom_enchant_combo:++ expire:5s
    - flag <player> combo_target:<context.victim> expire:5s
  - flag <player> temp.custom_enchant_combo:<player.flag[temp.custom_enchant_combo]> expire:5s
  - flag <player> combo_target:<context.victim> expire:5s
  - hurt <player.flag[temp.custom_enchant_combo].mul[<context.level>]> <[victim]>
