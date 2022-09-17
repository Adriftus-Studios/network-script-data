custom_mob_prefix_resurrecting:
  Type: world
  debug: false
  events:
    on entity_flagged:resurrecting dies:
      - determine passively cancelled
      - heal <context.entity>
      - flag <context.entity> resurrecting:!
