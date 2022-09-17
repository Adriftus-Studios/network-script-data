custom_mob_prefix_launching:
  Type: world
  debug: false
  events:
    on entity_flagged:launching knocks back player:
      - determine passively <context.acceleration.mul[5]>