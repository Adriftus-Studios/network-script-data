custom_mob_prefix_poisonous:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:poisonous:
      - if <context.entity.has_effect[poison]>:
        - stop
      - cast poison <context.entity> amplifier:<util.random.int[0].to[3]> duration:15s
