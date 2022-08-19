custom_mob_suffix_undying:
  Type: world
  debug: false
  events:
    on player damages entity_flagged:undying:
      - determine cancelled if:<util.random_chance[90]>