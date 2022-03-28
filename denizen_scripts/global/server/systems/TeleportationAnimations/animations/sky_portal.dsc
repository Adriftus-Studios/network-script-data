teleportation_animation_sky_portal:
  type: data
  # Internal Name, MUST be unique
  name: sky_portal

  # Display Name for Icons
  display: <&6>Sky Portal

  # Material used in menus to represent the animation
  display_material: feather

  # Description for usage in item lore
  description:
  - "<&e>Rise into a portal"

  # Does the task take a color as input?
  colorable: true

  # The task for running the animation
  task: teleportation_animation_sky_portal_run


teleportation_animation_sky_portal_run:
  type: task
  debug: false
  definitions: destination|color
  script:
    - adjust <player> gravity:false
    - adjust <player> velocity:0,0.12,0
    - define portal_location <player.location.above[3.5]>
    - define targets <player.location.find_players_within[60]>
    - repeat 5:
      - playeffect at:<[portal_location]> offset:0.4 effect:redstone special_data:5|<[color]> quantity:30 targets:<[targets]>
      - wait 2t
    - repeat 10:
      - playeffect at:<[portal_location]> offset:0.4 effect:redstone special_data:5|<[color]> quantity:30 targets:<[targets]>
      - wait 2t
    - playeffect at:<[destination]> offset:1 effect:redstone special_data:5|<[color]> quantity:60 targets:<[targets]>
    - teleport <player> <[destination]>
    - adjust <player> gravity:true