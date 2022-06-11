saved_inventory_load:
  type: task
  debug: false
  definitions: name
  script:
    - define current_inventory <player.flag[saved_inventory.current].if_null[default]>
    - stop if:<[current_inventory].equals[<[name]>]>
    - flag player saved_inventory.<[current_inventory]>:<player.inventory.map_slots.with[54].as[air]>
    - if <player.has_flag[saved_inventory.<[name]>]>:
      - inventory set o:<player.flag[saved_inventory.<[name]>]> d:<player.inventory>
    - else:
      - inventory clear d:<player.inventory>
    - flag <player> saved_inventory.current:<[name]>