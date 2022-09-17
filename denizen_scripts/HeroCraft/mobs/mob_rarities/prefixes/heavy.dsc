custom_mob_prefix_heavy:
  Type: world
  debug: false
  events:
    on entity knocks back entity_flagged:Heavy:
      - determine passively <context.acceleration.div[2]>
