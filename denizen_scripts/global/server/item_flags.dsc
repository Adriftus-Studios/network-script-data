item_flags:
  type: world
  debug: false
  events:
    on player clicks item_flagged:run_script in inventory bukkit_priority:LOWEST:
      - inject <context.item.flag[run_script]>
    on player clicks item_flagged:cancelled in inventory bukkit_priority:LOWEST:
      - determine cancelled