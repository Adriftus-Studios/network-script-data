mirroring_transfer_chunks:
  type: task
  debug: false
  definitions: chunk|server
  script:
    - define uuid <util.random_uuid>
    - chunkload <[chunk]> duration:10s if:<[chunk].is_loaded.not>
    - schematic create name:<[uuid]> <[chunk].cuboid> origin:<[chunk].cuboid.center> flags
    - schematic save name:<[uuid]> filename:global/mirroring/<[uuid]>
    - bungeerun <[server]> mirroring_paste_schematic def:<[uuid]>|<[chunk].cuboid.center>
    - wait 10t
    - run mirroring_transfer_entities def:<[chunk]>|<[server]>

mirroring_paste_schematic:
  type: task
  debug: false
  definitions: UUID|location
  script:
    - schematic load name:<[uuid]> filename:global/mirroring/<[uuid]>
    - foreach <schematic[<[uuid]>].cuboid[<[location]>].chunks>:
      - chunkload <[value]> duration:10s
    - schematic paste name:<[uuid]> origin:<[location]> flags

mirroring_transfer_entities:
  type: task
  debug: false
  definitions: chunk|server
  script:
    - define map <map>
    - foreach <[chunk].entities.filter[entity_type.equals[player].not]>:
      - define map <[map].with[<[value].location>].as[<[value].describe>]>
    - if <[map].size> > 0:
      - bungeerun <[server]> mirroring_paste_entities def:<[chunk]>|<[map]>

mirroring_paste_entities:
  type: task
  debug: false
  definitions: chunk|entity_map
  script:
    - chunkload <[chunk]> duration:10s if:<[chunk].is_loaded.not>
    - wait 10t
    - foreach <[entity_map]> key:loc as:entity:
      - spawn <[entity]> <[loc]>