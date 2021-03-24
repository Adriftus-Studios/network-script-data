Onion_gathering_handler:
  type: world
  debug: false
  events:
    on player right clicks farmland with:custom_seed_onion:
    - flag <context.location.add[0,1,0]> onions_planted
    on player breaks grass bukkit_priority:HIGH:
    - if <util.random.int[1].to[100]> <= 10:
      - drop custom_food_onion <context.location>
    on player breaks beetroots:
    - if !<context.location.has_flag[onions_planted]>:
      - stop
    - else if <context.location.material.age> == <context.location.material.maximum_age>:
      - flag <context.location> onions_planted:!
      - determine custom_food_onion|custom_seed_onion[quantity=<util.random.int[1].to[4]>]
    - else:
      - determine nothing


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
