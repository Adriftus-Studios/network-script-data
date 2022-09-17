Lifesbane_enchantment:
  type: enchantment
  id: lifesbane
  debug: false
  slots:
  - mainhand
  rarity: common
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Deals 2.5 damage per level to living humanoids.
      - <empty>
      - Cannot be used with Banes, Slaying, Sharpness, or Smite.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Lifesbane <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
  is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:bane_of_arthropods|denizen:slaying|minecraft:sharpness|minecraft:smite|denizen:aqua_aspect].not>
  after attack:
    - ratelimit <player> 12t
    - if <context.victim.is_spawned> && <list[piglin|piglin_brute|pillager|evoker|vindicator|player|villager|illusioner].contains_any[<context.victim.entity_type>]>:
      - hurt <context.victim> <context.level.mul[2.5]>
