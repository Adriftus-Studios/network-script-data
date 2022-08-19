custom_mob_prefix_spinning:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:spinning:
        - ratelimit <context.entity> 30s
        - rotate <context.entity> duration:2s frequency:2t yaw:15