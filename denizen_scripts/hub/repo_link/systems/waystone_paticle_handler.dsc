waystone_particle_handler:
  type: task
  debug: false
  script:
    - while true:
      - playeffect <server.flag[hub_waystone_particles]> effect:ENCHANTMENT_TABLE data:2 quantity:20 offset:0 targets:<server.online_players>
      - wait 10t