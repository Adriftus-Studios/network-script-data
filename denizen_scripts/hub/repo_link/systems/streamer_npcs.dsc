hub_streamer_add:
  type: task
  debug: false
  definitions: name|uuid|twitch_link
  script:
    - flag server hub.streamer.<[uuid]>.uuid:<&6><[uuid]>
    - flag server hub.streamer.<[uuid]>.display:<&6><[name]>
    - flag server hub.streamer.<[uuid]>.twitch_link:<[twitch_link]>

hub_streamer_events:
  type: world
  debug: false
  events:
    on bungee player joins network:
      - if <server.has_flag[hub.streamer.<context.uuid>]>:
        - repeat <server.flag[hub.streamer.locations].keys.size>:
          - if !<server.has_flag[hub.streamer.slot.<[value]>]>:
            - create <server.flag[hub.streamer.<context.uuid>.display]> <server.flag[hub.streamer.locations.<[value]>]> registry:streamers save:npc
            # TODO - Armor Stand Holograms or Font Signs.
            - flag server hub.streamer.slot.<[value]>.streamer:<context.uuid>
            - flag server hub.streamer.slot.<[value]>.npc:<entry[npc].created_npc>
            - flag server hub.streamer.<context.uuid>.slot:<[value]>

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
