chat_system_events:
  type: world
  debug: false
  events:
    on player chats bukkit_priority:LOWEST:
      - determine passively cancelled
      - define channel <yaml[global.player.<player.uuid>].read[chat.channels.current]||global>

      - if <player.has_permission[chat.color]>:
        - define msg <context.message.parse_color>
      - else:
        - define msg <context.message.parse_color.strip_color>

      #                |                                             CHANNEL NAME                                                                                     |                          PLAYER NAME                                                                                                                                               |                               SEPARATOR                             |                                      MESSAGE                                                                           |
      #- define message "<yaml[chat_config].read[channels.<[channel]>.format.channel].parsed.on_hover[<&e>Click to switch to this channel].on_click[/chat <[channel]>]><yaml[chat_config].read[channels.<[channel]>.format.name].parsed.on_hover[<&color[#F3FFAD]>Name<&color[#26FFC9]><&co> <&color[#C1F2F7]><player.name><&nl><&color[#F3FFAD]>Rank<&co><&color[#26FFC9]>: <yaml[global.player.<player.uuid>].read[rank]||<&7>No Rank>]><yaml[chat_config].read[channels.<[channel]>.format.separator].parsed><yaml[chat_config].read[channels.<[channel]>.format.message].parsed.on_hover[<util.time_now.format[E, MMM d, y h:mm a]>]>"

      - define Hover "<&color[#F3FFAD]>Click to switch to<&color[#26FFC9]>: <&color[#C1F2F7]><[channel].to_titlecase>"
      - define Text <yaml[chat_config].read[channels.<[channel]>.format.channel].parsed>
      - define Command "chat <[channel]>"
      - define ChannelText <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>

      - define Hover "<&color[#F3FFAD]>Name<&color[#26FFC9]>: <&color[#C1F2F7]><player.name><&nl><&color[#F3FFAD]>Rank<&color[#26FFC9]>: <yaml[global.player.<player.uuid>].read[rank]||<&color[#F3FFAD]>No Rank>"
      - define Text <yaml[chat_config].read[channels.<[channel]>.format.name].parsed>
      - define Hint "msg <player.name> "
      - define NameText <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Hint]>]>

      - define Separator <yaml[chat_config].read[channels.<[channel]>.format.separator].parsed>

      - define Hover "<&color[#F3FFAD]>Timestamp<&color[#26FFC9]>: <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>]>"
      - define Text <yaml[chat_config].read[channels.<[channel]>.format.message].parsed>
      - define Insert <[Text]>
      - define MessageText <proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Insert]>]>

      - define Message <[ChannelText]><[NameText]><[Separator]><[MessageText]>
      
      
      - narrate "<[message]>" targets:<server.online_players_flagged[chat_channel_<[channel]>]>
      - waituntil rate:1s <bungee.connected>
      - if <yaml[chat_config].read[channels.<[channel]>.global]>:
      #^- foreach <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>|<bungee.server>]> as:server:
      #-- foreach <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>].exclude[<bungee.server>]> as:Server:
          #^- bungeerun <[server]> chat_send_message def:<[channel]>|<[message].escaped>
        #-- bungeerun <[server]> chat_send_message def:<list_single[<[channel]>].include[<[message]>]>
        - define Servers <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>].exclude[<bungee.server>]>
        - bungeerun <[Servers]> chat_send_message def:<list_single[<[channel]>].include[<[message]>]>
        - if <yaml[chat_config].read[channels.<[channel]>.integrations.Discord.active]>:
        #^- bungeerun relay chat_send_message def:<[channel]>|<player.name>|<context.message.escaped>|<bungee.server>
          - bungeerun relay chat_send_message def:<list_single[<[Channel]>].include[<player.name>].include[<context.message>].include[<bungee.server>]>
        - inject chat_history_save

chat_history_save:
  type: task
  debug: false
  definitions: Channel|Message
  script:
  #^- yaml id:chat_history set <[channel]>_history:|:<map[channel/<[channel]>|message/<[message_escaped]||<[message].escaped>>|time/<server.current_time_millis>].escaped>
    - yaml id:chat_history set <[channel]>_history:->:<map[].with[channel].as[<[channel]>].with[message].as[<[Message]>].with[time].as[<server.current_time_millis>]>
    - if <yaml[chat_history].read[<[channel]>_history].size> > 25:
      - yaml id:chat_history set <[channel]>_history:!|:<yaml[chat_history].read[<[channel]>_history].remove[first]>

