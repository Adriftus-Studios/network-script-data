honey_sticky_piston:
  type: item
  material: sticky_piston
  allow in material recipes: true
  no_id: true
  recipes:
    1:
      type: shaped
      input:
      - air|honey_block|air
      - air|piston|air
      - air|air|air

honey_sticky_piston_honey_block_display:
  type: item
  material: honey_block

honey_sticky_piston_slime_ball_display:
  type: item
  material: slime_ball

honey_sticky_piston_display:
  type: item
  material: sticky_piston
  data:
    recipe_book_category: blocks.a1
  recipes:
    1:
      type: shaped
      input:
      - air|honey_sticky_piston_slime_ball_display|air
      - air|piston|air
      - air|air|air
    2:
      type: shaped
      input:
      - air|honey_sticky_piston_honey_block_display|air
      - air|piston|air
      - air|air|air
