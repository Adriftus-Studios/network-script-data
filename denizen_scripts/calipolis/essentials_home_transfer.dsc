convert_essentials_homes_calipolis:
  type: task
  debug: false
  script:
    - foreach <server.players> as:user:
      - flag <[user]> homes_data:!
      - flag <[user]> homes_unlocked:5
      - define home <[user].essentials_homes.keys>
      - foreach <[home].get[1].to[5]> as:name:
        - flag <[user]> homes_data.<util.random_uuid>:<map[display=<[name]>;location=<[user].essentials_homes.get[<[name]>]>;lore=<&a>Welcome<&sp>To<&sp>Adriftus!]>
