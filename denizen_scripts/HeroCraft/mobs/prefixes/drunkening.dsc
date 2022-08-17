custom_mob_prefix_drunkening:
  Type: world
  debug: false
  events:
    on player damaged by entity_flagged:drunkening:
        - execute as_server "brew drink red_wine 5 <player.name>"