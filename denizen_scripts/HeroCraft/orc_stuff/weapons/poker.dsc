OrcWeapon_Poker:
  type: item
  display name: <&f>Orc Poker
  lore:
  - <&6>Stick em with the pointy end.
  - <&6>Increased <&e>Range IV<&6>.
  material: iron_sword
  flags:
    custom_durability:
      max: 132
      current: 0
  debug: false
  mechanisms:
    custom_model_data: 3000

OrcWeapon_Poker_projectile:
  type: entity
  debug: false
  entity_type: snowball
  mechanisms:
    item: iron_sword[custom_model_data=3001]

OrcWeapon_Poker_shoot:
  type: world
  debug: false
  events:
    on player left clicks block with:OrcWeapon_Poker:
      - determine passively cancelled
      - ratelimit <player> 12t
      - playeffect offset:0 at:<player.eye_location.right[0.25].down[0.25].points_between[<player.eye_location.forward[4]>].distance[0.2]> effect:CRIT
      - define target <player.precise_target[4]||null>
      - if <[target]> != null:
        - hurt <[target]> source:<player> 6


orc_poker_hits_entity:
  type: task
  debug: false
  script:
    - if <context.hit_entity.location.town.exists>:
      - if <context.hit_entity.location.town> != <context.projectile.shooter.town.if_null[null]>:
        - stop
    - if <list[armor_stand|item_frame|glow_item_frame].contains_any[<context.hit_entity.entity_type>]> == armor_stand || <context.hit_entity.script.exists>:
      - stop
    - hurt <context.hit_entity> 6 source:player
