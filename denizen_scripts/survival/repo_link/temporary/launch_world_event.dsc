launch_world_quest_data:
  type: data
  materials:
    iron_ingot

launch_world_quest_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: Ender Offensive
  definitions:
    filler: <item[purple_stained_glass_pane].with[display_name=<&f>]>
    exit: "<item[barrier].with[display_name=<&c>Close GUI;nbt=action/close]>"
    coming_soon: "<item[red_stained_glass_pane].with[display_name=<&c>Coming Soon;nbt=action/close]>"
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [] [] [] [] [] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [coming_soon] [coming_soon] [coming_soon] [coming_soon] [coming_soon] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [coming_soon] [filler] [filler] [filler] [exit]

launch_world_quest_inventory_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[launch_world_quest_inventory]>
    - foreach
