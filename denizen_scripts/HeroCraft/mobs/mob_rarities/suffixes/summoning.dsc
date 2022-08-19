custom_mob_suffix_summoning:
  Type: world
  debug: false
  events:
    on player damages entity_flagged:summoning:
      - spawn <entity[silverfish].repeat_as_list[<util.random.int[1].to[3]>]> if:<util.random_chance[65]>