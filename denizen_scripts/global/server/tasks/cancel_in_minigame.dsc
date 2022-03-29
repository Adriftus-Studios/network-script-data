cancel_in_minigame:
  type: task
  debug: false
  script:
    - determine cancelled if:<player.has_flag[minigame.active]>