# -- GLOBAL INVENTORY EVENTS --
mod_global_inv_events:
  type: world
  debug: false
  events:
    on player clicks item in mod_*_inv priority:10:
      - determine cancelled

    on player drags item in mod_*_inv priority:10:
      - determine cancelled

    on player clicks item_flagged:to in mod_*_inv:
      - choose <context.item.flag[to]>:
        # System-wide
        - case actions:
          - run mod_actions_inv_open
        - case online:
          - run mod_online_inv_open
        # Inventory
        - case inventory:
          - run mod_inventory_inv_open
        - case enderchest:
          - run mod_ender_chest_inv_open
        - case adriftuschest:
          - run mod_adriftus_chest_inv_open
        # Close
        - default:
          - inventory close
    # DEBUG
    on player closes mod_*_inv:
      - narrate "Closed <context.inventory>"
