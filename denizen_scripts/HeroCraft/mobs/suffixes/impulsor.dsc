do_not_use_customs_suffix_impulsor:
  Type: world
  debug: false
  events:
    after entity_flagged:Impulsor targets entity:
      - while <context.entity.is_spawned> && <context.entity.target.exists>:
        - if <context.entity.location.distance[<context.entity.target.location>]> < 8:
            - if !<context.entity.has_flag[mobstuff_pushing]>:
              - MythicSpawn ImpulsorPusher <context.entity.location>
              - flag <context.entity> mobstuff_pushing expire:20t
        - wait 40t
