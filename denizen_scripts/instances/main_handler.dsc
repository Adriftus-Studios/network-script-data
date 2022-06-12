create_new_instance:
  type: task
  debug: false
  # Type can be HEROCRAFT, ADMIN, or GENERIC
  definitions: name|type|callback_server|cuboid
  script:
    - if <server.has_flag[instance_map.names.<[name]>]>:
      - DEBUG ERROR "Instance name already exists<&co> <[name]>"
      - stop
    - if !<list[generic|herocraft|admin].contains[<[type]>]>:
      - DEBUG ERROR "Unknown Instance Type<&co> <[type]>"
      - stop
    - define type generic if:<[type].exists.not>
    - define xNumber <server.flag[instances.<[type]>.xCurrent].if_null[1].add[1]>
    - define zNumber <server.flag[instances.<[type]>.zCurrent].if_null[1].add[1]>
    - choose <[type]>:
      - case herocraft:
        - define xStart <[xNumber].mul[-10000]>
        - define zStart <[zNumber].mul[10000]>
        - if <[xStart]> < -2047403648:
          - flag server instances.<[type]>.xCurrent:1
          - flag server instances.<[type]>.zCurrent:+:1
        - else:
          - flag server instances.<[type]>.xCurrent:+:1
      - case admin:
        - define xStart <[xNumber].mul[10000]>
        - define zStart <[zNumber].mul[-10000]>
        - if <[xStart]> > 2047403648:
          - flag server instances.<[type]>.xCurrent:1
          - flag server instances.<[type]>.zCurrent:+:1
        - else:
          - flag server instances.<[type]>.xCurrent:+:1
      - case generic:
        - define xStart <[xNumber].mul[10000]>
        - define zStart <[zNumber].mul[10000]>
        - if <[xStart]> > 2047403648:
          - flag server instances.<[type]>.xCurrent:1
          - flag server instances.<[type]>.zCurrent:+:1
        - else:
          - flag server instances.<[type]>.xCurrent:+:1
    - flag server instance_map.coordinates.<[xStart]>.<[zStart]>:<[name]>
    - flag server instance_map.names.<[name]>.coordinates:<[xStart]>_<[zStart]>
    - define cuboidOffset <location[<[cuboid].center.x.mod[10000]>,<[cuboid].center.y>,<[cuboid].center.z.mod[10000]>,world]>
    - define offsetVector <location[5000,<[cuboid].center.y>,5000,world].sub[<[cuboidOffset]>]>
    - flag server instance_map.names.<[name]>.offset:<[offsetVector]>
    - bungeerun <[callback_server]> instance_area_transfer def:<[cuboid]>

instance_finished:
  type: task
  debug: false
  definitions: name
  script:
    - announce to_console "Instance <[name]> finished initializing"

instancing_separation:
  type: world
  debug: false
  events:
    on player places block:
      - define xMod <context.location.x.mod[10000]>
      - define zMod <context.location.z.mod[10000]>
      - if <[xMod]> > 9500 || <[xMod]> < 500 || <[zMod]> > 9500 || <[zMod]> < 500:
        - determine cancelled
