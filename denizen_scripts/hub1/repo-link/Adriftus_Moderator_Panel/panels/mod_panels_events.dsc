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
            - inventory open d:mod_actions_inv
          - case online:
            - inventory open d:mod_online_inv
          - default:
            - inventory close