chat_history_show:
  type: task
  debug: false
  script:
    - define list <list>
    - foreach <yaml[global.player.<player.uuid>].read[chat.channels.active].filter_tag[<yaml[chat_config].contains[channels.<[Filter_Value]>]>]> as:Channel:
      - if !<yaml[chat_history].contains[<[Channel]>_history]>:
        - foreach next
      - define list <[List].include[<yaml[chat_history].read[<[Channel]>_history]>]>
  #^- narrate <[list].parse[unescaped].sort_by_number[get[time]].size>
    - if <[List].is_empty>:
      - stop
    - foreach <[list].sort_by_number[get[time]].reverse.get[1].to[20].reverse.parse[get[message]]> as:Message:
      - narrate <[Message]>

chat_command:
  type: command
  name: chat
  usage: /chat [channel]
  description: Manages your chat channels that you hear and speak in.
  debug: false
  tab complete:
    - if <context.args.is_empty>:
      - determine <yaml[chat_config].list_keys[channels].filter_tag[<player.has_permission[<yaml[chat_config].read[channels.<[filter_value]>.permission]>]>]>
    - else:
      - determine <yaml[chat_config].list_keys[channels].filter_tag[<player.has_permission[<yaml[chat_config].read[channels.<[filter_value]>.permission]>]>].filter[starts_with[<context.args.get[1]>]]>
  script:
  #^- if <context.args.get[1]||null> == null:
    - if <context.args.is_empty>:
      - inject chat_settings_open
      - stop

    - else if <context.args.size> > 1:
      - define "Invalid Chat Channel."
      - inject Command_Error

    - define Channel <context.args.first.to_lowercase>
    - if <yaml[chat_config].contains[channels.<[Channel]>]> && ( <player.has_permission[<yaml[chat_config].read[channels.<[Channel]>.permission]>]> || <yaml[chat_config].read[channels.<[Channel]>.permission]> == none ):
      - yaml set id:global.player.<player.uuid> chat.channels.current:<[Channel]>
      - if !<yaml[global.player.<player.uuid>].read[chat.channels.active].contains[<[Channel]>]>:
        - yaml id:global.player.<player.uuid> set chat.channels.active:->:<[Channel]>
      - narrate "<&b>Now Talking in <yaml[chat_config].read[channels.<[Channel]>.format.channel].parsed>"
    - if <[Channel]> == reload:
      - inject chat_settings_reload
      - foreach <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>|<bungee.server>]> as:server:
        - bungeerun <[server]> chat_settings_reload
      - bungee relay:
        - reload
      - narrate "<&a>Chat config has been globally reloaded."

chat_send_message:
  type: task
  debug: false
#@definitions: channel|message_escaped
  definitions: Channel|Message
  script:
    #^- narrate "<[message_escaped].unescaped>" targets:<server.online_players_flagged[chat_channel_<[channel]>]>
      - narrate "<[Message]>" targets:<server.online_players_flagged[chat_channel_<[channel]>]>
      - inject chat_history_save

chat_system_flag_manager:
  type: world
  debug: false
  events:
    on player joins server:
      - waituntil rate:10t <yaml.list.contains[global.player.<player.uuid>].or[<player.is_online.not>]>
      - if !<player.is_online>:
        - stop
    #^- if <yaml[global.player.<player.uuid>].read[chat.channels]||null> == null:
      - if !<yaml[global.player.<player.uuid>].contains[chat.channels]>:
          - yaml id:global.player.<player.uuid> set chat.channels.active:!|:global|server
          - yaml id:global.player.<player.uuid> set chat.channels.current:global
      - foreach <yaml[global.player.<player.uuid>].read[chat.channels.active]>:
        - flag player chat_channel_<[value]>
      - inject chat_history_show
  #^on player quits:
  #^  - foreach <yaml[chat_config].list_keys[channels]>:
  #^    - if <player.has_flag[chat_channel_<[value]>]>:
  #^      - flag player chat_channel_<[value]>:!

chat_system_data_manager:
  type: world
  debug: false
  events:
    on server start:
      - inject chat_settings_reload
    on script reload:
      - inject chat_settings_reload
    on delta time minutely:
        - ~yaml id:chat_history savefile:data/chat_history.yml

