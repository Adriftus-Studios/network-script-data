inventory_data_keys:
  type: world
  debug: false
  events:
    on player closes inventory:
      - if <context.inventory.script.data_key[data.on_close].exists>:
        - inject <context.inventory.script.data_key[data.on_close]>