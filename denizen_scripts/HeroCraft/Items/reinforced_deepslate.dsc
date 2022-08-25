reinforced_deepslate_recipe:
  type: item
  material: reinforced_deepslate
  no_id: true
  data:
    recipe_book_category: blocks.reinforced_deepslate0
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
    - if <player.gamemode.equals[survival]>:
      - drop reinforced_deepslate <context.location.center>