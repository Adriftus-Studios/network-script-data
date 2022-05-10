murder_all:
  type: task
  debug: false
  script:
    - define start <player.location>
    - foreach <player.location.find_entities[!player|npc].within[45]>
      - teleport <player> <[value].location.backward.with_pose[<[value]>]>
      - hurt <[value]> 2000
      - wait 1t
    - teleport <[start]>