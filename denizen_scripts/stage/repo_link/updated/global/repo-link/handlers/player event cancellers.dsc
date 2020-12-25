flag_handler:
  type: world
  debug: false
  events:
    on player damaged by suffocation flagged:no_suffocate bukkit_priority:LOWEST:
      - determine cancelled
    on player damaged by fall flagged:no_fall bukkit_priority:LOWEST:
      - determine cancelled
    on player damaged by fall flagged:no_next_fall bukkit_priority:LOWEST:
      - flag player no_next_fall:!
      - determine cancelled
    on player damaged flagged:no_damage bukkit_priority:LOWEST:
      - determine cancelled
    on player jumps flagged:no_jump bukkit_priority:LOWEST:
      - determine cancelled
    on player walks flagged:no_move bukkit_priority:LOWEST:
      - determine cancelled
    on player moves flagged:downpull:
      - ratelimit <player> 5t
      - adjust <player> velocity:<player.velocity.add[<location[0,<player.flag[downpull]||-0.02>,0]>]>
    on player chats flagged:chat_mute bukkit_priority:LOWEST:
      - determine cancelled
