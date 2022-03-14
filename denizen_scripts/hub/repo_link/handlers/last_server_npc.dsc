last_server_npc:
  type: assignment
  actions:
    on assignment:
    - trigger name:click state:true
    - trigger name:damage state:true
    - trigger name:proximity state:true radius:15
    - adjust <npc> mirror_player:true
    - flag server last_server_npc:<npc>
    - rename <npc> "<&b>Click to Rejoin!"
    on damage:
    - inventory open d:store_hub_cosmeticShop
    on click:
    - inventory open d:store_hub_cosmeticShop
    on enter proximity:
    - if <yaml[global.player.<player.uuid>].contains[adriftus.last_server]>:
      - fakespawn "armor_stand[custom_name=<&6>Last Server<&co> <yaml[global.player.<player.uuid>].read[adriftus.last_server]>;custom_name_visible=true;marker=true;visible=false]" <npc.location.above[2.5]> players:<player> save:ent
      - flag <player> adriftus.last_server.armor_stand:<entry[ent].faked_entity>
    on exit proximity:
    - if <player.has_flag[adriftus.last_server.armor_stand]>:
      - fakespawn <player.flag[adriftus.last_server.armor_stand]> cancel players:<player>

last_server_handler:
  type: task
  debug: false
  script:
    - if <yaml[global.player.<player.uuid>].contains[adriftus.last_server]>:
      - adjust <player> send_to:<yaml[global.player.<player.uuid>].read[adriftus.last_server]>
    - else:
      - narrate "<&c>You have not played on any server yet!"