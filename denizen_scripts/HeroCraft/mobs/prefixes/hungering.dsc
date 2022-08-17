custom_mob_prefix_hungering:
  Type: world
  debug: false
  events:
    on player damaged by entity_flagged:hungering:
        - feed <player> amount:<util.random.int[1].to[10].mul[-1]>