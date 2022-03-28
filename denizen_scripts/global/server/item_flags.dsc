item_flags:
  type: world
  debug: false
  events:
    on player clicks item_flagged:run_script in inventory bukkit_priority:LOWEST:
      - inject <context.item.flag[run_script]>
    on player clicks item_flagged:cancelled in inventory bukkit_priority:LOWEST:
      - determine cancelled
    on player drops item_flagged:no_drop bukkit_priority:LOWEST:
      - determine cancelled
    on player drops item_flagged:on_drop bukkit_priority:LOWEST:
      - inject <context.item.flag[on_drop]>
    on player dies:
      - determine <context.drops.filter[has_flag[no_drop_on_death].not]>
    on player right clicks block with:item_flagged:right_click_script:
      - if <context.item.flag[right_click_script].object_type> == List:
        - foreach <context.item.flag[right_click_script]>:
          - inject <[value]>
      - else:
        - inject <context.item.flag[right_click_script]>
