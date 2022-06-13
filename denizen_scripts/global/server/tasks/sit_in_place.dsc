sit_in_place:
  type: task
  debug: false
  script:
    - ratelimit <player> 1t
    - if <player.flag[on_dismount].contains[sit_in_place_cancel].if_null[false]>:
      - inject sit_in_place_cancel
      - stop
    - if !<player.location.below.material.is_solid> || <player.location.below.material.name> == barrier:
      - narrate "<&c>You must sit on solid ground"
      - stop
    - inventory close
    - teleport <player> <player.location.below[0.175]>
    - animate animation:sit <player>
    - flag player on_dismount:->:sit_in_place_cancel

sit_in_place_cancel:
  type: task
  debug: false
  script:
    - ratelimit <player> 1t
    - animate <player> animation:stop_sitting
    - flag player on_dismount:<-:sit_in_place_cancel
    - wait 1t
    - teleport <player> <player.location.above[0.3]>