hub_streamer_add:
  type: task
  debug: false
  definitions: ign|twitch_username
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
    - flag server hub.streamer.<[uuid]>.twitch_username:<[twitch_username]>
    - run hub_streamer_add_npc def:<[uuid]>

hub_streamer_add_npc:
  type: task
  debug: false
  definitions: uuid
  script:
    - repeat <server.flag[hub.streamer.locations].keys.size>:
      - if !<server.has_flag[hub.streamer.slot.<[value]>]>:
        - define twitch_username <server.flag[hub.streamer.<[uuid]>.twitch_username]>
        - create PLAYER <server.flag[hub.streamer.<[uuid]>.display]> <server.flag[hub.streamer.locations.<[value]>]> registry:streamers save:npc
        - spawn armor_stand[gravity=false;visible=false;marker=true;custom_name_visible=true;custom_name=<&d>www.twitch.tv/<[twitch_username]>] <server.flag[hub.streamer.locations.<[value]>].above[2.1]> save:as1
        - spawn "armor_stand[gravity=false;visible=false;marker=true;custom_name_visible=true;custom_name=<&e>Playing On<&co> <&b>Hub]" <server.flag[hub.streamer.locations.<[value]>].above[2.4]> save:as2
        - create PLAYER <server.flag[hub.streamer.<[uuid]>.display]> <server.flag[hub.streamer.locations.<[value]>]> registry:streamers save:npc
        - adjust <entry[npc].created_npc> skin_blob:<server.flag[hub.streamer.<[uuid]>.skin_blob]>
        - flag server hub.streamer.slot.<[value]>.streamer:<[uuid]>
        - flag server hub.streamer.slot.<[value]>.npc:<entry[npc].created_npc>
        - flag server hub.streamer.slot.<[value]>.twitch_hologram:<entry[as1].created_npc>
        - flag server hub.streamer.slot.<[value]>.server_hologram:<entry[as2].created_npc>
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
      - adjust <server.flag[hub.streamer.slot.<[streamer_slot]>.server_hologram]> "custom_name:<&6>Playing On <&b><context.server.replace_text[_].with[<&sp>].to_titlecase>"

    on bungee player leaves network:
      - stop if:<server.has_flag[hub.streamer.<context.uuid>].not>
      - define streamer_slot <server.flag[hub.streamer.<context.uuid>.slot]>
      - define streamer_npc <server.flag[hub.streamer.slot.<[streamer_slot]>.npc]>
      - define server_hologram <server.flag[hub.streamer.slot.<[streamer_slot]>.server_hologram]>
      - remove <server.flag[hub.streamer.slot.<[streamer_slot]>.npc]>
      - remove <server.flag[hub.streamer.slot.<[streamer_slot]>.twitch_hologram]>
      - remove <server.flag[hub.streamer.slot.<[streamer_slot]>.server_hologram]>
      - flag server hub.streamer.<context.uuid>.slot:!
      - flag server hub.streamer.slot.<[streamer_slot]>:!
