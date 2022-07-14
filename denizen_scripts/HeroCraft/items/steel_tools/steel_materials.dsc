steel_ingot:
  type: item
  material: iron_ingot
  display name: <&r>Steel Ingot
  mechanisms:
    custom_model_data: 1
  lore:
    - Its like iron with more carbon,
  data:
      recipe_book_category: misc.steel.ingot
  recipes:
    1:
      type: furnace
      cook_time: 120s
      experience: 0.25
      input: raw_steel
    2:
      type: blast
      cook_time: 60s
      experience: 0.15
      input: raw_steel

raw_steel:
  type: item
  material: raw_iron
  display name: <&r>Raw Steel
  lore:
    - Mixed and ready for smelting.
  mechanisms:
    custom_model_data: 1
  data:
      recipe_book_category: misc.steel_ore
  recipes:
    1:
      type: shapeless
      input: raw_iron|coal/charcoal|coal/charcoal|raw_iron
