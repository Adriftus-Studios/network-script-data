Soulbound_enchantment:
  type: enchantment
  id: Soulbound
  debug: false
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[2]>
  max_cost: <context.level.mul[3]>
  data:
    effect:
      - Prevents this item from dropping when you die.
      - <empty>
      - Will lose one level each time it takes effect.
    item_slots:
      - anything
  category: breakable
  full_name: <&7>Soulbound <context.level.to_roman_numerals>
  min_level: 1
  max_level: 5
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*]>
  is_compatible: <context.enchantment_key.advanced_matches_text[denizen:soulbound].not>
