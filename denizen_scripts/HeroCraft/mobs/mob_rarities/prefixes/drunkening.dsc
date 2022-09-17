custom_mob_prefix_drunkening:
  Type: world
  debug: false
  events:
    on player damaged by entity_flagged:drunkening:
        - execute as_server "brew drink beer 10 <player.name>"