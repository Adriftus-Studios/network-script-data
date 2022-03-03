chat_system_events:
  type: world
  debug: false
  events:
    on player chats bukkit_priority:LOWEST:
      - determine passively cancelled
      - waituntil rate:1s <bungee.connected>
      - define channel <yaml[global.player.<player.uuid>].read[chat.channels.current]||server>
      - define uuid <util.random_uuid>
      - define sender <player.uuid>

      # Check for Chat Lock
      - if <yaml[global.player.<player.uuid>].read[chat.locked]||false> && <yaml[chat_config].parsed_key[channels.<[channel]>.chat_lock_deny]||false>:
        - narrate "<&c>You are unable to speak in this channel, due to being chat locked."
        - stop

      # Allow Chat Colors in Chat
      - if <player.has_permission[adriftus.chat.color]>:
        - define msg <context.message.parse_color>
      - else:
        - define msg <context.message.parse_color.strip_color>

      # Allow Items in Chat
      - if <[msg].contains_text[<&lb>item<&rb>]> && <player.has_permission[adriftus.chat.link_item]>:
        - define msg <[msg].replace_text[<&lb>item<&rb>].with[<&hover[<player.item_in_hand>].type[SHOW_ITEM]><&lb><player.item_in_hand.display||<player.item_in_hand.material.translated_name>><&rb><&end_hover>]>

      # Build the Channel Text
      - define Hover "<&color[#F3FFAD]>Click to switch to<&color[#26FFC9]>: <&color[#C1F2F7]><[channel].to_titlecase>"
      - define Text <yaml[chat_config].parsed_key[channels.<[channel]>.format.channel]>
      - define Command "chat <[channel]>"
      - define ChannelText <proc[msg_cmd].context[<[Hover]>|<[Text]>|<[Command]>]>

      # Build the Player Text
      - if <yaml[global.player.<player.uuid>].contains[rank]>:
        - define Hover "<&color[#F3FFAD]>Name<&color[#26FFC9]>: <&color[#C1F2F7]><player.name><&nl><&color[#F3FFAD]>Server<&color[#26FFC9]>: <&color[#C1F2F7]><bungee.server.to_titlecase><&nl><&color[#F3FFAD]>Rank<&color[#26FFC9]>: <&color[#C1F2F7]><yaml[global.player.<player.uuid>].read[rank]>"
      - else:
        - define Hover "<&color[#F3FFAD]>Name<&color[#26FFC9]>: <&color[#C1F2F7]><player.name><&nl><&color[#F3FFAD]>Title<&color[#26FFC9]>: <player.proc[get_player_title]><&nl><&color[#F3FFAD]>Server<&color[#26FFC9]>: <&color[#C1F2F7]><bungee.server.to_titlecase>"
      - define Text <yaml[chat_config].parsed_key[channels.<[channel]>.format.name]>
      - define Hint "msg <player.name> "
      - define NameText <proc[msg_hint].context[<[Hover]>|<[Text]>|<[Hint]>]>

      # Separator
      - define Separator <yaml[chat_config].parsed_key[channels.<[channel]>.format.separator]>

      # Build the Message Content
      - define Hover "<&color[#F3FFAD]>Timestamp<&color[#26FFC9]>: <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>]>"
      - define Text <yaml[chat_config].parsed_key[channels.<[channel]>.format.message]>
      - define Command "chat interact <[channel]> <[uuid]>"
      - define MessageText <proc[msg_cmd].context[<[Hover]>|<[Text]>|<[Command]>]>

      - define Message <[ChannelText]><[NameText]><[Separator]><[MessageText]>

      - narrate <[message]> targets:<server.online_players_flagged[chat.channels.<[channel]>]>
      - if <yaml[chat_config].read[channels.<[channel]>.global]>:
        - define Servers <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>].exclude[<bungee.server>]>
        - bungeerun <[Servers]> chat_send_message def:<[channel]>|<[message]>|<[uuid]>|<[sender]>
        - if <yaml[chat_config].read[channels.<[channel]>.integrations.Discord.active]>:
          - bungeerun relay chat_send_message def:<list_single[<context.message>].include[<[Channel]>|<bungee.server>|<player.uuid>].include_single[<player.name.strip_color>]>
      - run chat_history_save def:<[channel]>|<[message]>|<[uuid]>|<[sender]>

