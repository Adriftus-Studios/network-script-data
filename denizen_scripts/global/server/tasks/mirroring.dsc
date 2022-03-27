mirroring_transfer_chunks:
  type: task
  debug: false
  definitions: chunk|server
  script:
    - define uuid <util.random_uuid>
    - chunkload <[chunk]> duration:10s if:<[chunk].is_loaded.not>
    - schematic create name:<[uuid]> <[chunk].cuboid> origin:<[chunk].cuboid.center> entities flags
    - schematic save name:<[uuid]> filename:global/mirroring/<[uuid]>
    - bungeerun <[server]> mirroring_paste_schematic def:<[uuid]>|<[chunk].cuboid.center>

mirroring_paste_schematic:
  type: task
  debug: false
  definitions: UUID|location
  script:
    - schematic load name:<[uuid]> filename:global/mirroring/<[uuid]>
    - foreach <schematic[<[uuid]>].cuboid[<[location]>].chunks>:
      - chunkload <[value]> duration:10s
    - schematic paste name:<[uuid]> origin:<[location]> entities flags