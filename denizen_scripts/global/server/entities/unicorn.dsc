unicorn:
  type: entity
  entity_type: horse
  data:
    forced_prefix: <&chr[F801]>
  mechanisms:
    color: brown|none
    jump_strength: 5
    speed: 0.5
    custom_name: <&chr[F801]><&6>Whimsicorn
    age: adult
  flags:
    on_damaged: cancel
    right_click_script: unicorn_preserve_skin
    on_mounted: unicorn_protect_rider
    on_dismounted: unicorn_unprotect_rider

unicorn_spawn_egg:
  type: item
  material: horse_spawn_egg
  display name: <&6>Unicorn Spawn Egg
  lore:
  - "<&6>Mythical Spawn Egg"
  flags:
    right_click_script: unicorn_spawn_from_egg

unicorn_protect_rider:
  type: task
  debug: false
  script:
    - flag <context.entity> on_damaged:->:cancel

unicorn_unprotect_rider:
  type: task
  debug: false
  script:
    - flag <context.entity> on_damaged:<-:cancel

unicorn_spawn_from_egg:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - spawn unicorn <context.location.above> save:ent
    - if <entry[ent].spawned_entity.is_spawned>:
      - adjust <entry[ent].spawned_entity> owner:<player>
      - equip <entry[ent].spawned_entity> saddle:saddle
      - take iteminhand
    - else:
      - narrate "<&c>Unable to spawn here"

unicorn_preserve_skin:
  type: task
  debug: false
  script:
    - ratelimit <player> 5t
    - if <context.entity.owner.exists> && <context.entity.owner> != <player>:
      - narrate "<&c>The Whimsicorn rejects you, as you are not it's master."
      - determine cancelled
    - if <context.item.exists> && <context.item.material.name> == name_tag && <context.item.has_display>:
      - adjust <context.entity> custom_name:<&chr[F801]><context.item.display>
      - take iteminhand
