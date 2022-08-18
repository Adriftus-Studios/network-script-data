custom_mob_prefix_sprinting:
  Type: world
  debug: false
  events:
    on entity_flagged:sprinting targets entity:
    - while <context.entity.is_spawned> && <context.target.exists>:
      - if <util.random.int[1].to[4]> > 1:
        - if <context.entity.has_flag[light]>:
          - cast speed <context.entity> amplifier:<util.random.int[1].to[8]> duration:<util.random.int[20].to[150]>t hide_particles
        - else:
          - cast speed <context.entity> amplifier:<util.random.int[1].to[3]> duration:<util.random.int[20].to[30]>t hide_particles
      - wait 40t
