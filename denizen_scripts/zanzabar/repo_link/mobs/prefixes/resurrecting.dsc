custom_mob_prefix_resurrecting:
  Type: world
  debug: false
  events:
    on entity_flagged:resurrecting dies:
      - heal <context.entity>
      - flag <context.entity> resurrecting:!
      - determine cancelled
