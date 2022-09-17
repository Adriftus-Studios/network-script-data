custom_mob_prefix_ensnaring:
  Type: world
  debug: false
  events:
    on entity_flagged:ensnaring damages entity:
      - if <context.entity.has_effect[slow]>:
        - stop
      - define amp <util.random.int[1].to[3]>
      - cast SLOW <context.entity> amplifier:<[amp]> duration:<element[5].sub[<[amp]>]>
