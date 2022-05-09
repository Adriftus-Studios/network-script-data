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

unicorn_preserve_skin:
  type: task
  debug: false
  script:
    - if <context.item.exists> && <context.item.material.name> == name_tag && <context.item.has_display>:
      - adjust <context.entity> custom_name:<&chr[F801]><context.item.display>
      - take iteminhand