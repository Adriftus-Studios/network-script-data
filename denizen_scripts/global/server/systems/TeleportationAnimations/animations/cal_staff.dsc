teleportation_animation_cal_staff:
  type: data
  # Internal Name, MUST be unique
  name: mj

  # Display Name for Icons
  display: <&6>MJ

  # Material used in menus to represent the animation
  display_material: dirt

  # Description for usage in item lore
  description:
  - "<&e>MJ's Teleportation"

  # Does the task take a color as input?
  colorable: false

  # The task for running the animation
  task: teleportation_animation_cal_staff_run


teleportation_animation_cal_staff_run:
  type: task
  debug: false
  definitions: destination|color
  script:
    - define start_location <player.location>
    - repeat 12:
      - define star_locations_<[value]> <proc[define_star].context[<[start_location].above[0.1].with_pitch[90]>|5|<element[15].mul[<[value]>]>|5]>
    - adjust <player> gravity:false
    - teleport <[start_location].above[0.1]>
    - define targets <player.location.find_players_within[60]>
    - wait 1t
    - repeat 10 as:star_value:
      - repeat 6:
        - define spiral_<[value]> <proc[define_spiral].context[<[start_location].with_yaw[<element[36].mul[<[value]>]>].forward_flat[1]>|<[start_location].above[30]>|2|0]>
        - playeffect at:<[star_locations_<[star_value]>]> effect:redstone special_data:0.5|<list[green|yellow].random> offset:0.1 quantity:3 targets:<[targets]>
        - wait 1t
    - repeat 10:
      - playeffect at:<[spiral_<[value]>]> effect:redstone special_data:5|<list[green|yellow].random> offset:0.1 quantity:2 targets:<[targets]>
    - run teleportation_animation_cal_staff_secondary def:<[start_location]>|<[destination]>
    - repeat 3:
      - repeat 10:
        - define spiral_<[value]> <proc[define_spiral].context[<[start_location].with_yaw[<element[36].mul[<[loop_index]>]>].forward_flat[1]>|<[start_location].above[30]>|2|0]>
        - wait 1t

teleportation_animation_cal_staff_secondary:
  type: task
  debug: false
  definitions: start|destination
  script:
    - define targets <player.location.find_players_within[60]>
    - define points <[start].points_between[<[start].above[30]>].distance[1]>
    - foreach <[points].get[1].to[-5]>:
      - playeffect at:<[value]> effect:redstone special_data:5|green offset:0.5 quantity:20 targets:<[targets]>
      - playeffect at:<[value]> effect:redstone special_data:5|yellow offset:0.5 quantity:20 targets:<[targets]>
      - teleport <player> <[value]>
      - wait 1t
    - title title:<&color[#000000]><&font[adriftus:overlay]><&chr[1004]><&chr[F802]><&chr[1004]> fade_in:5t stay:10t fade_out:1.5s
    - define far_targets <[destination].find_players_within[60]>
    - foreach <[points].get[-5].to[last]>:
      - playeffect at:<[value]> effect:redstone special_data:5|green offset:0.5 quantity:20 targets:<[targets]>
      - playeffect at:<[value]> effect:redstone special_data:5|yellow offset:0.5 quantity:20 targets:<[targets]>
      - teleport <player> <[value]>
      - playeffect at:<[destination]> effect:redstone special_data:5|green offset:0.5 quantity:20 targets:<[far_targets]> if:<[far_targets].is_empty.not>
      - playeffect at:<[destination]> effect:redstone special_data:5|yellow offset:0.5 quantity:20 targets:<[far_targets]> if:<[far_targets].is_empty.not>
      - wait 1t
    - teleport <player> <[destination]>
    - wait 1t
    - adjust <player> gravity:true