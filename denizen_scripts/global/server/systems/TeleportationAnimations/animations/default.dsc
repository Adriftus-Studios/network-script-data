teleportation_animation_default:
  type: data
  # Internal Name, MUST be unique
  name: default

  # Display Name for Icons
  display: <&7>Default

  # Material used in menus to represent the animation
  display_material: gunpowder

  # Description for usage in item lore
  description:
  - "<&e>Default Teleportation Animation. Poof!"

  # Does the task take a color as input?
  colorable: true

  # The task for running the animation
  task: teleportation_animation_default_run


teleportation_animation_default_run:
  type: task
  debug: true
  definitions: destination|color
  script:
    - repeat 5:
      - playeffect at:<player.location.above> offset:0.4 effect:redstone special_data:5|<[color]> quantity:20
      - wait 1t
    - playeffect at:<[destination].above> offset:0.4 effect:redstone special_data:5|<[color]> quantity:20
    - wait 1t
    - playeffect at:<[destination].above> offset:0.4 effect:redstone special_data:5|<[color]> quantity:20
    - teleport <player> <[destination]>