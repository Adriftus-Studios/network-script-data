inventory_data_keys:
  type: world
  debug: false
  events:
    on player closes inventory:
      - if <context.inventory.script.data_key[data.on_close].exists>:
        - inject <context.inventory.script.data_key[data.on_close]>

    on player clicks in inventory bukkit_priority:HIGHEST ignorecancelled:true priority:-1:
      - if <context.inventory.script.data_key[data.any_click].exists>:
        - inject <context.inventory.script.data_key[data.any_click]>

    on player clicks in inventory bukkit_priority:HIGHEST ignorecancelled:true:
      - if <context.inventory.script.data_key[data.any_click].exists>:
        - inject <context.inventory.script.data_key[data.any_click]>
      - if <context.clicked_inventory.script.data_key[data.click_script_slots.<context.slot>].exists>:
        - inject <context.clicked_inventory.script.data_key[data.click_script_slots.<context.slot>]>
      - else if <context.clicked_inventory.script.data_key[data.clickable_slots.<context.slot>].exists>:
        - determine cancelled:false

    on player drags in inventory bukkit_priority:HIGHEST ignorecancelled:true:
      - if <context.clicked_inventory.script.data_key[data.on_drag].exists>:
        - inject <context.clicked_inventory.script.data_key[data.on_drag]>