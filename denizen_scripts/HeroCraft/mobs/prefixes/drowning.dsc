custom_mob_prefix_drowning:
  type: world
  debug: false
  events:
    after player damaged by entity_flagged:drowning:
        - oxygen 0 mode:set