jade_startup:
  type: world
  debug: false
  events:
    after server start:
      - discordconnect id:jade token<secret[jade]>

jade_link_user:
  type: world
  debug: false
  events:
    on discord slash command name:link:
      - define playername <context.options.get[player]>
      - bungeetag server:hub <server.match_player[<[playername]>].if_null[<server.match_offline_player[<[playername]>].if_null[null]>]||null> save:player
      - define player <entry[player].results>
      - ~discordinteraction defer ephemeral:true interaction:<context.interaction>
      - if <[player]> == null:
        - ~discordinteraction reply interaction:<context.interaction> "Please verify that you have logged in to the minecraft server before." ephemeral:true
        - stop
      - if <[player].has_flag[discord.account_linked]>:
        - if <[player].flag[discord.account_linked]> != <context.interaction.user>:
          - ~discordinteraction reply interaction:<context.interaction> "This account is linked to <[player].flag[discord.account_linked].name>. Please /unlink in game if incorrect." ephemeral:true
          - stop
      - if <context.interaction.user.has_flag[minecraft.account_linked]>:
        - ~discordinteraction reply interaction:<context.interaction> "You are already linked to <context.interaction.user.flag[minecraft.account_linked].name>. Please /unlink if incorrect."
        - stop
      - bungee hub:
        - flag <[player]> discord.account_linked:<context.interaction.user>
        - flag <[player]> discord.notify.linked:<context.interaction.user.name>
      - flag <context.interaction.user> minecraft.account_linked:<[player]>
      - ~discordinteraction reply interaction:<context.interaction> "You have successfully linked to <[player].name>. If incorrect please /unlink and type your complete name more carefully."
      - stop

    on discord slash command name:unlink:
      - ~discordinteraction defer ephemeral:true interaction:<context.interaction>
      - if !<context.interaction.user.has_flag[minecraft.account_linked]>:
        - ~discordinteraction reply interaction:<context.interaction> "This account is not currently associated with any accounts."
        - stop
      - if <context.interaction.user.has_flag[minecraft.account_linked]>:
        - ~discordinteraction reply interaction:<context.interaction> "Now unlinked from <context.interaction.user.flag[minecraft.account_linked].name>"
        - bungee hub:
          - flag <context.interaction.user.flag[minecraft.account_linked]> discord.account_linked:!
          - flag <context.interaction.user.flag[minecraft.account_linked]> discord.notify.unlinked:<context.interaction.user.name>
        - flag <context.interaction.user> minecraft.account_linked:!
        - stop
