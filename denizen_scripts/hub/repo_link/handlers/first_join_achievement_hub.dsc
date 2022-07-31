hub_first_join:
  type: world
  debug: false
  events:
    on custom event id:resource_pack_loaded:
      - if !<player.has_advancement[denizen:herocraft]>:
        - wait 2s
        - run achievement_give_parent def:hub
        - run achievement_give_parent def:herocraft