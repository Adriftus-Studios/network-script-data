empty_xp_vessel_level_5:
  material: glass_bottle
  debug: false
  display name: <&f>Empty Experience Vessel
  type: item
  mechanisms:
    nbt: vessel_capacity/55|vessel_level/5
  lore:
    - <&d>Will store 55 XP (level 0-5) when used.
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
    nbt: vessel_capacity/55|vessel_level/5
  lore:
    - <&d>Will give 55 XP (level 0-5) when used.

vessel_handler:
  type: world
  debug: true
  events:
    on player right clicks block with:empty_xp_vessel_level_*:
      - determine passively cancelled
      - if <player.has_flag[bottle_fill_lockout]>:
        - actionbar "<&4>Please wait a moment before using this item."
        - stop
      - define vessel_capacity <context.item.nbt[vessel_capacity]>
      - define vessel_level <context.item.nbt[vessel_level]>
      - if <player.xp_total> < <[vessel_capacity]>:
        - actionbar "<&4>You need at least <[vessel_level]> levels of experience in order to use this item"
        - stop
      - take xp quantity:<[vessel_capacity]>
      - take <context.item>
      - give filled_xp_vessel_level_<[vessel_level]>
      - playsound sound:BLOCK_BEACON_ACTIVATE <player>
      - itemcooldown glass_bottle duration:1s
      - itemcooldown experience_bottle duration:1s
      - flag <player> bottle_fill_lockout duration:1s
    on player right clicks block with:filled_xp_vessel_level_*:
      - determine passively cancelled
      - if <player.has_flag[bottle_fill_lockout]>:
        - actionbar "<&4>Please wait a moment before using this item."
        - stop
      - define vessel_capacity <context.item.nbt[vessel_capacity]>
      - define vessel_level <context.item.nbt[vessel_level]>
      - take <context.item>
      - give xp quantity:<[vessel_capacity]>
      - playsound sound:entity_generic_drink <player>
      - itemcooldown experience_bottle duration:1s
      - flag <player> bottle_fill_lockout duration:1s
