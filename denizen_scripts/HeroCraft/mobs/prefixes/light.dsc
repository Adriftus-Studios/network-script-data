custom_mob_prefix_light:
  Type: world
  debug: false
  events:
    on entity knocks back entity_flagged:light:
      - determine passively <context.acceleration.mul[2]>
      - cast SPEED <context.entity> amplifier:10 duration:5s