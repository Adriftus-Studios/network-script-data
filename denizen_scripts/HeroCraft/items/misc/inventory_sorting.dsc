inventory_sorting_events:
  type: world
  debug: true
  events:
    on player clicks in inventory:
      - narrate test if:<context.click.equals[MIDDLE]>
      - if <context.clicked_inventory.exists> && <context.clicked_inventory.id_holder.object_type> == Location:
        - ratelimit <context.clicked_inventory> 1t
        - adjust <context.clicked_inventory> contents:<context.clicked_inventory.list_contents.exclude[<item[air]>].sort_by_value[material.name]>