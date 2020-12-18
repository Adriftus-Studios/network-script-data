vanilla_crafting_protection:
  type: world
  events:
    on player crafts item:
      - if <context.item.script.name||null> == null && !<context.recipe.filter[script.name.is[!=].to[null]].is_empty>:
        - determine cancelled
