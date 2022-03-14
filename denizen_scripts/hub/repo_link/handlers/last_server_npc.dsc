last_server_npc:
  type: assignment
  actions:
    on assignment:
    - trigger name:click state:true
    - trigger name:damage state:true
    - trigger name:proximity state:true radius:25
    - adjust <npc> mirror_player:true
    - flag server last_server_npc:<npc>
    - rename "<&b>Click to Rejoin!"
    on damage:
    - inject last_server_handler
    on click:
    - inject last_server_handler
    on enter proximity:
    - if <yaml[global.player.<player.uuid>].contains[adriftus.last_server]>:
      - fakespawn "armor_stand[custom_name=<&6>Last Server<&co> <yaml[global.player.<player.uuid>].read[adriftus.last_server]>;custom_name_visible=true;marker=true;visible=false]" <npc.location.above[2]> duration:10h players:<player> save:ent1
      - fakespawn "armor_stand[custom_name=<&b>Click To Join!;custom_name_visible=true;marker=true;visible=false]" <npc.location.above[1.7]> duration:10h players:<player> save:ent2
      - flag <player> adriftus.last_server.armor_stand1:<entry[ent1].faked_entity>
      - flag <player> adriftus.last_server.armor_stand2:<entry[ent2].faked_entity>
    on exit proximity:
    - if <player.has_flag[adriftus.last_server.armor_stand]>:
      - fakespawn <player.flag[adriftus.last_server.armor_stand1]> cancel players:<player>
      - fakespawn <player.flag[adriftus.last_server.armor_stand2]> cancel players:<player>

last_server_handler:
  type: task
  debug: false
  script:
    - if <yaml[global.player.<player.uuid>].contains[adriftus.last_server]>:
      - adjust <player> send_to:<yaml[global.player.<player.uuid>].read[adriftus.last_server]>
    - else:
      - narrate "<&c>You have not played on any server yet!"