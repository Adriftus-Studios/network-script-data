custom_mob_prefix_rocketeering:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:rocketeering:
        - if <util.time_now.proc[is_fourth_of_july]>:
          - push <context.entity> destination:<context.entity.location.above[130]>
        - else if <context.damager.has_flag[launching]>:
          - push <context.entity> destination:<context.entity.location.above[50]>
        - else:
          - push <context.entity> destination:<context.entity.location.above[30]>
        - firework <context.entity.location> random power:3