custom_item_phantom_breath:
  type: item
  debug: false
  material: paper
  mechanisms:
    custom_model_data: 4
  display name: <&e>Phantom's Breath
  lore:
  - '<&6>The last gasp of a miniature dragon'
  - '<&6>Combine <&e>four<&6> for a Dragon<&sq>s Breath'

dragon_breath_recipe:
  type: item
  debug: false
  material: dragon_breath
  recipes:
    1:
        type: shapeless
        input: custom_item_phantom_breath|custom_item_phantom_breath|custom_item_phantom_breath|custom_item_phantom_breath