chat_history_save:
  type: task
  debug: false
  definitions: Channel|Message|UUID|sender
  script:
    - yaml id:chat_history set <[channel]>_history:->:<map[channel=<[channel]>;message=<[Message]>;time=<server.current_time_millis>;uuid=<[UUID]>;sender=<[sender]||DiscordUser>]>
    - if <yaml[chat_history].read[<[channel]>_history].size> > 50:
      - yaml id:chat_history set <[channel]>_history:!|:<yaml[chat_history].read[<[channel]>_history].remove[first]>

chat_history_show:
  type: task
  debug: false
  script:
    - narrate <element[<&nl>].repeat_as_list[30].separated_by[<&nl>]>
    - define list <list>
    - foreach <yaml[global.player.<player.uuid>].list_keys[chat.channels.active].filter_tag[<yaml[chat_config].list_keys[channels].contains[<[Filter_Value]>]>]> as:Channel:
      - if !<yaml[chat_history].contains[<[Channel]>_history]> || !<player.has_flag[chat.channels.<[channel]>]>:
        - foreach next
      - define list:|:<yaml[chat_history].parsed_key[<[Channel]>_history]>
    - if <[List].is_empty>:
      - stop
    - foreach <[list].sort_by_number[get[time]].reverse.get[1].to[30].reverse.parse[get[message]]> as:Message:
      - narrate <[Message]>

chat_delete_message:
  type: task
  debug: false
  definitions: channel|uuid|relay|lock
  script:
    - if <yaml[chat_config].read[channels.<[channel]>.global]>:
      - define Servers <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>].exclude[<bungee.server>]>
    - bungeerun <[Servers]> chat_delete_message def:<[channel]>|<[uuid]>|false if:<[relay]||true>
    - define message <yaml[chat_history].parsed_key[<[channel]>_history].filter_tag[<[filter_value].get[uuid].equals[<[uuid]>]>].get[1]>
    - define new_message_map "<[message].with[message].as[<&7><&lb>Message Deleted<&rb>]>"
    - foreach <yaml[chat_history].parsed_key[<[channel]>_history]> as:message_map:
      - if <[message_map].get[uuid]> == <[uuid]>:
        - yaml id:chat_history set <[channel]>_history:!|:<yaml[chat_history].parsed_key[<[channel]>_history].overwrite[<[new_message_map]>].at[<[loop_index]>]>
    - foreach <server.online_players_flagged[chat.channels.<[channel]>]>:
      - run chat_history_show player:<[value]>
      - wait 1t
    - if <[lock]||false>:
      - run chatlock_task def:<[message].get[sender]>|<[message]>
    - inject chat_interact_cancel

chatdelete_command:
  type: command
  name: chatdelete
  usage: /chatdelete (channel) (message uuid) (lock)
  description: Designed for automated use and not manual entry
  permission: adriftus.chat.delete
  debug: false
  script:
    - if <context.args.size> < 2:
      - narrate "<&c>Not intended for manual usage..."
    - run chat_delete_message def:<context.args.get[1]>|<context.args.get[2]>|false|<context.args.get[3]||false>

chatlock_command:
  type: command
  name: chatlock
  usage: /chatlock (player name)
  description: Will prevent player from speaking in chatlock-able channels
  debug: false
  tab complete:
    1: <server.online_players.parse[name].include[<server.flag[player_map.names].keys>]>
  script:
    - if <context.args.is_empty>:
      - narrate "<&c>You must specify a player name to chat lock."
      - stop
    - if !<server.has_flag[player_map.names.<context.args.get[1]>.server]>:
      - narrate "<&c>Unknown Player<&co> <context.args.get[1]>"
      - stop
    - run chatlock_task def:<server.flag[player_map.names.<context.args.get[1]>.uuid]>

