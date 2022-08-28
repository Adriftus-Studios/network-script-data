display_shop_block:
  type: item
  debug: false
  material: end_portal_frame
  display name: <&b><&l>Display Shop
  lore:
  - <empty>
  - <&a>Place <&7>to create a new empty shop.
  data:
    recipe_book_category: gadgets.shop
  no_id: true
  recipes:
    1:
      type: shaped
      input:
      - glass|ender_eye|glass
      - steel|gold|steel
      - double_compressed_obsidian|double_compressed_obsidian|double_compressed_obsidian

display_shop_block_fix:
  type: world
  debug: false
  events:
    on display_shop_block recipe formed:
      - determine <server.flag[display_shop_block]>