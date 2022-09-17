Slaying_enchantment:
  type: enchantment
  id: Slaying
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Deals 2.5 damage per level to rare monsters.
      - <empty>
      - Cannot be used with Banes, Sharpness, or Smite.
    item_slots:
      - all_weapons
  category: breakable
  full_name: <&7>Slaying <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_sword|*_axe|bow|crossbow|trident]>
  is_compatible: <context.enchantment_key.advanced_matches[minecraft:bane_of_arthropods|denizen:lifesbane|minecraft:sharpness|minecraft:smite|denizen:aqua_aspect].not>
  after attack:
  - ratelimit <player> 12t
  - if <context.victim.has_flag[rare]> && <context.victim.is_spawned>:
    - hurt <context.victim> <context.level.mul[2.5]>
