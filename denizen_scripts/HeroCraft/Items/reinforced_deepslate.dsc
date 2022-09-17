reinforced_deepslate_recipe:
  type: item
  material: reinforced_deepslate
  data:
    recipe_book_category: blocks.1reinforced_deepslate0
  recipes:
    1:
      type: shaped
      input:
      - compressed_obsidian|compressed_obsidian|compressed_obsidian
      - compressed_obsidian|triple_compressed_deepslate|compressed_obsidian
      - compressed_obsidian|compressed_obsidian|compressed_obsidian

reinforced_deepslate_events:
  type: world
  debug: false
  events:
    on player breaks reinforced_deepslate with:netherite_pickaxe:
    - if <player.gamemode.equals[survival]> && <player.item_in_hand.enchantments.contains[silk_touch]>:
      - drop reinforced_deepslate_recipe <context.location.center>