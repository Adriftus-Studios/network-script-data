tractor_beam_events:
  type: world
  debug: false
  events:
    after player enters tractor_beam_1:
    - while <player.location.is_within[<context.area>]> && <player.is_spawned>:
      - adjust <player> velocity:<context.area.center.sub[<player.location>].div[10].with_y[0.6]>
      - wait 1t
    after player enters tractor_beam_exit_1:
    - adjust <player> gravity:false
    - define vel <location[0.05,0.01,0.085]>
    - while <player.location.is_within[<context.area>]> && <player.is_online>:
      - adjust <player> velocity:<player.velocity.add[<[vel]>]>
      - wait 1t
    - adjust <player> gravity:true
    after server start:
    - while true:
      - inject tractor_beam_particles

tractor_beam_particles:
  type: task
  debug: false
  script:
    - define blocks <cuboid[tractor_beam_1].blocks.filter[y.is[less].than[40]].parse[center]>
    - define blocks2 <cuboid[tractor_beam_1].blocks.filter[y.is[less].than[58]].parse[center]>
    - define blocks3 <cuboid[tractor_beam_1].blocks.filter[y.is[less].than[35]].parse[center]>
    - while <cuboid[tractor_beam_1].exists>:
        - playeffect <[blocks].random[5]> offset:3 effect:DRAGON_BREATH quantity:2 velocity:<location[0,0.7,0]> targets:<server.online_players>
        - playeffect <[blocks2].random[5]> offset:3 effect:END_ROD quantity:2 velocity:<location[0,0.7,0]> targets:<server.online_players>
        - playeffect <[blocks3].random[2]> offset:1 effect:DRAGON_BREATH quantity:2 targets:<server.online_players>
        - wait 3t
