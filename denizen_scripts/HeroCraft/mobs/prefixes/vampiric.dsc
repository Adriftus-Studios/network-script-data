custom_mob_prefix_vampiric:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:Vampiric:
      - heal <context.damager> <context.damager.health_max.mul[0.1]>
