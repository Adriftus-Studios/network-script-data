player_crafting_slots_override_events:
  type: world
  debug: false
  data:
    #test#
    items:
      - "paper[custom_model_data=301;display=<&b>Menu;flag=run_script:|:<list[cancel_in_minigame|player_crafting_slots_open_button]>;flag=on_drop:cancel;flag=grid_script:main_menu_inventory_open;flag=no_drop_on_death:true]"
      - "paper[custom_model_data=303;display=<&a>Travel;flag=run_script:|:<list[cancel_in_minigame|player_crafting_slots_open_button]>;flag=on_drop:cancel;flag=grid_script:travel_menu_open;flag=no_drop_on_death:true]"
      - "paper[custom_model_data=300;display=<&6>Adriftus Chest;flag=run_script:|:<list[cancel_in_minigame|player_crafting_slots_open_button]>;flag=on_drop:cancel;flag=grid_script:adriftus_chest_inventory_open;flag=no_drop_on_death:true]"
      - "paper[custom_model_data=302;display=<&e>Crafting Table;flag=run_script:|:<list[cancel_in_minigame|player_crafting_slots_open_button]>;flag=on_drop:cancel;flag=grid_script:open_crafting_grid;flag=no_drop_on_death:true]"
    set_inv:
      - if <player.inventory> != <player.open_inventory>:
        - wait 1t
      - stop if:<player.inventory.equals[<player.open_inventory>].not>
      - define inv <player.open_inventory>
      - repeat 5:
        - inventory set slot:<[value]> o:air d:<[inv]>
      - wait 1t
      - stop if:<player.is_online.not>
      - foreach <script.data_key[data.items]>:
        - inventory set slot:<[loop_index].add[1]> o:<[value].parsed> d:<[inv]>
      - wait 1t
      - inventory set slot:1 o:player_crafting_slots_<bungee.server> d:<[inv]>
      - take flagged:grid_script quantity:999
      - inventory update
  events:
    after player joins:
      - inject locally path:set_inv
    on player closes inventory:
      - inject locally path:set_inv
    on player dies bukkit_priority:LOWEST:
      - inventory close
      - inventory clear d:<player.open_inventory>
    on player teleports:
      - inventory close
      - inject locally path:set_inv
    on player uses recipe book:
      - if <player.open_inventory.slot[3].material.name> == stone:
        - determine cancelled
    on player respawns:
      - inject locally path:set_inv

player_crafting_slots_open_button:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - define script <context.item.flag[grid_script]>
    - wait 2t
    - inject <[script]>

player_crafting_slots_herocraft:
  type: item
  material: paper
  display name: <&b>Herocraft
  lore:
    - <&e>Herocraft Specific Stuff!
  flags:
    run_script: player_crafting_slots_open_button
    grid_script: missions_inv_open
  mechanisms:
    custom_model_data: 202

player_crafting_slots_calipolis:
  type: item
  material: paper
  display name: <&1>Calipolis
  lore:
    - <&e>Calipolis Specific Stuff!
  flags:
    run_script: cancel
  mechanisms:
    custom_model_data: 203

player_crafting_slots_test:
  type: item
  material: paper
  display name: <&7>Test
  lore:
    - <&e>Test Specific Stuff!
  flags:
    run_script: cancel
  mechanisms:
    custom_model_data: 209

player_crafting_slots_build:
  type: item
  material: paper
  display name: <&a>Build
  lore:
    - <&e>Build Specific Stuff!
  flags:
    run_script: cancel
  mechanisms:
    custom_model_data: 208

player_crafting_slots_hub:
  type: item
  material: paper
  display name: <&6>Hub
  lore:
    - <&e>Hub Specific Stuff!
  flags:
    run_script: cancel
  mechanisms:
    custom_model_data: 201