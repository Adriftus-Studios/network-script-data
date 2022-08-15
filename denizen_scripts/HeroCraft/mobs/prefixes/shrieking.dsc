custom_mob_prefix_shrieking:
  Type: world
  debug: false
  events:
    after entity_flagged:shrieking damages entity:
        - stop if:<util.random_chance[95]>
        - spawn warden <context.damager.location> target:<context.entity>