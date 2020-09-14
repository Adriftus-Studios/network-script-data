
Parkour_events:
  type: world
  events:
    on player enters parkour*:
      - define note_name <context.area.note_name>
      - define level <[note_name].after[~]||null>
      - choose <[note_name].after[.].before[~]>:
        # parkour.SetWaypoint~#
        - case SetWaypoint:
          - if <player.has_flag[parkour]>:
            - flag player parkour:<[level]> duration:5m
            - ratelimit <player> 30s
            - narrate "<&a><&l>Parkour Level <[level]>!"
            - title "title:<&c>Level <[level]>"
          - else:
            - narrate "<&c>Talk to the Parkour Master before attempting the course!"
        # parkour.Floor~# (Had to break it up into two floors, because the tree got in the way)
        - case floor:
          - if <player.has_flag[parkour]>:
            # parkour.respawn~#
            - define parkour_map <map[0/parkour_complete|1/parkour.respawn~1|2/parkour.respawn~2|3/parkour.respawn~3]>
            - teleport <[parkour_map].get[<player.flag[parkour]>]>
        # parkour.finish
        - case finish:
          - if <player.has_permission[adriftus.admin]>:
            - narrate "<&c>You can't play for real. But you made it to the top!"
          - teleport parkour_complete
          - wait 1t
          - flag player parkour:!
          - define tagID Flashyjumper
          - inject title_unlock
          - title title:<&a>Complete!
          - playsound <player> sound:entity_level_up volume:1.0 pitch:0.8
          - firework <player.location> power:0.2 star primary:yellow fade:white flicker
          - narrate "<&a><&l>You made it! Check the leaderboard!"
          - give cookie

parkour_master_interact_command:
  type: command
  name: parkour
  description: Starts the parkour
  usage: /parkour [player]
  permission: custom.command.parkour
  script:
    - adjust <queue> linked_player:<server.match_player[<context.args.first>]>
    - if <player.has_flag[parkour]>:
      - if <player.is_sneaking>:
        - narrate "<&a>You have been removed from the challenge!"
        - flag player parkour:!
        - stop
      - narrate "<&a><&l>You are ready to go!"
    - else:
      - flag player parkour:0 duration:5m
      - narrate "<&2><&m>=============================================<&nl><&nl><&a>           Hey <&2><player.display_name><&nl><&a>    do you think you can make it to the top?<&nl><&nl><&7>  Game<&co><&a><&l> Spawn Parkour<&r><&nl><&nl>  <&7>Instructions<&co><&a> Make your way to the top of the course<&nl><&a>    Sneak Right-Click the parkour master to end,<&nl><&a>    or type <&d>/pq<&nl><&nl><&2><&m>============================================="
parkour_quit_command:
  type: command
  name: parkour_quit
  aliases:
  - pq
  description: Stops the parkour
  usage: /parkour_quit
  script:
      - if <player.has_flag[parkour]>:
        - narrate "<&a>You have been removed from the challenge!"
        - flag player parkour:!
        - teleport parkour_complete
        - stop
      - narrate "<&c>You are not currently participating in the parkour!"

parkour_leave_handler:
  type: world
  events:
    on player exits spawn_cuboid:
      - flag player parkour:!
