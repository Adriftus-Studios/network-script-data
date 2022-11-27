OrcWeapon_zapper:
  type: item
  display name: <&f>Orc Zapper
  lore:
  - <&6>Wonder how you use this
  material: iron_shovel
  flags:
    custom_durability:
      max: 10
      current: 0
  debug: false
  mechanisms:
    custom_model_data: 3000



orc_bolt_poison:
  type: world
  debug: false
  events:
    on player left clicks block with:OrcWeapon_Zapper:
      - determine passively cancelled
    on player damages entity with:OrcWeapon_Zapper:
      - determine passively cancelled
    on player right clicks block with:OrcWeapon_Zapper:
      - determine passively cancelled
      - ratelimit <player> 100t
      - shoot OrcWeapon_Zapper_projectile save:shot speed:1.5 origin:<player.location.above[1.5].right[0.25]>
      - adjust <entry[shot].shot_entity> hide_from_players
      - run OrcWeapon_Zapper_projectile_remover def.projectile:<entry[shot].shot_entity>
      - flag <entry[shot].shot_entity> on_hit_entity:orc_Zapper_hits_entity
      - flag <entry[shot].shot_entity> custom_damage.cause:<player.name><&sq><&6>Orcish<&sp>Spear.
      - define value 1
      - define slot <player.held_item_slot>
      - inject custom_durability_process_task
      - while <entry[shot].shot_entity.is_spawned>:
        - playeffect effect:redstone quantity:10 special_data:2|0,0,0 at:<entry[shot].shot_entity.location> offset:0.15
        - wait 1t
        - playeffect effect:redstone at:<entry[shot].shot_entity.location> quantity:2 special_data:3|32,0,58 offset:0.2
        - wait 1t


OrcWeapon_Zapper_projectile:
  type: entity
  debug: false
  entity_type: snowball
  mechanisms:
    item: feather[custom_model_data=1]
    gravity: false



orc_Zapper_hits_entity:
  type: task
  debug: false
  script:
  - cast blindness <context.hit_entity> duration:<util.random.int[10].to[40]>s

OrcWeapon_Zapper_projectile_remover:
  type: task
  debug: false
  definitions: projectile
  script:
    - wait 40t
    - if <[projectile].is_spawned>:
      - remove <[projectile]>
