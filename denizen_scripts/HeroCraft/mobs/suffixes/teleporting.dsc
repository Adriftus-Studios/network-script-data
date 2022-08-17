custom_mob_suffix_teleporting:
  Type: world
  debug: false
  events:
    after entity_flagged:teleporting targets entity:
        - teleport <context.entity> <context.target.location> if:<util.random_chance[25]>