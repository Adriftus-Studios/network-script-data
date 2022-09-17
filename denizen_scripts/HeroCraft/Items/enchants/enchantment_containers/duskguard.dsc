Duskguard_enchantment:
  type: enchantment
  id: Duskguard
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Deals 3 damage/level during nighttime
      - <empty>
      - Cannot be combined with Dawnguard
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Duskguard <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
  is_compatible: <context.enchantment_key.advanced_matches_text[denizen:Duskguard].not>
  after attack:
    - ratelimit <player> 12t
    - if <context.victim.is_spawned> && <player.location.world.time> > 12786:
      - hurt <context.victim> <context.level.mul[3]>
