empty_xp_vessel_level_5:
  material: glass_bottle
  debug: false
  display name: <&f>Empty Experience Vessel
  type: item
  mechanisms:
    nbt: vessel_capacity/85|vessel_level/5
  lore:
    - <&d>Will store 5 levels of experience when filled.
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: glass_bottle|gold_nugget|gold_nugget|gold_nugget|gold_nugget|gold_nugget

filled_xp_vessel_level_5:
  material: experience_bottle
  debug: false
  display name: <&f>Filled Experience Vessel
  type: item
  mechanisms:
    nbt: vessel_capacity/85|vessel_level/5
  lore:
    - <&d>Contains 5 levels worth of experience.

vessel_handler:
  type: world
  debug: true
  events:
    on player right clicks with:empty_xp_vessel_level_*:
      - ratelimit player 40t
      - define vessel_capacity <context.item.nbt[vessel_capacity]>
      - define vessel_level <context.item.nbt[vessel_level]>
      - if <player.xp_total> < <[vessel_capacity]>:
        - narrate "<&c>You need at least <[vessel_level]> levels of experience in order to use this item"
        - stop
      - take xp quantity:<[vessel_capacity]>
      - take <context.item>
      - give filled_xp_vessel_level_<[vessel_level]>
      - playsound sound:BLOCK_BEACON_ACTIVATE <player>
    on player right clicks with:filled_xp_vessel_level_*:
      - determine passively cancelled
      - ratelimit player 40t
      - define vessel_capacity <context.item.nbt[vessel_capacity]>
      - define vessel_level <context.item.nbt[vessel_level]>
      - take <context.item>
      - give xp quantity:<[vessel_capacity]>
      - playsound sound:entity_generic_drink <player>
