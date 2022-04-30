# -- GLOBAL INVENTORY EVENTS --
mod_global_inv_events:
  type: world
  debug: false
  events:
    on player clicks item in mod_*_inv priority:100:
      - determine cancelled

    on player drags item in mod_*_inv priority:100:
      - determine cancelled

    on player clicks item_flagged:to in mod_*_inv:
      - choose <context.item.flag[to]>:
        - case actions:
          - run mod_actions_inv_open
        - case online:
          - run mod_online_inv_open
        - default:
          - inventory close
