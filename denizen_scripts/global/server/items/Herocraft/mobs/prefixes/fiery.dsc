custom_mob_prefix_fiery:
  Type: world
  debug: false
  events:
    after entity_flagged:Fiery targets entity:
      - while <context.entity.is_spawned> && <context.entity.target.exists>:
        - define spread <util.random.int[2].to[4]>
        - playeffect effect:flame at:<context.entity.location.above[1]> quantity:<util.random.int[6].to[12]> offset:<element[1].div[<[spread]>]>,<element[1].div[<[spread]>]>,<element[1].div[<[spread]>]>
        - wait <util.random.int[5].to[10]>t

Fiery_prefix_effect_task:
  type: world
  debug: false
  events:
    on entity damaged by entity_flagged:fiery:
      - define burn_time <util.random.int[1].to[5]>
      - if <context.entity.on_fire> && <context.entity.fire_time.in_seconds> < <[burn_time]>:
        - stop
      - burn <context.entity> duration:<[burn_time]>s
