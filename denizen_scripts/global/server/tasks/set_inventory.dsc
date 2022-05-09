set_inventory:
  type: task
  debug: false
  definitions: target|inventory_map|enderchest_map
  script:
    - if <[inventory_map].exists>:
      - inventory set o:<[inventory_map].with[54].as[air]> d:<[target].inventory>
    - if <[enderchest_map].exists>:
      - inventory set o:<[enderchest_map].with[54].as[air]> d:<[target].enderchest>
