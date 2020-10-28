Husk_Immolation:
  type: task
  debug: false
  script:
  - if <server.entity_is_spawned[<context.entity>]>:
    - repeat 15:
      - if <server.entity_is_spawned[<context.entity>]>
        - playeffect effect:FLAME at:<context.entity.location.add[0,0.5,0]> quantity:2 offset:0.3
        - playeffect effect:FLAME at:<context.entity.location.add[0,1.5,0]> quantity:2 offset:0.3
        - playeffect effect:FLAME at:<context.entity.location.add[0,1.0,0]> quantity:2 offset:0.3
        - wait 4t
