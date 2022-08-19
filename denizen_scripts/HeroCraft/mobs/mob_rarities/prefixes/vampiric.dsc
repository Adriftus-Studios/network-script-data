custom_mob_prefix_vampiric:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:vampiric:
      - if <context.damager.has_flag[regenerating]>:
        - heal <context.damager> <context.damager.health_max.mul[0.3]>
      - else:
        - heal <context.damager> <context.damager.health_max.mul[0.1]>