chat_settings_reload:
  type: task
  debug: false
  script:
    - if <server.has_file[data/global/chat/channels.yml]>:
      - if <yaml.list.contains[chat_config]>:
        - yaml id:chat_config unload
      - yaml id:chat_config load:data/global/chat/channels.yml
    - if !<yaml.list.contains[chat_history]>:
      - if <server.has_file[data/chat_history.yml]>:
        - yaml id:chat_history load:data/chat_history.yml
      - else:
        - yaml create id:chat_history
    - else:
      - yaml id:chat_history unload
      - yaml id:chat_history load:data/chat_history.yml

chat_settings:
  type: inventory
  debug: false
  inventory: chest
  title: <&6>Chat Settings
  slots: 45
  definitions:
    filler: <item[white_Stained_glass_pane].with[display_name=<&1>]>
  slots:
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"
    - "[filler] [] [filler] [] [filler] [] [filler] [] [filler]"
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"
    - "[filler] [] [filler] [] [filler] [] [filler] [] [filler]"
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"

chat_settings_events:
  type: world
  debug: false
  events:
    on player clicks item in chat_settings:
      - determine passively cancelled
      - wait 1t
      - if <context.item.has_nbt[action]>:
        - choose <context.click>:
          - case LEFT:
            - if <yaml[global.player.<player.uuid>].read[chat.channels.active].contains[<context.item.nbt[action]>]>:
              - if <yaml[global.player.<player.uuid>].read[chat.channels.current]> == <context.item.nbt[action]>:
                - narrate "<&c>You cannot stop listening to the channel you're talking in."
                - stop
              - yaml set id:global.player.<player.uuid> chat.channels.active:<-:<context.item.nbt[action]>
              - flag player chat_channel_<context.item.nbt[action]>:!
              - narrate "<&b>You are no longer listening to <yaml[chat_config].read[channels.<context.item.nbt[action]>.format.channel].parsed>"
            - else:
              - yaml set id:global.player.<player.uuid> chat.channels.active:|:<context.item.nbt[action]>
              - flag player chat_channel_<context.item.nbt[action]>
              - narrate "<&b>You are now listening to <yaml[chat_config].read[channels.<context.item.nbt[action]>.format.channel].parsed>"
          - case RIGHT:
            - if <yaml[global.player.<player.uuid>].read[chat.channels.current]> != <context.item.nbt[action]>:
              - yaml set id:global.player.<player.uuid> chat.channels.current:<context.item.nbt[action]>
              - narrate "<&b>You are now talking in <yaml[chat_config].read[channels.<context.item.nbt[action]>.format.channel].parsed>"
        - inject chat_settings_open
            

chat_settings_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[chat_settings]>
    - foreach <yaml[chat_config].list_keys[channels]> as:channel:
      - define name <yaml[chat_config].read[channels.<[channel]>.format.channel].parsed>
      - if <player.has_permission[<yaml[chat_config].read[channels.<[channel]>.permission]>]> || <yaml[chat_config].read[channels.<[channel]>.permission]> == none:
        - if <yaml[global.player.<player.uuid>].read[chat.channels.active].contains[<[channel]>]>:
          - define icon <item[green_wool]>
          - define "lore:!|:<&a>You are listening to this channel."
          - define "lore:|:<&a>-----------------------------"
          - define "lore:|:<&b>Left click to stop listening."
        - else:
          - define icon <item[red_wool]>
          - define "lore:!|:<&c>You are not listening to this channel."
          - define "lore:|:<&a>-----------------------------"
          - define "lore:|:<&b>Left click to start listening."
        - if <yaml[global.player.<player.uuid>].read[chat.channels.current]> == <[channel]>:
          - define icon <item[yellow_wool]>
          - define lore "<[lore].insert[<&e>You are talking in this channel.].at[2]>"
        - else:
          - define "lore:|:<&b>right click to start speaking."
        - define list:|:<[icon].with[display_name=<[name]>;lore=<[lore]>;nbt=action/<[channel]>]>
    - repeat <[list].size.-[8].abs>:
      - define list:|:<script[chat_settings].data_key[definitions.filler].parsed.with[nbt=unique/<util.random.uuid>]>
    - give <[list]> to:<[inventory]>
    - inventory open d:<[inventory]>
