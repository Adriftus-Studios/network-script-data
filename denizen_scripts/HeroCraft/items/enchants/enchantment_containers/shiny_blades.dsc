shiny_blades_enchantment:
  type: enchantment
  id: shiny_blades
  debug: false
  slots:
  - mainhand
  rarity: very_rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Creates some experience when shearing sheep or plucking chickens.
    item_slots:
      - shears
  category: breakable
  full_name: <&7>Shiny Blades <context.level.to_roman_numerals>
  min_level: 1
  max_level: 5
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: false
  can_enchant: <context.item.advanced_matches[shears]>


###This is also handles in plucking.dsc
shiny_blades_enchantment_handler:
    type: world
    debug: false
    events:
        after player shears entity:
            - stop if:<player.item_in_hand.enchantment_map.get[shiny_blades].exists.not>
            - drop xp <context.entity.location> quantity:<player.item_in_hand.enchantment_map.get[shiny_blades].mul[1.5].round_down>