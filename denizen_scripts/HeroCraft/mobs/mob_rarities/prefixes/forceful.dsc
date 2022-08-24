custom_mob_prefix_forceful:
  Type: world
  debug: false
  events:
    on entity_flagged:forceful knocks back entity:
      - determine passively <context.acceleration.mul[2]>
