custom_mob_prefix_spinning:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:spinning:
        - rotate <context.entity> duration:3s frequency:5t yaw:15