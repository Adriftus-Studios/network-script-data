tractor_beam_events:
  type: world
  debug: false
  events:
    on player enters tractor_beam_1:
    - cast LEVITATION amplifier:20 duration:99d
    on player exits tractor_beam_1:
    - cast LEVITATION amplifier:20 duration:0t
    after player enters tractor_beam_exit_1:
    - adjust <player> gravity:false
    - define vel <location[0.05,-0,0.085]>
    - while <player.location.is_within[<context.area>]>:
      - adjust <player> velocity:<player.velocity.add[<[vel]>]>
      - wait 1t
    - adjust <player> gravity:true