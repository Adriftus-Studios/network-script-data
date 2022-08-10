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
  debug: false
  definitions: destination|color
  script:
    - define color white if:<[color].exists.not>
    - title title:<&color[#000000]><&font[adriftus:overlay]><&chr[1004]><&chr[F802]><&chr[1004]> fade_in:5t stay:10t fade_out:1.5s
    - repeat 5:
      - playeffect at:<player.location.above> offset:0.4 effect:redstone special_data:5|<[color]> quantity:20
      - wait 1t
    - playeffect at:<[destination].above> offset:0.4 effect:redstone special_data:5|<[color]> quantity:20
    - wait 1t
    - playeffect at:<[destination].above> offset:0.4 effect:redstone special_data:5|<[color]> quantity:20
    - teleport <player> <[destination]>