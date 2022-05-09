custom_mob_suffix_vortexer:
  Type: world
  debug: false
  events:
    after entity_flagged:Vortexer targets entity:
      - while <context.entity.is_spawned> && <context.entity.target.exists>:
        - if <context.entity.location.distance[<context.entity.target.location>]> < 7:
            - if !<context.entity.has_flag[mobstuff_pulling]>:
              - MythicSpawn VortexerPuller <context.entity.location>
              - flag <context.entity> mobstuff_pulling expire:20t
        - wait 40t
