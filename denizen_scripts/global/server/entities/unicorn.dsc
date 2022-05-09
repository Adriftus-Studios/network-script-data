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

unicorn_spawn_egg:
  type: item
  material: horse_spawn_egg
  display name: <&6>Unicorn Spawn Egg
  lore:
  - "<&6>Mythical Spawn Egg"
  flags:
    right_click_script: unicorn_spawn_from_egg

unicorn_spawn_from_egg:
  type: task
  debug: false
  script:
    - take iteminhand
    - spawn unicorn <context.location>

unicorn_preserve_skin:
  type: task
  debug: false
  script:
    - if <context.item.exists> && <context.item.material.name> == name_tag && <context.item.has_display>:
      - adjust <context.entity> custom_name:<&chr[F801]><context.item.display>
      - take iteminhand