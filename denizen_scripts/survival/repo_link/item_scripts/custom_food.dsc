custom_food_potato_soup:
  material: mushroom_stew
  debug: false
  display name: <&f>Potato Soup
  mechanisms:
    custom_model_data: 1
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: potato|potato|potato|custom_food_onion|bowl

custom_food_onion:
  material: beetroot
  debug: false
  display name: <&f>Onion
  mechanisms:
    custom_model_data: 1
  type: item

custom_food_rice:
  material: wheat
  debug: false
  display name: <&f>Rice
  mechanisms:
    custom_model_data: 1
  type: item

custom_food_berry_pie:
  material: pumpkin_pie
  debug: false
  display name: <&f>Berry Pie
  mechanisms:
    custom_model_data: 1
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: sweet_berries|sugar|egg

custom_food_apple_pie:
  material: pumpkin_pie
  debug: false
  display name: <&f>Apple Pie
  mechanisms:
    custom_model_data: 2
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: apple|sugar|egg|apple|apple

custom_food_carrot_cake:
  material: cake
  debug: false
  display name: <&f>Carrot Cake
  mechanisms:
    custom_model_data: 1
  type: item
  recipes:
    1:
      hide_in_recipebook: false
      type: shaped
      output_quantity: 1
      input:
      - milk_bucket|milk_bucket|milk_bucket
      - carrot|egg|carrot
      - wheat|wheat|wheat

custom_food_chocolate_cake:
  material: cake
  debug: false
  display name: <&f>Chocolate Cake
  mechanisms:
    custom_model_data: 2
  type: item
  recipes:
    1:
      hide_in_recipebook: false
      type: shaped
      output_quantity: 1
      input:
      - milk_bucket|milk_bucket|milk_bucket
      - cocoa_beans|egg|cocoa_beans
      - wheat|wheat|wheat

custom_food_honey_bun:
  material: bread
  debug: false
  display name: <&f>Honey Bun
  mechanisms:
    custom_model_data: 1
  type: item
  recipes:
    1:
      hide_in_recipebook: false
      type: shaped
      output_quantity: 1
      input:
      - air|honey_bottle|air
      - wheat|wheat|wheat
      - air|air|air
    2:
      hide_in_recipebook: false
      type: shaped
      output_quantity: 1
      input:
      - air|honey_bottle|air
      - air|bread|air
      - air|air|air
    3:
      hide_in_recipebook: false
      type: shaped
      output_quantity: 1
      input:
      - air|air|air
      - air|honey_bottle|air
      - air|bread|air
    4:
      hide_in_recipebook: false
      type: shaped
      output_quantity: 1
      input:
      - air|air|air
      - air|honey_bottle|air
      - wheat|wheat|wheat

custom_food_beef_stew:
  material: rabbit_stew
  debug: false
  display name: <&f>Beef Stew
  mechanisms:
    custom_model_data: 2
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: potato|carrot|beef|custom_food_onion|bowl

custom_food_sushi_cod:
  material: dried_kelp
  debug: false
  display name: <&f>Cod Sushi
  mechanisms:
    custom_model_data: 2
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: rice|dried_kelp|cod

custom_food_sushi_salmon:
  material: dried_kelp
  debug: false
  display name: <&f>Salmon Sushi
  mechanisms:
    custom_model_data: 3
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: rice|dried_kelp|salmon

custom_food_sushi_pufferfish:
  material: dried_kelp
  debug: false
  display name: <&f>Puffer Sushi
  mechanisms:
    custom_model_data: 4
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: rice|dried_kelp|pufferfish

custom_food_sushi_tropical:
  material: dried_kelp
  debug: false
  display name: <&f>Tropical Sushi
  mechanisms:
    custom_model_data: 5
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: rice|dried_kelp|tropical_fish

custom_food_sushi_mushroomred:
  material: dried_kelp
  debug: false
  display name: <&f>Red Mushroom Sushi
  mechanisms:
    custom_model_data: 6
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: rice|dried_kelp|red_mushroom

custom_food_sushi_mushroombrown:
  material: dried_kelp
  debug: false
  display name: <&f>Cod Sushi
  mechanisms:
    custom_model_data: 7
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: rice|dried_kelp|brown_mushroom

custom_food_sushi_veggie:
  material: dried_kelp
  debug: false
  display name: <&f>Veggie Sushi
  mechanisms:
    custom_model_data: 8
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: rice|dried_kelp|egg|carrot

custom_food_mutton_stew:
  material: rabbit_stew
  debug: false
  display name: <&f>Mutton Stew
  mechanisms:
    custom_model_data: 3
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: potato|carrot|mutton|custom_food_onion|bowl

