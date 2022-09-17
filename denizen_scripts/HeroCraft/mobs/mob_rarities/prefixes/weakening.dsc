custom_mob_prefix_weakening:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:weakening:
      - if <context.entity.has_flag[weakness]>:
        - stop
      - define duration <util.random.int[5].to[10]>
      - cast WEAKNESS <context.entity> duration:<[duration]>s
      - flag <context.entity> mob_weakened duration:<[duration]>s

weakening_prefix_effect_task:
  type: world
  debug: false
  events:
    on entity damaged by entity_flagged:mob_weakened:
      - determine passively <context.final_damage.div[2]>
