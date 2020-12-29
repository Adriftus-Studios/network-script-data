Parkour_events:
  type: world
  debug: false
  events:
    on player enters parkour*:
      - define note_name <context.area.note_name>
      - define level <[note_name].after[~]||null>
        # parkour.SetWaypoint~#
      - choose <[note_name].after[.].before[~]>:
        - case fall:
          - if <player.has_flag[parkour]>:
            - narrate "<&c>Oops, looks like you fell!"
            - narrate "<&e>To leave the challenge, do <&b>/PQ<&e>."
            - define parkour_map <map.with[0].as[parkour.respawn~1].with[1].as[parkour.respawn~1].with[2].as[parkour.respawn~2].with[3].as[parkour.respawn~3].with[parkour.complete].as[parkour_complete]>
            - teleport <[parkour_map].get[<player.flag[parkour]>]>
        - case floor:
          - if !<player.has_flag[parkour]>:
            - narrate "<&c>Talk to the Parkour Master before attempting the course!"
            - teleport ParkourMaster
          - else:
            - flag player parkour:<[level]> duration:5m
            - wait 1t
            - define parkour_map <map.with[0].as[parkour.respawn~1].with[1].as[parkour.respawn~1].with[2].as[parkour.respawn~2].with[3].as[parkour.respawn~3]>
            - teleport <[parkour_map].get[<player.flag[parkour]>]>
            - ratelimit <player> 2s
            - narrate "<&a><&l>Parkour Level <[level]>!"
            - title "title:<&c>Level <[level]>"
        # parkour.finish
        - case finish:
          - if !<player.has_flag[parkour]>:
            - narrate "<&c>Talk to the Parkour Master before attempting the course!"
            - teleport ParkourMaster
          - if <player.has_permission[adriftus.admin]>:
            - narrate "<&c>You can't play for real. But you made it to the top!"
          - teleport parkour_complete
          - wait 5t
          - define tagID Flashyjumper
          - inject title_unlock
          - title title:<&a>Complete!
          - playsound <player> sound:entity_level_up volume:1.0 pitch:0.8
          - firework <player.location> power:0.2 star primary:yellow fade:white flicker
          - narrate "<&a><&l>You made it! Check the leaderboard!"
          - narrate "<&a><&l>Your time was:"
          - narrate <&b><util.time_now.duration_since[<player.flag[parkour_timer]>].formatted>
          - give cookie
          - flag player parkour:!
          - flag player parkour_timer:!

parkour_master_interact_assignment:
  type: assignment
  debug: false
  actions:
    on assignment:
    - trigger name:click state:true
    - trigger name:damage state:true
    on damage:
    - inject parkour_master_task
    on click:
    - inject parkour_master_task

parkour_master_task:
  type: task
  debug: false
  script:
    - if <player.has_flag[parkour]>:
      - if <player.is_sneaking>:
        - narrate "<&a>You have been removed from the challenge!"
        - flag player parkour:!
        - stop
      - narrate "<&a><&l>You are ready to go!"
    - else:
      - flag player parkour_timer:<util.time_now>
      - flag player parkour:0 duration:5m
      - narrate "<&2><&m>=============================================<&nl><&nl><&a>           Hey <&2><player.display_name><&nl><&a>    do you think you can make it to the top?<&nl><&nl><&7>  Game<&co><&a><&l> Spawn Parkour<&r><&nl><&nl>  <&7>Instructions<&co><&a> Make your way to the top of the course<&nl><&a>    Sneak Right-Click the parkour master to end,<&nl><&a>    or type <&d>/pq<&nl><&nl><&2><&m>============================================="
parkour_quit_command:
  type: command
  name: parkour_quit
  debug: false
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
  debug: false
  events:
    on player exits spawn_cuboid:
      - flag player parkour:!
