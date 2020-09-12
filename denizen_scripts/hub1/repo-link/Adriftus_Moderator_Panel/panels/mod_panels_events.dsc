# -- GLOBAL INVENTORY EVENTS --
mod_global_inv_events:
  type: world
  debug: false
  events:
    on player clicks item in mod_*_inv priority:10:
      - determine cancelled
    
    on player drags item in mod_*_inv priority:10:
      - determine cancelled

    on player clicks red_stained_glass_pane in mod_*_inv:
      - if <context.item.has_nbt[to]>:
        - choose <context.item.nbt[to]>:
          - case actions:
            - run mod_actions_inv_open
          - case online:
            - run mod_online_inv_open
          - default:
            - inventory close
