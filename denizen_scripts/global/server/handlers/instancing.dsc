instance_area:
  type: task
  debug: false
  definitions: name|cuboid|type
  script:
    - define type generic if:<[type].exists.not>
    - bungeerun instances create_new_instance def:<[name]>|<[type]>|<bungee.server>|<[cuboid]>

instance_area_transfer:
  type: task
  debug: false
  definitions: cuboid|name
  script:
    - foreach <[cuboid].chunks>:
      - run instancing_transfer_chunk def:<[value]>|<[name]>
      - wait 10t
    - bungeerun instances instance_finished def:<[name]>

instancing_transfer_chunk:
  type: task
  debug: false
  definitions: chunk|name
  script:
    - define uuid <util.random_uuid>
    - chunkload <[chunk]> duration:10s if:<[chunk].is_loaded.not>
    - schematic create name:<[uuid]> <[chunk].cuboid> origin:<[chunk].cuboid.center> entities flags
    - schematic save name:<[uuid]> filename:global/instancing/<[uuid]>
    - bungeerun instances instancing_paste_schematic def:<[uuid]>|<[chunk].cuboid.center>|<[name]>

instancing_paste_schematic:
  type: task
  debug: false
  definitions: UUID|location|name
  script:
    - define xOffset <server.flag[instance_map.names.<[name]>.coordinates].before[_]>
    - define zOffset <server.flag[instance_map.names.<[name]>.coordinates].after[_]>
    - define xFinal <[xOffset].add[<[location].x.mod[10000]>]>
    - define zFinal <[zOffset].add[<[location].z.mod[10000]>]>
    - define finalLocation <location[<[xFinal]>,<[location].y>,<[zFinal]>,world].add[<server.flag[instance_map.names.<[name]>.offset]>]>
    - schematic load name:<[uuid]> filename:global/instancing/<[uuid]>
    - foreach <schematic[<[uuid]>].cuboid[<[finalLocation]>].chunks> as:this_chunk:
      - if !<[this_chunk].is_loaded>:
        - chunkload <[this_chunk]> duration:10s
    - schematic paste name:<[uuid]> origin:<[finalLocation]> entities
    - schematic unload name:<[uuid]>