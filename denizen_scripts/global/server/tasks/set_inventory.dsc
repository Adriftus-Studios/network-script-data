set_inventory:
  type: task
  debug: false
  definitions: target|inventory_map
  script:
    - inventory set o:<[inventory_map].with[54].as[air]> d:<[target].inventory>