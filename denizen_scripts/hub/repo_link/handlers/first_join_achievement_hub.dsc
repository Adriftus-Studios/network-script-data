hub_first_join:
  type: world
  debug: false
  events:
    on player joins:
      - if !<player.has_advancement[denizen:hub]>:
        - wait 2s
        - run achievement_give_parent def:hub