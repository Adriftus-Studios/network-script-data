custom_mob_prefix_withering:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:withering:
      - if <context.entity.has_effect[wither]>:
          - stop
      - define amp <util.random.int[0].to[3]>
      - cast WITHER <context.entity> amplifier:<[amp]> duration:<element[10].sub[<[amp].mul[2]>]> source:<context.damager>
