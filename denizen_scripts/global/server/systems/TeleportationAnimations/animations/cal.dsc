teleportation_animation_cal:
  type: data
  # Internal Name, MUST be unique
  name: cal

  # Display Name for Icons
  display: <&6>Caleope

  # Material used in menus to represent the animation
  display_material: dirt

  # Description for usage in item lore
  description:
  - "<&e>Caleope's Teleportation"

  # Does the task take a color as input?
  colorable: false

  # The task for running the animation
  task: teleportation_animation_cal_run


teleportation_animation_cal_run:
  type: task
  debug: false
  definitions: destination|color
  script:
    - define foot_location <player.location>
    - define targets <player.location.find_players_within[60]>
    - spawn falling_block[gravity=false;fallingblock_type=oak_log] <player.location> save:log1
    - spawn falling_block[gravity=false;fallingblock_type=oak_log] <player.location.above> save:log2
    - title title:<&color[#000000]><&font[adriftus:overlay]><&chr[1004]><&chr[F802]><&chr[1004]> fade_in:5t stay:10t fade_out:1.5s
    - repeat 5:
      - playeffect at:<[foot_location].above> offset:0.2 effect:redstone special_data:5|<[color]> offset:1,1.5,1 quantity:20 targets:<[targets]>
      - wait 1t
    - teleport <player> <[destination]>
    - wait 3s
    - remove <entry[log1].spawned_entity>
    - remove <entry[log2].spawned_entity>
    - repeat 5:
      - playeffect at:<[foot_location].above> offset:0.2 effect:redstone special_data:5|<[color]> offset:1,1.5,1 quantity:20 targets:<[targets]>
      - wait 1t