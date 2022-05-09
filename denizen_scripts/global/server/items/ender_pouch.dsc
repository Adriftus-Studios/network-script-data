ender_pouch:
  type: item
  debug: false
  material: feather
  display name: <&d>Ender Pouch
  lore:
    - "<&b>Access your Ender Chest!"
  flags:
    right_click_script: ender_pouch_open
  mechanisms:
    custom_model_data: 50

ender_pouch_open:
  type: task
  debug: false
  script:
    - inventory open d:<player.enderchest>