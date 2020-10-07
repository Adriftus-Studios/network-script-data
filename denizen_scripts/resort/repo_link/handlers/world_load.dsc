world_handler:
  type: world
  debug: false
  script:
    on server start:
      - createworld the_resort
      - foreach world|world_the_end as:world:
        - adjust <world[<[world]>]> unload
