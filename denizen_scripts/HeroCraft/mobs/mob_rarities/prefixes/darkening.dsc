custom_mob_prefix_darkening:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:Darkening:
      - if <context.entity.has_effect[blindness]>:
        - stop
      - cast blindness <context.entity> duration:<util.random.int[3].to[7]>s
