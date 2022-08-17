# -- Return `kicked` messages for kicks and bans.
mod_kick_message:
  type: procedure
  debug: false
  definitions: moderator|level|infraction|length|date
  script:
    - define moderator <[moderator].as_player.name||Server>
    # -- Used in `- kick` messages for network bans.
    - if <[length]||null> != null && <[date]||null> != null:
      - determine "<&6>Banned for: <&b><[infraction]> <&6>for <&b><[length]> <&6>on <&e><[date].format[yyyy-MM-dd<&sp>HH:mm:ss]><&nl><&6>Level: <&f><[level]><&nl><&6>If you would like to appeal this ban please open a ticket at<&nl><&b>discord.gg/adriftus"
    # -- Used in `- kick` messages for kicking player from the network.
    - else:
      - determine "<&e>Kicked for: <&b><[infraction]><&nl><&e>Level: <&f><[level]>"

# -- Send messages in the moderation chat channel.
mod_chat_notifier:
  type: task
  debug: false
  definitions: moderator|uuid|level|infraction|action|length|text
  script:
    - define moderator <[moderator].as_player.name||Server>
    - define name <[uuid].as_player.name>
    - choose <[action]>:
      - case Ban:
        # -- Used for network bans.
        - run chat_system_speak "def.message:I have banned <[name]> for <[infraction]> for <[length]>. (Level <[level]>)" def.channel:moderation
      - case Unban:
        # -- Used for unbans.
        - run chat_system_speak "def.message:I have unbanned <[name]>, who was banned for <[infraction]>. (Level <[level]>)" def.channel:moderation
      - case Kick:
        # -- Used for kicks.
        - run chat_system_speak "def.message:I have kicked <[name]> for <[infraction]>. (Level <[level]>)" def.channel:moderation
      - case Send:
        # -- Used for sending players.
        - run chat_system_speak "def.message:I have sent <[name]> from <[text]>." def.channel:moderation
      - case InventoryRestore:
        # -- Used for fully restoring inventories.
        - run chat_system_speak "def.message:I have restored <[name]>'s inventory on <bungee.server><&co> <[text]>." def.channel:moderation
