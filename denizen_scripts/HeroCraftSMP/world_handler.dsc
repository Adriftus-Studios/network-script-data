herocraft_world_handler:
  type: world
  debug: false
  events:
    after player joins:
      - if <player.has_flag[current_world]>:
        - adjust <player> send_to:<player.flag[current_world]>