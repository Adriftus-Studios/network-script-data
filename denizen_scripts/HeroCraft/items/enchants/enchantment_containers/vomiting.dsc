vomiting_enchantment:
  type: enchantment
  id: vomiting
  debug: false
  slots:
  - mainhand
  rarity: very_rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Could make you vomit sometimes.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Vomiting <context.level.to_roman_numerals>
  min_level: 1
  max_level: 1
  treasure_only: true
  is_curse: true
  is_tradable: false
  is_discoverable: false
  can_enchant: <context.item.advanced_matches[sword|axe]>
  after attack:
  - ratelimit <player> 12t
  - execute as_server "brew puke <player.name>"