hub_recipe_remover:
  type: world
  debug: false
  events:
    on server start:
      - wait 1s
      - adjust server remove_recipes:<server.recipe_ids>