custom_food_potato_soup:
  material: mushroom_stew
  debug: false
  display name: <&f>Potato Soup
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
  type: item

custom_food_berry_pie:
  material: pumpkin_pie
  debug: false
  display name: <&f>Berry Pie
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


custom_food_honey_bun:
  material: bread
  debug: false
  display name: <&f>Honey Bun
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
  material: mushroom_stew
  debug: false
  display name: <&f>Beef Stew
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: potato|carrot|beef|custom_food_onion|bowl

custom_food_mutton_stew:
  material: mushroom_stew
  debug: false
  display name: <&f>Beef Stew
  type: item
  recipes:
    1:
      type: shapeless
      output_quantity: 1
      hide_in_recipebook: false
      input: potato|carrot|mutton|custom_food_onion|bowl
# Things needed to add:
#   Turn 20 rotten flesh into leather (Not food, but eh)
#   Berry Juice. Gives the berries more of a use. This will be a potion. Maybe add something with honey too?
#   More soups. No one uses soups. But if there are more of them, then maybe they will.
