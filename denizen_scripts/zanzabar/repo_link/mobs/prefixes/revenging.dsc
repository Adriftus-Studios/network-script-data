custom_mob_prefix_revenging:
  Type: world
  debug: false
  events:
    on entity_flagged:revenging damaged by entity priority:5:
      - if !<list[entity_attack|entity_sweep_attack].contains_any[<context.cause>]>:
        - stop
      - hurt <context.damager> <context.final_damage.div[5]>
