thundering_enchantment:
  type: enchantment
  id: thundering
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Has a chance to cause lightning to strike near the enemy attacked.
      - <empty>
      - These strikes do not damage you.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Thundering <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
  after attack:
  - ratelimit <player> 12t
  - if <util.random.int[1].to[10]> > 9 && <context.victim.is_spawned>:
    - flag <player> temp.damage_immune_thunder expire:10t
    - define location <context.victim.location>
    - strike <[location]>
    - if <context.level> > 1:
      - wait 10t
      - repeat <context.level.sub[1]>:
        - flag <player> temp.damage_immune_thunder expire:10t
        - strike <[location].find.surface_blocks.within[3].random>
        - wait 10t
