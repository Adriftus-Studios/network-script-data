custom_mob_prefix_exhausting:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:Exhausting:
      - if <context.entity.has_effect[slow_digging]>:
        - stop
      - define amp <util.random.int[0].to[4]>
      - cast SLOW_DIGGING <context.entity> duration:<util.random.int[30].to[72].sub[<[amp].mul[3]>]>s amplifier:<[amp]>
