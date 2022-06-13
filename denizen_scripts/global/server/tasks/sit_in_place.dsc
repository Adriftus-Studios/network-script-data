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
    - flag player on_dismount:<-:sit_in_place_cancel