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
    on player consumes custom_food_mutton_stew:
      - determine passively cancelled
      - take iteminhand
      - feed amount:12 saturation:8
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
        - repeat 5:
          - define chance <util.random.int[1].to[8]>
          - choose <[chance]>:
            - case 1:
              - give custom_food_potato_soup
              - narrate "<&e>You unpacked a <item[custom_food_potato_soup].display><&e>."
            - case 2:
              - give custom_food_berry_pie
              - narrate "<&e>You unpacked a <item[custom_food_berry_pie].display><&e>."
            - case 3:
              - give custom_food_apple_pie
              - narrate "<&e>You unpacked a <item[custom_food_apple_pie].display><&e>."
            - case 4:
              - give custom_food_carrot_cake
              - narrate "<&e>You unpacked a <item[custom_food_carrot_cake].display><&e>."
            - case 5:
              - give custom_food_chocolate_cake
              - narrate "<&e>You unpacked a <item[custom_food_chocolate_cake].display><&e>."
            - case 6:
              - give custom_food_honey_bun
              - narrate "<&e>You unpacked a <item[custom_food_honey_bun].display><&e>."
            - case 7:
              - give custom_food_beef_stew
              - narrate "<&e>You unpacked a <item[custom_food_beef_stew].display><&e>."
            - case 8:
              - give custom_food_mutton_stew
              - narrate "<&e>You unpacked a <item[custom_food_mutton_stew].display><&e>."
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

# Things needed to add:
#   Turn 20 rotten flesh into leather (Not food, but eh)
#   Berry Juice. Gives the berries more of a use. This will be a potion. Maybe add something with honey too?
#   More soups. No one uses soups. But if there are more of them, then maybe they will.