chatlock_task:
  type: task
  debug: false
  definitions: uuid|message_map
  script:
    - if <[message_map].exists>:
      - if <[message_map].get[sender]> == DiscordUser:
        - narrate "<&c>Unable to Chat Lock a Discord User at this time."
        - stop
      - run global_player_data_modify def:<server.flag[player_map.uuids.<[uuid]>.uuid]>|chat.locked|<[message_map].get[message]>
      - define border <element[------------------].color_gradient[from=<color[aqua]>;to=<color[white]>]>
      - define message "<&c>You have been chat locked for the above message. You are restricted to speaking in the <&b>Anarchy<&c> channel only."
      - define chatlock_notification <[border]><&nl><&nl><[message_map].get[message]><&nl><[message]><&nl><[border]>
      - run bungee_send_message def:<server.flag[player_map.uuids.<[uuid]>.uuid]>|<[chatlock_notification]>
      - inject chat_interact_cancel
      - narrate "<&a>Player <&b><[uuid]> <&a>has been Chat Locked."
    - else:
      - run global_player_data_modify def:<server.flag[player_map.uuids.<[uuid]>.uuid]>|chat.locked|true
      - define message "<&c>You have been chat locked. You are restricted to speaking in <&b>Anarchy<&c> channel only."
      - run bungee_send_message def:<server.flag[player_map.uuids.<[uuid]>.uuid]>|<[message]>
      - narrate "<&a>Player <&b><[uuid]> <&a>has been Chat Locked."

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
      - determine <yaml[chat_config].list_keys[channels].filter_tag[<player.has_permission[<yaml[chat_config].read[channels.<[filter_value]>.permission]>]>].filter[starts_with[<context.args.first>]]>
  script:
    - if <context.args.is_empty>:
      - inject chat_settings_open
      - stop

    - else if <context.args.get[1]> == interact && <context.args.size> > 1:
      - inject chat_interact

    - else if <context.args.size> > 1:
      - define reason "Invalid Chat Channel."
      - inject Command_Error

    - define Channel <context.args.first.to_lowercase>
    - if <yaml[chat_config].contains[channels.<[Channel]>]> && ( ( !<player.is_op> && <player.has_permission[<yaml[chat_config].read[channels.<[Channel]>.permission]>]> ) || <yaml[chat_config].read[channels.<[Channel]>.permission]> == none ):
      - run global_player_data_modify def:<player.uuid>|chat.channels.current|<[Channel]>
      - if !<yaml[global.player.<player.uuid>].read[chat.channels.active.<[Channel]>]>:
        - run global_player_data_modify def:<player.uuid>|chat.channels.active.<[Channel]>|true
      - narrate "<&b>Now Talking in <yaml[chat_config].parsed_key[channels.<[Channel]>.format.channel]>"
    - if <[Channel]> == reload && <player.has_permission[adriftus.chat.reload]>:
      - inject chat_settings_reload
      - foreach <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>|<bungee.server>]> as:server:
        - bungeerun <[server]> chat_settings_reload
      - bungee relay:
        - reload
      - narrate "<&a>Chat config has been globally reloaded."

chat_interact:
  type: task
  debug: false
  script:
    - if !<player.has_permission[adriftus.chat.moderate]>:
      - stop
    - if <context.args.get[2]> == cancel:
      - inject chat_interact_cancel
      - stop
    - if <yaml[global.player.<player.uuid>].list_keys[chat.channels.active].contains[<context.args.get[2]>]>:
      - define message <yaml[chat_history].parsed_key[<context.args.get[2]>_history].filter_tag[<[filter_value].get[uuid].equals[<context.args.get[3]>]>]>
      - if !<[message].is_empty>:
        - define message <[message].get[1]>
        - flag player chat.paused:<player.flag[chat.channels].keys>
        - flag player chat.channels:!
        - narrate <element[<&nl>].repeat_as_list[40].separated_by[<&nl>]>
        - narrate <element[------------------].color_gradient[from=<color[aqua]>;to=<color[white]>]>
        - narrate <[message].get[message]>
        - define delete "<element[<&c><&lb>Delete<&rb><&r>].on_hover[<&c>Delete this message].on_click[/chatdelete <context.args.get[2]> <[message].get[uuid]>].type[run_command]>"
        - define delete_and_lock "<element[<&4><&lb>Delete & Lock<&rb><&r>].on_hover[<&c>Delete this message, and chat lock the player].on_click[/chatdelete <context.args.get[2]> <[message].get[uuid]> true].type[run_command]>"
        - define cancel "<element[<&b><&lb>Cancel<&rb><&r>].on_hover[<&c>Cancel Moderation Action].on_click[/chat interact cancel].type[run_command]>"
        - narrate "   <[delete]>     <[delete_and_lock]>     <[cancel]>"
        - narrate <element[------------------].color_gradient[from=<color[aqua]>;to=<color[white]>]>
    - stop

chat_interact_cancel:
  type: task
  debug: false
  script:
    - if <player.has_flag[chat.paused]>:
      - foreach <player.flag[chat.paused]>:
        - flag player chat.channels.<[value]>
      - flag player chat.paused:!
      - inject chat_history_show

chat_send_message:
  type: task
  debug: false
