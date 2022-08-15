enraging_enchantment:
  type: enchantment
  id: enraging
  debug: false
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Chance to aggravate enemies once attacked.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Enraging <context.level.to_roman_numerals>
  min_level: 1
  max_level: 5
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[sword|axe]>
  after attack:
  - ratelimit <player> 12t
  - stop if:<util.random_chance[<context.level.mul[10]>].not>
  - foreach <context.victim.location.find_entities[!player].within[<context.level.mul[10]>]> as:e:
    - if <[e].is_living> && <[e].exists>:
        - adjust <[e]> last_hurt_by:<player>
        - attack <[e]> target:<player>
