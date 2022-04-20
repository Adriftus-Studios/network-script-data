vanish:
    type: command
    debug: false
    name: Vanish
    description: Poof
    permission: adriftus.staff
    usage: /vanish
    script:
        - if !<player.has_flag[vanished]>:
          - run unvanish_task
        - else:
          - run vanish_task

vanish_task:
  type: task
  debug: false
  script:
    - flag <player> vanished
    - flag server vanished_staff:->:<player>
    - adjust <player> hide_from_players
    - flag player on_item_pickup:->:vanish_cancel
    - narrate "<&e>You are now Vanished"
    - foreach <server.online_players.filter[has_permission[adriftus.staff]].exclude[<player>]>:
      - adjust <[value]> show_entity:<player>

unvanish_task:
  type: task
  debug: false
  script:
    - flag <player> vanished:!
    - flag server vanished_staff:<-:<player>
    - adjust <player> show_to_players
    - flag player on_item_pickup:<-:vanish_cancel
    - narrate "<&e>You are no longer Vanished"

vanish_events:
  type: world
  debug: false
  events:
    on player joins:
      - if <player.has_flag[vanish]>:
        - run vanish_task
      - if <player.has_permission[adriftus.staff]>:
        - foreach <server.flag[vanished_staff].exclude[<player>]>:
          - adjust <player> show_entity:<[value]>

vanish_cancel:
  type: task
  debug: false
  script:
    - determine passively cancelled