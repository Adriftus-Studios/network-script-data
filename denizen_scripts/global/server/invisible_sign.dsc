invisible_sign:
  type: item
  debug: false
  material: warped_sign
  display name: <&f>Invisible Sign
  data:
    recipe_book_category: decor.sign
  recipes:
    1:
      type: shaped
      input:
        - material:warped_planks|material:warped_planks|material:warped_planks
        - material:warped_planks|material:warped_planks|material:warped_planks
        - air|material:stick|air

invisible_sign_events:
  type: world
  debug: false
  events:
    on server start:
      - adjust server remove_recipes:<item[warped_sign].recipe_ids>
    on player breaks warped_sign bukkit_priority:HIGHEST:
      - determine invisible_sign