# -- /vanish - Moderator vanish command
mod_vanish:
    type: command
    debug: false
    name: Vanish
    description: Poof
    permission: adriftus.staff
    usage: /vanish
    script:
      - if <player.has_flag[vanished]>:
        - run mod_unvanish_task
      - else:
        - run mod_vanish_task def:true

mod_vanish_task:
  type: task
  debug: false
  definitions: flag
  script:
    - flag <player> vanished
    - flag server vanished_staff:->:<player>
    - adjust <player> health_data:200/200
    - adjust <player> hide_from_players
    - if <[flag]>:
      - flag player on_item_pickup:->:mod_vanish_cancel
    - flag <player> on_damaged:->:mod_vanish_cancel
    - flag <player> on_damage:->:mod_vanish_cancel
    - flag <player> on_target:->:mod_vanish_cancel
    - narrate "<&e>You are now <&b>Vanished<&e>."
    - foreach <server.online_players.filter[has_permission[adriftus.staff]].exclude[<player>]>:
      - adjust <[value]> show_entity:<player>

mod_unvanish_task:
  type: task
  script:
    - flag <player> vanished:!
    - flag server vanished_staff:<-:<player>
    - adjust <player> health_data:20/20
    - adjust <player> show_to_players
    - flag player on_item_pickup:<-:mod_vanish_cancel
    - flag <player> on_damaged:<-:mod_vanish_cancel
    - flag <player> on_damage:<-:mod_vanish_cancel
    - flag <player> on_target:<-:mod_vanish_cancel
    - narrate "<&e>You are no longer <&b>Vanished<&e>."

mod_vanish_events:
  type: world
  debug: false
  events:
    after player joins:
      - if <player.has_flag[vanished]>:
        - run mod_vanish_task def:false
      - if <player.has_permission[adriftus.staff]> && <server.has_flag[vanished_staff]>:
        - foreach <server.flag[vanished_staff].exclude[<player>]>:
          - adjust <player> show_entity:<[value]>
    on player quits flagged:vanished:
      - flag server vanished_staff:<server.flag[vanished_staff].filter[is_online].exclude[<player>]>

mod_vanish_cancel:
  type: task
  debug: false
  script:
    - determine passively cancelled
