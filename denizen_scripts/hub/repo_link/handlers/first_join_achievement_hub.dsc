hub_first_join:
  type: world
  debug: false
  events:
    on player joins flagged:!first_joined:
      - run achievement_give def:denizen<&co>hub