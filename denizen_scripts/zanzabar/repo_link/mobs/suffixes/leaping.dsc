custom_mob_suffix_leaping:
  Type: world
  debug: false
  events:
    on entity_flagged:leaping targets entity:
    - while <context.entity.is_spawned> && <context.target.exists>:
      - if <context.entity.location.distance[<context.target.location>].is_more_than[5]>:
        - define leap_to <context.target.location.find.surface_blocks.within[3].random>
        - shoot <context.entity> destination:<[leap_to]> speed:0.5
      - wait 30t
