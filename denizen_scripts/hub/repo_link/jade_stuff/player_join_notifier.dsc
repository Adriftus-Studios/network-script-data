jade_link_notifier:
  type: world
  debug: true
  events:
    on player joins:
      - if <player.has_flag[discord.notify.linked]>:
        - wait 10t
        - narrate "<&e><Player.flag[discord.notify.linked]> <&6>has connected to your account via discord.<&nl><&c>If this was in error, please /unlink."
        - flag <player> discord.notify.linked:!
      - if <player.has_flag[discord.notify.unlinked]>:
        - wait 10t
        - if <player.is_spawned>:
          - narrate "<&e><Player.flag[discord.notify.unlinked]> <&6>has discconnected from your account via discord."
          - flag <player> discord.notify.unlinked:!

jade_ingame_unlink:
  type: command
  debug: false
  name: unlink
  usage: /unlink
  description: unlinks your discord account
  script:
    - if !<player.has_flag[discord.account_linked]>:
      - narrate "<&c>You are not currently connected to discord."
      - stop
    - flag <player.flag[discord.account_linked]> minecraft.account_linked:!
    - narrate "<&a>Unlinked from <player.flag[discord.account_linked].name>.<&nl><&6>A confirmation message has been sent to your DMs by Jade."
    - ~discordmessage id:jade user:<player.flag[discord.account_linked]> "Your minecraft account (<player.name>) has been unlinked from Adriftus."
    - flag <player> discord.account_linked:!
