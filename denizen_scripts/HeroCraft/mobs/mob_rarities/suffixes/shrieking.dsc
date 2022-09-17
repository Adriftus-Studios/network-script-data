custom_mob_suffix_shrieking:
  Type: world
  debug: false
  events:
    after entity_flagged:shrieking damages entity:
        - stop if:<util.random_chance[95]>
        - playsound <context.damager.location> sound:block_sculk_shrieker_activate volume:1 pitch:1
        - spawn warden <context.damager.location> target:<context.entity>