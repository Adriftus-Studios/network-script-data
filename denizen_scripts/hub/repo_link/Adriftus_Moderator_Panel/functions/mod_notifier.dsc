# -- Message online staff about moderator actions.
mod_message_staff:
  type: task
  debug: false
  definitions: message
  script:
    - narrate targets:<server.players.filter[has_permission[adriftus.staff]]> <[message]>

# -- Return `kicked` messages for kicks and bans.
mod_kick_message:
  type: procedure
  debug: false
  definitions: moderator|level|infraction|length|date
  script:
    - define moderator <[moderator].as_player.name||Server>
    # -- Used in `- kick` messages for server & network bans.
    - if <[length]||null> != null && <[date]||null> != null:
      - determine "<&6>Banned for: <&b><[infraction]> <&6>for <&b><[length]> <&6>on <&e><[date].format[yyyy-MM-dd<&sp>HH:mm:ss]><&nl><&6>Level: <&f><[level]><&nl><&c>Banned by: <&f><[moderator]>"
    # -- Used in `- kick` messages for kicking player from the network.
    - else:
      - determine "<&e>Kicked for: <&b><[infraction]><&nl><&e>Level: <&f><[level]><&nl><&c>Kicked by: <&f><[moderator]>"

# -- Notify online staff about actions.
mod_notify_action:
  type: task
  debug: false
  definitions: moderator|uuid|infraction|action|extra|global
  script:
    - define moderator <[moderator].as_player.name||Server>
    - if <[action]> == Unban:
      # <[extra]> = Reason
      - define message "<&c>[!] <&b><[moderator]> has unbanned <[uuid].as_player.name>, who was <tern[<element[<[global]||null>].is[!=].to[null]>].pass[globally<&sp>].fail[]>banned for <[infraction]>, with the reason: <[extra]>"
    - else:
      - define message "<&e>[!] <&b><[uuid].as_player.name> was <script[mod_action_past_tense].data_key[<[action]>]> by <[moderator]> for <[infraction]>"
      # <[extra]> = Length
      - if <[extra]||null> != null:
        - define message "<[message]> for <[extra].as_duration.formatted>."
      - else:
        - define message <[message]>.

    # Check if server is connected to BungeeCord.
    - if <bungee.connected>:
      - bungeerun <bungee.list_servers> mod_message_staff def:<[message]>
    - else:
      - run mod_message_staff def:<[message]>

# -- Notify online staff about reports.
mod_notify_report:
  type: task
  debug: true
  definitions: reporter|reason|server|uuid
  script:
    - define reporter <[reporter].as_player.name>
    # -- /report
    - if <[uuid]||null> != null:
      - define message "<&6>[<&a><&l><[server]><&6>] <&e><[reporter]> <&a>has reported <&c><[uuid].as_player.name> <&a>for <&6><[reason]>."
    # -- /bugreport
    - else:
      - define message "<&2>[<&a><&l><[server]><&2>] <&a><[reporter]> <&e>has reported a bug: <&2><[reason]>."

    # Check if server is connected to BungeeCord.
    - if <bungee.connected>:
      - bungeerun <bungee.list_servers> mod_message_staff def:<[message]>
    - else:
      - run mod_message_staff def:<[message]>
