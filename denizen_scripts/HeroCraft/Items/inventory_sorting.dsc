inventory_sorting_events:
  type: world
  debug: true
  events:
    on player middle clicks in inventory:
    - if <context.clicked_inventory.exists>:
      - if <context.clicked_inventory.id_holder.object_type> == Location || <context.clicked_inventory.id_holder.object_type> == Player:
        - ratelimit <context.clicked_inventory> 1t
        - adjust <context.clicked_inventory> contents:<context.clicked_inventory.list_contents.exclude[<item[air]>].sort_by_value[material.name]>