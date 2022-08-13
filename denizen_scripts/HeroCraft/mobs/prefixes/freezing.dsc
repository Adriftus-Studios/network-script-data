custom_mob_prefix_freezing:
  Type: world
  debug: false
  events:
    after entity_flagged:freezing damages entity:
      - if <context.entity.freeze_duration.in_ticks.if_null[1]> > 200:
        - stop
      - adjust <context.entity> freeze_duration:400t
