Husk_Immolation:
  type: task
  debug: false
  script:
    - repeat 15:
      - playeffect effect:FLAME at:<context.entity.location.add[0,0.5,0]> quantity:2 offset:0.3
      - playeffect effect:FLAME at:<context.entity.location.add[0,1.5,0]> quantity:2 offset:0.3
      - playeffect effect:FLAME at:<context.entity.location.add[0,1.0,0]> quantity:2 offset:0.3
      - wait 4t
