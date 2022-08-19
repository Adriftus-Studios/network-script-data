custom_mob_prefix_cloaking:
  Type: world
  debug: false
  events:
    after entity_flagged:cloaking targets entity:
    - while <context.entity.is_spawned> && <context.entity.target.exists>:
      - if <context.entity.location.distance[<context.target.location>].is_more_than[4]>:
        - cast invisibility <context.entity> hide_particles duration:20t
      - wait 25t
