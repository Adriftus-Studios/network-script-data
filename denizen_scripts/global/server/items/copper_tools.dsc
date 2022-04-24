copper_pickaxe:
  type: item
  material: iron_pickaxe
  display name: <&f>Copper Pickaxe
  mechanisms:
    custom_model_data: 2
  recipes:
    1:
      type: shaped
      input:
        - copper_ingot|copper_ingot|copper_ingot
        - air|stick|air
        - air|stick|air

copper_sword:
  type: item
  material: iron_sword
  display name: <&f>Copper Sword
  mechanisms:
    custom_model_data: 1
    1:
      type: shaped
      input:
        - air|copper_ingot|air
        - air|copper_ingot|air
        - air|stick|air