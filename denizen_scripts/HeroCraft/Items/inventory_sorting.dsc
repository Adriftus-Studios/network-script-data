inventory_sorting_events:
  type: world
  debug: true
  events:
    on player middle clicks in inventory:
    - if <context.clicked_inventory.exists>:
      - ratelimit <context.clicked_inventry> 1t
      - adjust <context.clicked_inventory> contents:<context.clicked_inventory.list_contents.alphabetical>