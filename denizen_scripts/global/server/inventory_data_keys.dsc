inventory_data_keys:
  type: world
  debug: false
  events:
    on player closes inventory:
      - if <context.inventory.script.data_key[data.on_close].exists>:
        - inject <context.inventory.script.data_key[data.on_close]>

    on player clicks in inventory bukkit_priority:HIGHEST ignorecancelled:true:
      - if <context.inventory.script.data_key[data.click_script_slots.<context.slot>].exists>:
        - inject <context.inventory.script.data_key[data.click_script_slots.<context.slot>]>
      - else if <context.inventory.script.data_key[data.clickable_slots.<context.slot>].exists>:
        - determine cancelled:false