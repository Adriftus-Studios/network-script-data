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
    - while <player.location.is_within[<context.area>]> && <player.is_spawned>:
      - adjust <player> velocity:<player.velocity.add[<[vel]>]>
      - wait 1t
    - adjust <player> gravity:true
    after server start:
      - run tractor_beam_particles

tractor_beam_particles:
  type: task
  debug: false
  script:
    - define blocks <cuboid[tractor_beam_1].blocks.filter[y.is[less].than[45]]>
    - while <cuboid[tractor_beam_1].exists>:
        - playeffect <[blocks].random[10]> offset:3 effect:DRAGON_BREATH quantity:5 velocity:<location[0,0.7,0]> targets:<server.online_players>
        - playeffect <[blocks].random[10]> offset:3 effect:END_ROD quantity:5 velocity:<location[0,0.7,0]> targets:<server.online_players>
        - wait 3t