Husk_Immolation:
  type: task
  debug: false
  script:
#KEY EVENT PURPOSEFULLY MISSING. TO BE CALLED BY A MOB
  - repeat 15:
    - playeffect effect:FLAME at:<context.entity.location.add[0,0.5,0]> quantity:2 offset:0.3
    - playeffect effect:FLAME at:<context.entity.location.add[0,1.5,0]> quantity:2 offset:0.3
    - playeffect effect:FLAME at:<context.entity.location.add[0,1.0,0]> quantity:2 offset:0.3
    - wait 4t
