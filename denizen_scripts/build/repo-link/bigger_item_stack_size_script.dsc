
tin_ingot:
  material: iron_ingot
  display name: <&7>Tin Ingot
  type: item
  
custom_skewer:
  type: item
  material: stick
  display name: <&7>Skewer
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
        - air|air|air
        - air|air|tin_ingot
        - air|air|tin_ingot
  
reload_scripts:
    type: world
    reload:
      - yaml create id:server.recipe_fixer
      - adjust server reset_recipes
      - foreach <server.scripts>:
          - if <[value].data_key[type]> == item && <[value].data_key[recipes]||null> != null:
              - foreach <[value].list_keys[recipes]> as:recipe:
                - if <server.material_types.parse[name].contains[<[value].name.replace[custom_].with[]>]>:
                  - if <server.list_recipe_ids.contains[minecraft:<[value].name.replace[custom_].with[]>]>:
                    - yaml id:server.recipe_fixer set recipes:|:<[value].name>
                - if <[value].data_key[recipes.<[recipe]>.type]> == shaped:
                  - yaml id:server.recipe_fixer set restricted.shaped.<[value].data_key[recipes.<[recipe]>.input].as_list.separated_by[_].replace[|].with[_]>:|:<[value].name><&co><[value].data_key[recipes.<[recipe]>.output_quantity]>
                - if <[value].data_key[recipes.<[recipe]>.type]> == shapeless:
                  - yaml id:server.recipe_fixer set restricted.shapeless.<[value].data_key[recipes.<[recipe]>.input].as_list.alphabetical.separated_by[_]>:|:<[value].name><&co><[value].data_key[recipes.<[recipe]>.output_quantity]>
                - if <[value].data_key[recipes.<[recipe]>.type]> == furnace:
                  - yaml id:server.recipe_fixer set restricted.furnace.<[value].data_key[recipes.<[recipe]>.input]>:<[value].name><&co><[value].data_key[recipes.<[recipe]>.output_quantity]||1><&co><[value].data_key[recipes.<[recipe]>.cook_time]>
      - yaml id:server.recipe_fixer set recipes:<yaml[server.recipe_fixer].read[recipes].as_list.deduplicate>
    events:
      on server start:
        - inject locally reload
      on script reload:
        - inject locally reload
        
custom_item_override:
  type: world
  debug: false
  events:
    on player clicks in inventory:
      - if !<context.inventory.script_name.starts_with[recipe_book_]||false>:
        - if <context.slot> != -998:
          - if <player.open_inventory.inventory_type> == workbench:
            - wait 1t
            - if <yaml[server.recipe_fixer].read[restricted.shaped.<player.open_inventory.matrix.parse[script.name.to_lowercase||air].separated_by[_]>].first.as_item||null> != null:
              - define item:<yaml[server.recipe_fixer].read[restricted.shaped.<player.open_inventory.matrix.parse[script.name.to_lowercase||air].separated_by[_]>].first.as_item.with[quantity=<yaml[server.recipe_fixer].read[restricted.shaped.<player.open_inventory.matrix.parse[script.name.to_lowercase||air].separated_by[_]>].first.split[:].get[2]>]>
              - inject build_item
              - adjust <player.open_inventory> result:<[item]>
            - if <yaml[server.recipe_fixer].read[restricted.shapeless.<player.open_inventory.matrix.parse[script.name.to_lowercase].filter[is[!=].to[null]].separated_by[_]>].first.as_item||null> != null:
              - define item:<yaml[server.recipe_fixer].read[restricted.shapeless.<player.open_inventory.matrix.parse[script.name.to_lowercase].filter[is[!=].to[null]].separated_by[_]>].first.as_item.with[quantity=<yaml[server.recipe_fixer].read[restricted.shapeless.<player.open_inventory.matrix.parse[script.name.to_lowercase].filter[is[!=].to[null]].separated_by[_]>].first.split[:].get[2]>]>
              - inject build_item
              - adjust <player.open_inventory> result:<[item]>

build_item_command:
  type: command
  name: build_item
  script:
    - define item:<player.item_in_hand>
    - if <[item].material.name> == air:
      - narrate "You're not holding anything."
      - stop
    - inject build_item
    - inventory set d:<player.inventory> o:<[item]> slot:<player.held_item_slot.with[nbt=something/somevalue]>
    - narrate Done

build_item:
  type: task
  definitions: item
  script:
    - adjust def:item nbt:built/true