#@definitions: channel|message_escaped
  definitions: Channel|Message|UUID|Sender
  script:
      - narrate <[Message]> targets:<server.online_players_flagged[chat.channels.<[channel]>]>
      - inject chat_history_save

chat_system_flag_manager:
  type: world
  debug: false
  events:
    after player joins:
      - waituntil rate:10t <yaml.list.contains[global.player.<player.uuid>].or[<player.is_online.not>]>
      - if !<player.is_online>:
        - stop
      - if !<yaml[global.player.<player.uuid>].contains[chat.channels]> || <yaml[global.player.<player.uuid>].read[chat.channels].object_type> == List:
          - define map <map[chat.channels.active=<list[server]>;chat.channels.current=server]>
          - run global_player_data_modify def:<player.uuid>|<[map]>
      - foreach <yaml[global.player.<player.uuid>].list_keys[chat.channels.active]>:
        - flag player chat.channels.<[value]>
      - inject chat_history_show

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
  gui: true
  title: <&6>Chat Settings
  size: 45
  slots:
    - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]
    - [standard_filler] [] [standard_filler] [] [standard_filler] [] [standard_filler] [] [standard_filler]
    - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]
    - [standard_filler] [] [standard_filler] [] [standard_filler] [] [standard_filler] [] [standard_filler]
    - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]

chat_settings_events:
  type: world
  debug: false
  events:
    on player clicks item in chat_settings:
      - determine passively cancelled
      - wait 1t
      - if <context.item.has_flag[action]>:
        - choose <context.click>:
          - case RIGHT:
            - if <yaml[global.player.<player.uuid>].read[chat.channels.active.<context.item.flag[action]>]>:
              - if <yaml[global.player.<player.uuid>].read[chat.channels.current]> == <context.item.flag[action]>:
                - narrate "<&c>You cannot stop listening to the channel you're talking in."
                - stop
              - run global_player_data_modify def:<player.uuid>|chat.channels.active.<context.item.flag[action]>|false
              - flag player chat.channels.<context.item.flag[action]>:!
              - narrate "<&b>You are no longer listening to <yaml[chat_config].parsed_key[channels.<context.item.flag[action]>.format.channel]>"
            - else:
              - run global_player_data_modify def:<player.uuid>|chat.channels.active.<context.item.flag[action]>|true
              - flag player chat.channels.<context.item.flag[action]>
              - narrate "<&b>You are now listening to <yaml[chat_config].parsed_key[channels.<context.item.flag[action]>.format.channel]>"
          - case LEFT:
            - if <yaml[global.player.<player.uuid>].read[chat.channels.current]> != <context.item.flag[action]>:
              - run global_player_data_modify def:<player.uuid>|chat.channels.current|<context.item.flag[action]>
              - narrate "<&b>You are now talking in <yaml[chat_config].parsed_key[channels.<context.item.flag[action]>.format.channel]>"
        - inject chat_settings_open
    on player closes chat_settings:
      - run chat_history_show

chat_settings_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[chat_settings]>
    - foreach <yaml[chat_config].list_keys[channels]> as:channel:
      - define name <yaml[chat_config].parsed_key[channels.<[channel]>.format.channel]>
      - if ( !<player.is_op> && <player.has_permission[<yaml[chat_config].read[channels.<[channel]>.permission]>]> ) || <yaml[chat_config].read[channels.<[channel]>.permission]> == none:
        - if <yaml[global.player.<player.uuid>].read[chat.channels.active.<[channel]>]>:
          - define icon <item[green_wool]>
          - define "lore:!|:<&a>You are listening to this channel."
          - define lore:->:<&a>-----------------------------
          - define "lore:|:<&b>Right click to stop listening."
        - else:
          - define icon <item[red_wool]>
          - define "lore:!|:<&c>You are not listening to this channel."
          - define lore:->:<&a>-----------------------------
          - define "lore:|:<&b>Right click to start listening."
        - if <yaml[global.player.<player.uuid>].read[chat.channels.current]> == <[channel]>:
          - define icon <item[yellow_wool]>
          - define lore "<[lore].insert[<&e>You are talking in this channel.].at[2]>"
        - else:
          - define "lore:|:<&b>Left click to speak in this channel."
        - define list:->:<[icon].with[display_name=<[name]>;lore=<[lore]>].with_flag[action:<[channel]>]>
    - repeat <[list].size.sub[8].abs>:
      - define list:->:<item[standard_filler].with_flag[unique:<util.random_uuid>]>
    - give <[list]> to:<[inventory]>
    - inventory open d:<[inventory]>