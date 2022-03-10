hub_streamer_add:
  type: task
  debug: false
  definitions: ign|twitch_link
  script:
    - if !<server.match_player[<[ign]>].is_online||false>:
      - narrate "Streamer must be online, and in hub."
      - stop
    - define streamer <server.match_player[<[ign]>]>
    - define uuid <[streamer].uuid>
    - flag server hub.streamer.<[uuid]>.ign:<[ign]>
    - flag server hub.streamer.<[uuid]>.skin_blob:<[streamer].skin_blob>
    - flag server hub.streamer.<[uuid]>.skull_skin:<[streamer].uuid>;<[streamer].skin_blob>
    - flag server hub.streamer.<[uuid]>.display:<&6><[ign]>
    - flag server hub.streamer.<[uuid]>.twitch_link:<[twitch_link]>
    - run hub_streamer_add_npc def:<[uuid]>

hub_streamer_add_npc:
  type: task
  debug: false
  definitions: uuid
  script:
    - repeat <server.flag[hub.streamer.locations].keys.size>:
      - if !<server.has_flag[hub.streamer.slot.<[value]>]>:
        - create PLAYER <server.flag[hub.streamer.<[uuid]>.display]> <server.flag[hub.streamer.locations.<[value]>]> registry:streamers save:npc
        # TODO - Armor Stand Holograms or Font Signs.
        - adjust <entry[npc].created_npc> skin_blob:<server.flag[hub.streamer.<[uuid]>.skin_blob]>
        - flag server hub.streamer.slot.<[value]>.streamer:<[uuid]>
        - flag server hub.streamer.slot.<[value]>.npc:<entry[npc].created_npc>
        - flag server hub.streamer.<[uuid]>.slot:<[value]>
        - repeat stop

hub_streamer_events:
  type: world
  debug: false
  events:
    on bungee player joins network:
      - if <server.has_flag[hub.streamer.<context.uuid>]>:
        - run hub_streamer_add_npc def:<context.uuid>

    on bungee player switches to server:
      - stop if:<server.has_flag[hub.streamer.<context.uuid>].not>
      - wait 10t
      - define streamer_slot <server.flag[hub.streamer.<context.uuid>.slot]>
      - define streamer_npc <server.flag[hub.streamer.slot.<[streamer_slot]>.npc]>
      - define server_hologram <server.flag[hub.streamer.slot.<[streamer_slot]>.server_hologram]>

    on bungee player leaves network:
      - stop if:<server.has_flag[hub.streamer.<context.uuid>].not>
      - define streamer_slot <server.flag[hub.streamer.<context.uuid>.slot]>
      - define streamer_npc <server.flag[hub.streamer.slot.<[streamer_slot]>.npc]>
      - define server_hologram <server.flag[hub.streamer.slot.<[streamer_slot]>.server_hologram]>
      - remove <server.flag[hub.streamer.slot.<[streamer_slot]>.npc]>
      - flag server hub.streamer.<context.uuid>.slot:!
      - flag server hub.streamer.slot.<[streamer_slot]>:!