Custom_food_events:
  type: world
  events:
    on player consumes custom_food_onion:
      - determine passively cancelled
      - actionbar "<&c>You can't eat a raw onion!"
    on player consumes custom_food_mutton_stew:
      - determine passively cancelled
      - take iteminhand
      - feed amount:12 saturation:8
    on player consumes custom_food_potato_soup:
      - determine passively cancelled
      - take iteminhand
      - feed amount:7.2 saturation:6
    on player consumes custom_food_beef_stew:
      - determine passively cancelled
      - take iteminhand
      - feed amount:8 saturation:12
    on player consumes custom_food_honey_bun:
      - determine passively cancelled
      - take iteminhand
      - feed amount:8 saturation:3
    on player consumes custom_food_apple_pie:
      - determine passively cancelled
      - take iteminhand
      - feed amount:6 saturation:7
    on player consumes custom_food_berry_pie:
      - determine passively cancelled
      - take iteminhand
      - feed amount:8 saturation:2
    on player consumes custom_food_sushi*:
      - determine passively cancelled
      - define sushi_type <player.item_in_hand.script.name.after_last[_]>
      - wait 1t
      - take iteminhand
      - choose <[sushi_type]>:
#TODO create food saturation values
        - case salmon:
          - feed amount:2 saturation:0.3
        - case cod:
          - feed amount:3 saturation:0.5
        - case puffer:
          - feed amount:2 saturation:0.6
          - define chance <util.random.int[0].to[10]>
          - if <[chance]> == 10:
            - cast HUNGER d:15s amplifier:2
            - cast POISON d:30s amplifier:<util.random.int[1].to[3]>
            - cast CONFUSION d:15s
        - case tropical:
          - feed amount:2 saturation:0.4
        - case mushroomred:
          - feed amount:3 saturation:0.6
        - case mushroombrown:
          - feed amount:2 saturation:0.9
        - case veggie:
          - feed amount:4 saturation:4

food_crate_handler:
  type: world
  debug: true
  events:
    on player right clicks block with:food_crate:
      - determine passively cancelled
      - if <player.inventory.empty_slots> < 5:
        - narrate "<&c>You must have at least 5 open inventory slots to unpack a food crate."
        - stop
      - if <player.has_flag[opening_food_crate]>:
        - narrate "<&c>Please finish opening your current Food Crate."
        - stop
      - else:
        - flag <player> opening_food_crate duration:30s
        - take iteminhand
        - define food_list <list[custom_food_mutton_stew|custom_food_potato_soup|custom_food_beef_stew|custom_food_honey_bun|custom_food_apple_pie|custom_food_berry_pie|custom_food_sushi_salmon|custom_food_sushi_cod|custom_food_sushi_puffer|custom_food_sushi_tropical|custom_food_sushi_mushroomred|custom_food_sushi_mushroombrown|custom_food_chocolate_cakecustom_food_carrot_cake|]>
        - repeat 5:
          - define food <[food_list].random>
          - give <[food]>
          - narrate "<&e>You unpacked a <item[custom_food_potato_soup].display><&e>."
          - playsound <player> sound:block_sand_hit sound_category:master pitch:0.5
          - wait <util.random.int[8].to[15]>t
        - flag <player> opening_food_crate:!

food_crate:
  type: item
  material: player_head
  mechanisms:
    skull_skin: 23c5b3f8-6ab5-464e-85e5-5c28ab9b893c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7ImlkIjoiZjk1NjQ0NTgwN2QwNDJjOWI0OThjMGQ1NzZkYmNkYjEiLCJ0eXBlIjoiU0tJTiIsInVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjRkYTgzMDYwOTJjYzU0YWNlZDYyY2UyNjNmZjFmNTc0YTFmODkwZWE1OGRjNDMwMzBiYTUwNzk3MjZiYWIzOSIsInByb2ZpbGVJZCI6IjY5YzUxMDg3ODAzYjQ4NDViZWYxMTZlMTJjN2VhMjI1IiwidGV4dHVyZUlkIjoiYjRkYTgzMDYwOTJjYzU0YWNlZDYyY2UyNjNmZjFmNTc0YTFmODkwZWE1OGRjNDMwMzBiYTUwNzk3MjZiYWIzOSJ9fSwic2tpbiI6eyJpZCI6ImY5NTY0NDU4MDdkMDQyYzliNDk4YzBkNTc2ZGJjZGIxIiwidHlwZSI6IlNLSU4iLCJ1cmwiOiJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2I0ZGE4MzA2MDkyY2M1NGFjZWQ2MmNlMjYzZmYxZjU3NGExZjg5MGVhNThkYzQzMDMwYmE1MDc5NzI2YmFiMzkiLCJwcm9maWxlSWQiOiI2OWM1MTA4NzgwM2I0ODQ1YmVmMTE2ZTEyYzdlYTIyNSIsInRleHR1cmVJZCI6ImI0ZGE4MzA2MDkyY2M1NGFjZWQ2MmNlMjYzZmYxZjU3NGExZjg5MGVhNThkYzQzMDMwYmE1MDc5NzI2YmFiMzkifSwiY2FwZSI6bnVsbH0=
  display name: <&b>Food Crate
  lore:
  - "<&e>Provides a heck of a meal!"

#TODO   Things needed to add:
#TODO   Turn 20 rotten flesh into leather (Not food, but eh)
#TODO   Berry Juice. Gives the berries more of a use. This will be a potion. Maybe add something with honey too?
#TODO   Sushi, fish need more uses. Salmon Cod Tropical Pufferfish, mushroom (small chance of poison, feeds more than pufferfish normally does.)
