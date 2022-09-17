custom_mob_prefix_ravenous:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:ravenous:
      - if <context.entity.has_effect[hunger]>:
        - stop
      - cast HUNGER amplifier:<util.random.int[0].to[2]> <context.entity> duration:<util.random.int[5].to[20]>s
