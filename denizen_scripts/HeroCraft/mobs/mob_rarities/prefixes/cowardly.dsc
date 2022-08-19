custom_mob_prefix_cowardly:
  Type: world
  debug: false
  events:
    after entity_flagged:cowardly damaged:
    - ratelimit <context.entity> 10s
    - if <context.entity.has_flag[sprinting]> || <context.entity.has_flag[light]>:
      - cast SPEED <context.entity> amplifier:3 duration:5s hide_particles
    - attack <context.entity> cancel
    - flag cowardly_running expire:10s
    - walk <context.entity> <context.entity.backward_flat[20]> speed:10
    - wait 10s
    - walk stop
    on entity_flagged:cowardly_running targets entity:
    - determine cancelled
