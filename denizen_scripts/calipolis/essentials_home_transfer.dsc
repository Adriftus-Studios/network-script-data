convert_essentials_homes_calipolis:
  type: task
  debug: false
  script:
    - foreach <server.players> as:user:
      - if <[user].essentials_homes.size> > 5:
        - flag server too_many_homes:->:<[user]>
        - foreach next
      - foreach <[user].essentials_homes> key:name as:location:
        - flag <[user]> homes_data.<util.random_uuid>:<map[display=<[name]>;location=<[location]>;lore=<&a>Welcome<&sp>To<&sp>Adriftus!]>