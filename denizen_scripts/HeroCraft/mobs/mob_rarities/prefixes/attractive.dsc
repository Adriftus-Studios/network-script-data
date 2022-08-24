custom_mob_prefix_attractive:
  Type: world
  debug: false
  events:
    after entity_flagged:attractive damages entity:
        - look <context.entity> <context.damager.eye_location>