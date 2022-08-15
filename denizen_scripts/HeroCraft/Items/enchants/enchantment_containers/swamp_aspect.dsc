swamp_enchantment:
  type: enchantment
  id: swamp
  debug: false
  slots:
  - mainhand
  rarity: common
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Uses slimeballs from the inventory to deal additional damage.
      - <empty>
      - Cannot be used with Banes, Slaying, Sharpness, Smite, or Aqua Aspect.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Swamp Aspect <context.level.to_roman_numerals>
  min_level: 1
  max_level: 5
  is_tradable: false
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
  is_compatible: <context.enchantment_key.advanced_matches[minecraft:bane_of_arthropods|denizen:slaying|minecraft:sharpness|minecraft:smite|denizen:lifesbane|denizen:aqua_aspect|minecraft:fire_aspect].not>
  after attack:
    - ratelimit <player> 12t
    - stop if:<util.random_chance[<context.level.mul[10]>]>
    - if <player.inventory.contains_item[slime_ball]>:
        - take item:slime_ball quantity:1 from:<player.inventory>
        - hurt <context.level.mul[1.5].round_down> <context.victim> source:<player>
        - playeffect at:<context.victim.location> effect:item_crack special_data:slime_ball quantity:50 offset:1,1,1
        - playsound <context.victtim.location> sound:block_slime_block_place volume:2.0 pitch:0.5
