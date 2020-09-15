Purple_phantom_breath:
  type: task
  debug: false
  script:
    - repeat 10:
      - playeffect effect:DRAGON_BREATH at:<context.entity.location.add[0,0,0]> velocity:<context.entity.left.down.to_cuboid[<context.target.right.above>].blocks.parse[sub[<context.entity.location>].div[2]]> quantity:4
      - playeffect effect:ITEM_CRACK at:<context.entity.location.add[0,0,0]> velocity:<context.entity.left.down.to_cuboid[<context.target.right.above>].blocks.parse[sub[<context.entity.location>].div[2]]> quantity:1 special_data:leather_boots
      - playeffect effect:ITEM_CRACK at:<context.entity.location.add[0,0,0]> velocity:<context.entity.left.down.to_cuboid[<context.target.right.above>].blocks.parse[sub[<context.entity.location>].div[2]]> quantity:1 special_data:leather_boots
      - wait 2t

Green_Phantom_Breath:
  type: task
  debug: false
  script:
    - repeat 10:
      - playeffect effect:SNEEZE at:<context.entity.location.add[0,0,0]> velocity:<context.entity.left.down.to_cuboid[<context.target.right.above>].blocks.parse[sub[<context.entity.location>].div[2]]> quantity:4
      - playeffect effect:ITEM_CRACK at:<context.entity.location.add[0,0,0]> velocity:<context.entity.left.down.to_cuboid[<context.target.right.above>].blocks.parse[sub[<context.entity.location>].div[2]]> quantity:1 special_data:leather_boots
      - playeffect effect:ITEM_CRACK at:<context.entity.location.add[0,0,0]> velocity:<context.entity.left.down.to_cuboid[<context.target.right.above>].blocks.parse[sub[<context.entity.location>].div[2]]> quantity:1 special_data:leather_boots
      - wait 2t
