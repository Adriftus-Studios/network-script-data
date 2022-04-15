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
