custom_mob_prefix_rebounding:
  Type: world
  debug: false
  events:
    on entity damages entity_flagged:rebounding:
      - if !<list[entity_attack|entity_sweep_attack].contains_any[<context.cause>]>:
        - stop
      - shoot <context.damager> destination:<context.damager.location.backward_flat[3]> no_rotate speed:3
