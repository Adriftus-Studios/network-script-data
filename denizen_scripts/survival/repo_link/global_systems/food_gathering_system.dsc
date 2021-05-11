custom_seed_onion:
  type: item
  material: beetroot_seeds
  debug: false
  display name: <&f>Onion Seeds
  recipes:
    1:
      type: shapeless
      output_quantity: 3
      hide_in_recipebook: false
      input: custom_food_onion

custom_gathering_handler:
  type: world
  debug: false
  events:
    on player breaks grass bukkit_priority:HIGH:
    - if <util.random.int[1].to[100]> <= 10:
      - define type <list[onion|rice].random>
      - drop custom_food_<[type]> <context.location>

onion_planting_handler:
  type: world
  debug: false
  events:
    on player right clicks farmland with:custom_seed_onion:
    - flag <context.location.add[0,1,0]> custom_planted.onions
    on player breaks beetroots:
    - if !<context.location.has_flag[custom_planted.onions]>:
      - stop
    - else if <context.location.material.age> == <context.location.material.maximum_age>:
      - flag <context.location> custom_planted:!
      - determine custom_food_onion|custom_seed_onion[quantity=<util.random.int[1].to[4]>]

custom_seed_rice:
  type: item
  material: wheat_seeds
  debug: false
  display name: <&f>Rice Seeds
  recipes:
    1:
      type: shapeless
      output_quantity: 2
      hide_in_recipebook: false
      input: custom_food_rice

rice_planting_handler:
  type: world
  debug: false
  events:
    on player right clicks farmland with:custom_seed_rice:
    - flag <context.location.add[0,1,0]> custom_planted.rice
    on player breaks wheat:
    - if !<context.location.has_flag[custom_planted.rice]>:
      - stop
    - else if <context.location.material.age> == <context.location.material.maximum_age>:
      - flag <context.location> custom_planted:!
      - determine custom_food_rice[quantity=<util.random.int[1].to[2]>]|custom_seed_rice[quantity=<util.random.int[0].to[2]>]
