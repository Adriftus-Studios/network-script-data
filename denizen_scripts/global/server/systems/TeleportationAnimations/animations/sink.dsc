teleportation_animation_sink:
  type: data
  # Internal Name, MUST be unique
  name: sink

  # Display Name for Icons
  display: <&6>Ground Sink

  # Material used in menus to represent the animation
  display_material: dirt

  # Description for usage in item lore
  description:
  - "<&e>Sink into the ground"
  - "<&e>Rise at your destination"

  # Does the task take a color as input?
  colorable: true

  # The task for running the animation
  task: teleportation_animation_sink_run


teleportation_animation_sink_run:
  type: task
  debug: false
  definitions: destination|color
  script:
    - flag <player> no_suffocate
    - adjust <player> gravity:false
    - define foot_location <player.location>
    - define targets <player.location.find_players_within[60]>
    - repeat 5:
      - playeffect at:<[foot_location]> offset:0.2 effect:redstone special_data:5|<[color]> quantity:10 targets:<[targets]>
      - wait 2t
    - repeat 10:
      - playeffect at:<[foot_location]> offset:0.2 effect:redstone special_data:5|<[color]> quantity:10 targets:<[targets]>
      - teleport <player> <player.location.below[0.2]>
      - wait 2t
    - teleport <player> <[destination].below[2]>
    - repeat 10:
      - playeffect at:<[destination]> offset:0.2 effect:redstone special_data:5|<[color]> quantity:10 targets:<[targets]>
      - teleport <player> <player.location.above[0.2]>
      - wait 2t
    - flag <player> no_suffocate:!
    - adjust <player> gravity:true