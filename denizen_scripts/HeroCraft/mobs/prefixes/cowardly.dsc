custom_mob_prefix_cowardly:
  Type: world
  debug: false
  events:
    after entity_flagged:cowardly damaged:
    - ratelimit <context.entity> 10s
    - walk <context.entity> <context.entity.backward_flat[20]> speed:10
    - wait 10s
    - walk stop