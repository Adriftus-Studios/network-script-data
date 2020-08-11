# -- Message online staff about moderator actions.
mod_message_staff:
  type: task
  debug: false
  definitions: message
  script:
    - narrate targets:<server.players.filter[has_permission[adriftus.staff]]> <[message]>

# -- Return `kicked` messages
mod_kick_message:
  type: procedure
  debug: false
  definitions: moderator|level|infraction
  script:
    # -- Used in `- kick` messages for kicking player from the network.
    - define moderator <[moderator].as_player.name||Server>
    - determine "<&e>Kicked for: <&b><[infraction]><&nl><&e>Level: <&f><[level]><&nl><&c>Kicked by: <&f><[moderator]>"

mod_ban_message:
  type: procedure
  debug: false
  definitions: moderator|level|infraction|length|date
  script:
    # -- Used in `- kick` messages for server & network bans.
    - define moderator <[moderator].as_player.name||Server>
    - determine "<&6>Banned for: <&b><[infraction]> <&6>for <&b><[length]> <&6>on <&e><[date].format[yyyy-MM-dd<&sp>HH:mm:ss]><&nl><&6>Level: <&f><[level]><&nl><&c>Banned by: <&f><[moderator]>"

# -- Notify online staff about actions.
mod_notify_action:
  type: task
  debug: false
  definitions: moderator|uuid|level|infraction|action|length
  script:
    - define moderator <[moderator].as_player.name||Server>
    - define message "<&e>[!] <&b><[uuid].as_player.name> was <script[mod_action_past_tense].data_key[<[action]>]> by <[moderator]> for <[infraction]>"
    - if <[length]||null> != null:
      - define message "<[message]> for <[length].as_duration.formatted>."
    - else:
      - define message <[message]>.
    - if <bungee.list_servers.size||0> > 1:
      - bungeerun <bungee.list_servers> mod_message_staff def:<[message]>
    - else:
      - run mod_message_staff def:<[message]>

# -- Notify online staff about unbans.
mod_notify_unban:
  type: task
  debug: false
  definitions: moderator|uuid|infraction|reason|global
  script:
    - define moderator <[moderator].as_player.name||Server>
    - define message "<&c>[!] <&b><[moderator]> has unbanned <[uuid].as_player.name>, who was <tern[<element[<[global]||null>].is[!=].to[null]>].pass[globally<&sp>].fail[]>banned for <[infraction]>, with the reason: <[reason]>"
    - if <bungee.list_servers.size||0> > 1:
      - bungeerun <bungee.list_servers> mod_message_staff def:<[message]>
    - else:
      - run mod_message_staff def:<[message]>
