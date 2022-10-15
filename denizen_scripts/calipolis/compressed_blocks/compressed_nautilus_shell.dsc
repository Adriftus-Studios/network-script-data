uncompressed_nautilus_shell:
  type: item
  material: nautilus_shell
  no_id: true
  recipes:
    1:
      type: shapeless
      input: compressed_nautilus_shell
      output_quantity: 9

compressed_nautilus_shell:
  type: item
  material: nautilus_shell
  display name: <&f>Compressed Nautilus Shell
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>9 Nautilus Shell
  data:
    recipe_book_category: blocks.nautilus_shell1
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: double_compressed_nautilus_shell
      output_quantity: 9
    2:
      type: shaped
      input:
      - nautilus_shell|nautilus_shell|nautilus_shell
      - nautilus_shell|nautilus_shell|nautilus_shell
      - nautilus_shell|nautilus_shell|nautilus_shell

double_compressed_nautilus_shell:
  type: item
  material: nautilus_shell
  display name: <&f>Double Compressed Nautilus Shell
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>81 Nautilus Shell
  data:
    recipe_book_category: blocks.nautilus_shell2
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: triple_compressed_nautilus_shell
      output_quantity: 9
    2:
      type: shaped
      input:
      - compressed_nautilus_shell|compressed_nautilus_shell|compressed_nautilus_shell
      - compressed_nautilus_shell|compressed_nautilus_shell|compressed_nautilus_shell
      - compressed_nautilus_shell|compressed_nautilus_shell|compressed_nautilus_shell

triple_compressed_nautilus_shell:
  type: item
  material: nautilus_shell
  display name: <&f>Triple Compressed Nautilus Shell
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>729 Nautilus Shell
  data:
    recipe_book_category: blocks.nautilus_shell3
  flags:
    on_place: cancel
  recipes:
    1:
      type: shapeless
      input: quadruple_compressed_nautilus_shell
      output_quantity: 9
    2:
      type: shaped
      input:
      - double_compressed_nautilus_shell|double_compressed_nautilus_shell|double_compressed_nautilus_shell
      - double_compressed_nautilus_shell|double_compressed_nautilus_shell|double_compressed_nautilus_shell
      - double_compressed_nautilus_shell|double_compressed_nautilus_shell|double_compressed_nautilus_shell

quadruple_compressed_nautilus_shell:
  type: item
  material: nautilus_shell
  display name: <&f>Quadruple Compressed Nautilus Shell
  mechanisms:
    hides: ENCHANTS
  enchantments:
  - sharpness:1
  lore:
    - <&7>6561 Nautilus Shell
  data:
    recipe_book_category: blocks.nautilus_shell4
  flags:
    on_place: cancel
  recipes:
    1:
      type: shaped
      input:
      - triple_compressed_nautilus_shell|triple_compressed_nautilus_shell|triple_compressed_nautilus_shell
      - triple_compressed_nautilus_shell|triple_compressed_nautilus_shell|triple_compressed_nautilus_shell
      - triple_compressed_nautilus_shell|triple_compressed_nautilus_shell|triple_compressed_nautilus_shell