def create_item(material):
    file = f"""
uncompressed_{material}:
  type: item
  material: {material}
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_{material}
      output_quantity: 9

compressed_{material}:
  type: item
  material: {material}
  display name: <&f>{material.replace('_', ' ').title()}
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>9 {material.title()}"
  data:
    recipe_book_category: blocks.{material}1
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_{material}
      output_quantity: 9
    2:
      type: shaped
      input:
      - {material}|{material}|{material}
      - {material}|{material}|{material}
      - {material}|{material}|{material}

double_compressed_{material}:
  type: item
  material: {material}
  display name: <&f>Double Compressed {material.replace('_', ' ').title()}
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>81 {material}"
  data:
    recipe_book_category: blocks.{material}2
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_{material}
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_{material}|compressed_{material}|compressed_{material}
      - compressed_{material}|compressed_{material}|compressed_{material}
      - compressed_{material}|compressed_{material}|compressed_{material}

triple_compressed_{material}:
  type: item
  material: {material}
  display name: <&f>Triple Compressed {material.replace('_', ' ').title()}
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>729 {material}"
  data:
    recipe_book_category: blocks.{material}3
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_{material}
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_{material}|double_compressed_{material}|double_compressed_{material}
      - double_compressed_{material}|double_compressed_{material}|double_compressed_{material}
      - double_compressed_{material}|double_compressed_{material}|double_compressed_{material}

quadruple_compressed_{material}:
  type: item
  material: {material}
  display name: <&f>Quadruple Compressed {material.replace('_', ' ').title()}
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - "<&7>6561 {material}"
  data:
    recipe_book_category: blocks.{material}4
  flags:
    right_click_script: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_{material}|triple_compressed_{material}|triple_compressed_{material}
      - triple_compressed_{material}|triple_compressed_{material}|triple_compressed_{material}
      - triple_compressed_{material}|triple_compressed_{material}|triple_compressed_{material}
    """

    with open(f'output/compressed_{material}.dsc', 'w+') as f:
        f.write(file)


input_material = input(f'What material are you compressing: ')

create_item(input_material)