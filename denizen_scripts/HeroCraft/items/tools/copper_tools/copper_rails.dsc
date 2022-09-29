copper_rails:
  type: item
  material: rail
  no_id: true
  recipes:
    1:
      type: shaped
      output_quantity: 16
      input:
      - hardened_hardened_copper_ingot|air|hardened_copper_ingot
      - hardened_hardened_copper_ingot|stick|hardened_copper_ingot
      - hardened_hardened_copper_ingot|air|hardened_copper_ingot
  data:
      recipe_book_category: travel.hardened_copper.rail


copper_activator_rails:
  type: item
  material: activator_rail
  no_id: true
  recipes:
    1:
      type: shaped
      output_quantity: 6
      input:
      - hardened_hardened_copper_ingot|stick|hardened_copper_ingot
      - hardened_hardened_copper_ingot|redstone_torch|hardened_copper_ingot
      - hardened_hardened_copper_ingot|stick|hardened_copper_ingot
  data:
      recipe_book_category: travel.hardened_copper.rail2

copper_detector_rails:
  type: item
  material: detector_rail
  no_id: true
  recipes:
    1:
      type: shaped
      output_quantity: 6
      input:
      - hardened_copper_ingot|air|hardened_copper_ingot
      - hardened_copper_ingot|stone_pressure_plate|hardened_copper_ingot
      - hardened_copper_ingot|redstone|hardened_copper_ingot
  data:
      recipe_book_category: travel.hardened_copper.rail3

copper_powered_rails:
  type: item
  material: rail
  no_id: true
  recipes:
    1:
      type: shaped
      output_quantity: 6
      input:
      - hardened_copper_ingot|air|hardened_copper_ingot
      - hardened_copper_ingot|stick|hardened_copper_ingot
      - hardened_copper_ingot|redstone|hardened_copper_ingot
  data:
      recipe_book_category: travel.hardened_copper.rail4
