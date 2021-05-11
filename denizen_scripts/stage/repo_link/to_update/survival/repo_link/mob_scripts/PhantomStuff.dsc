Purple_phantom_breath:
  type: task
  debug: false
  script:
    - repeat 10:
    - foreach <context.entity.location.left.down.to_cuboid[<context.target.location.right.above>].blocks.parse[sub[<context.entity.location>]].normalize> as:velocity:
        - playeffect effect:DRAGON_BREATH at:<context.entity.location> velocity:<[velocity]> quantity:4
        - playeffect effect:ITEM_CRACK at:<context.entity.location> velocity:<[velocity]> quantity:1 special_data:leather_boots
        - playeffect effect:ITEM_CRACK at:<context.entity.location> velocity:<[velocity]> quantity:1 special_data:leather_boots
        - wait 2t

Green_Phantom_Breath:
  type: task
  debug: false
  script:
    - repeat 10:
    - foreach <context.entity.location.left.down.to_cuboid[<context.target.location.right.above>].blocks.parse[sub[<context.entity.location>].div[2]]> as:velocity:
        - playeffect effect:SNEEZE at:<context.entity.location> velocity:<[velocity]> quantity:4
        - playeffect effect:ITEM_CRACK at:<context.entity.location> velocity:<[velocity]> quantity:1 special_data:leather_boots
        - playeffect effect:ITEM_CRACK at:<context.entity.location> velocity:<[velocity]> quantity:1 special_data:leather_boots
        - wait 2t
