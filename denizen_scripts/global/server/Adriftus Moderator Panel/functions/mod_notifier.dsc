# -- Return `kicked` messages for kicks and bans.
mod_kick_message:
  type: procedure
  debug: false
  definitions: moderator|level|infraction|length|date
  script:
    - define moderator <[moderator].as_player.name||Server>
    # -- Used in `- kick` messages for server & network bans.
    - if <[length]||null> != null && <[date]||null> != null:
      - determine "<&6>Banned for: <&b><[infraction]> <&6>for <&b><[length]> <&6>on <&e><[date].format[yyyy-MM-dd<&sp>HH:mm:ss]><&nl><&6>Level: <&f><[level]>"
    # -- Used in `- kick` messages for kicking player from the network.
    - else:
      - determine "<&e>Kicked for: <&b><[infraction]><&nl><&e>Level: <&f><[level]>"

# -- Send messages in the moderation chat channel.
mod_chat_notifier:
  type: task
  debug: false
  definitions: moderator|uuid|level|infraction|action|length
  script:
    - define moderator <[moderator].as_player.name||Server>
    - define name <[uuid].as_player.name>
    # -- Used for server & network bans.
    - if <[length]||null> != null:
      - run chat_system_speak "def.message:I have banned <[name]> for <[infraction]> for <[length]>. (Level <[level]>)" def.channel:moderation
    # -- Used for kicks.
    - else:
      - run chat_system_speak "def.message:I have banned <[name]> for <[infraction]>. (Level <[level]>)" def.channel:moderation
