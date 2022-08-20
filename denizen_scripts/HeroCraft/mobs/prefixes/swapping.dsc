custom_mob_prefix_swapping:
  Type: world
  debug: false
  events:
    on entity_flagged:swapping targets player:
    - stop if:<context.entity.can_see[<context.target>].not>
    - if <context.entity.location.distance[<context.target.location>]> > 50:
      - stop
    - ratelimit <context.entity> 20s
    - define loc <context.target.location>
    - teleport <context.target> <context.entity.location>
    - teleport <context.entity> <[loc]>
    - narrate "<&c>You have been swapped by <context.entity.custom_name>" targets:<context.target>
