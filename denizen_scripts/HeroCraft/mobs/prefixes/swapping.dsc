custom_mob_prefix_swapping:
  Type: world
  debug: false
  events:
    on entity_flagged:swapping targets player:
    - ratelimit <context.entity> 20s
    - define loc <context.target.location>
    - teleport <context.target> <context.entity.location>
    - teleport <context.entity> <[loc]>
