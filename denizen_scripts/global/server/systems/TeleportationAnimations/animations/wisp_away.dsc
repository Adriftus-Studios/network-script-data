teleportation_animation_wisp_away:
  type: data
  # Internal Name, MUST be unique
  name: wisp_away

  # Display Name for Icons
  display: <&6>Wisp Away

  # Material used in menus to represent the animation
  display_material: magma_cream

  # Description for usage in item lore
  description:
  - "<&e>Fly away as a wisp"

  # Does the task take a color as input?
  colorable: true

  # The task for running the animation
  task: teleportation_animation_wisp_away_run


teleportation_animation_wisp_away_run:
  type: task
  debug: false
  definitions: destination|color
  script:
    - define gamemode <player.gamemode>
    - define targets <player.location.find_players_within[100]>
    - define starting_location <player.location>
    - define vector <[destination].sub[<player.location>].with_y[<player.location.y.add[31].max[<[destination].y.add[31]>]>].normalize.mul[30.1]>
    - define points <proc[define_curve1].context[<player.location>|<player.location.add[<[vector]>]>|5|90|1]>
    - define original_y <player.location.y>
    - repeat 10:
      - playeffect at:<player.location> offset:0.4 effect:redstone special_data:5|<[color]> quantity:30 targets:<[targets]>
      - wait 2t
    - adjust <player> gamemode:spectator
    - adjust <player> gravity:false
    - adjust <player> can_fly:false
    - repeat 30:
      - playeffect at:<player.location> offset:0.4 effect:redstone special_data:5|<[color]> quantity:30 targets:<[targets]>
      - adjust <player> velocity:<[points].get[<[value].add[1]>].sub[<[points].get[<[value]>]>]>
      - wait 2t
    - teleport <player> <[destination].with_y[<[destination].y.add[31]>]>
    - define targets <player.location.find_players_within[100]>
    - repeat 30:
      - playeffect at:<player.location> offset:0.4 effect:redstone special_data:5|<[color]> quantity:30 targets:<[targets]>
      - adjust <player> velocity:0,-0.51,0
      - wait 2t
    - adjust <player> gamemode:<[gamemode]>
    - adjust <player> gravity:true
    - repeat 3:
      - playeffect at:<[destination]> offset:<element[1].mul[<[value]>]> effect:redstone special_data:5|<[color]> quantity:<element[30].mul[<[value]>]> targets:<[targets]>
      - wait 1t