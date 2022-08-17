custom_mob_prefix_rocketeering:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:rocketeering:
        - push <context.entity> destination:<context.entity.location.above[30]>
        - firework <context.entity.location> random power:3