sit_in_place:
  type: task
  debug: false
  script:
    - ratelimit <player> 1t
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
    - teleport <player> <player.location.above[1.8]>
    - flag player on_dismount:<-:sit_in_place_cancel