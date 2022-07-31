hub_first_join:
  type: world
  debug: false
  events:
    on player joins flagged:!first_joined:
      - wait 2s
      - run achievement_give def:hub