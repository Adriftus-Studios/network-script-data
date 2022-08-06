Lifestealing_enchantment:
  type: enchantment
  id: Lifestealing
  debug: false
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Chance to steal 1.5 hearts per level over 3.5s
      - <empty>
      - Cannot be used with Vampirism or Radiance
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Lifestealing <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
  is_compatible: <context.enchantment_key.advanced_matches_text[denizen:vampirism|denizen:radiance].not>
  after attack:
