set_inventory:
  type: task
  debug: false
  definitions: target|inventory_map|enderchest_map
  script:
    - if <[target].last_played_time.year> == 1970:
      - flag server transferred_inventories.<[target].uuid>.inventory:<[inventory_map]>
      - flag server transferred_inventories.<[target].uuid>.enderchest:<[inventory_map]>
      - stop
    - if <[inventory_map].exists>:
      - inventory set o:<[inventory_map].with[54].as[air]> d:<[target].inventory>
    - if <[enderchest_map].exists>:
      - inventory set o:<[enderchest_map].with[54].as[air]> d:<[target].enderchest>

set_inventory_fix:
  type: world
  debug: false
  events:
    after player joins:
      - if <server.has_flag[transferred_inventories.<player.uuid>.inventory]>:
        - inventory set o:<server.flag[transferred_inventories.<player.uuid>.inventory].with[54].as[air]> d:<player.inventory>
        - flag server transferred_inventories.<player.uuid>.inventory:!
      - if <server.has_flag[transferred_inventories.<player.uuid>.enderchest]>:
        - inventory set o:<server.flag[transferred_inventories.<player.uuid>.enderchest].with[54].as[air]> d:<player.enderchest>
        - flag server transferred_inventories.<player.uuid>.enderchest:!
