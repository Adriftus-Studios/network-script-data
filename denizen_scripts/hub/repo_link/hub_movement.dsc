hub_jump:
  type: world
  debug: false
  events:
    on player jumps flagged:hub_jump:
      - define location <player.location>
      - if <[location].pitch> < -25 && <player.location.y> <= 35:
        - wait 1t
        - adjust <player> velocity:<[location].with_pitch[<[location].pitch.sub[5]>].direction.vector.mul[10]>
        - repeat 20:
          - playsound <player.location> sound:ENTITY_FIREWORK_ROCKET_LAUNCH
          - playeffect effect:smoke at:<player.location> quantity:5 offset:0.1 targets:<server.online_players>
          - wait 1t
    on player toggles sprinting flagged:hub_run:
      - if <context.state>:
        - adjust <player> walk_speed:0.4
      - else:
        - adjust <player> walk_speed:0.2
