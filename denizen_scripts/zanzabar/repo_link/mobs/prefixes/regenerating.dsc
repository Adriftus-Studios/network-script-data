custom_mob_prefix_regenerating:
  Type: world
  debug: false
  events:
    after entity_flagged:Regenerating targets entity:
      - while <context.entity.is_spawned> && <context.entity.target.exists>:
        - heal <context.entity> <context.entity.health_max.mul[0.1]>
        - playeffect effect:villager_happy offset:0.5,0.5,0.5 quantity:10 at:<context.entity.location.above[1]>
        - wait <util.random.int[20].to[40]>t
