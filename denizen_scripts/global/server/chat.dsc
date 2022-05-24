chat_system_events:
  type: world
  debug: false
  events:
    on player chats bukkit_priority:LOWEST:
      - inject chat_system_speak

chat_system_speak:
  type: task
  debug: false
  definitions: message|channel
  script:
      - determine passively cancelled
      - define msg <[message].if_null[<context.message>]>
      - define raw_message <[message].if_null[<context.message>]>
      - waituntil rate:1s <bungee.connected>
      - if !<[channel].exists>:
        - define channel <yaml[global.player.<player.uuid>].read[chat.channels.current].if_null[server]>
      - define uuid <util.random_uuid>
      - define sender <player.uuid>

      # Determine Chat Icon
      - define icon <yaml[global.player.<player.uuid>].parsed_key[chat.icon].if_null[null]>
      - if <[channel]> == server:
        - define icon <yaml[chat_config].parsed_key[channels.<[channel]>.icon.<bungee.server>].if_null[null]> if:<[icon].equals[null]>
      - else:
        - define icon <yaml[chat_config].parsed_key[channels.<[channel]>.icon].if_null[null]> if:<[icon].equals[null]>
      - define icon <&chr[0001]> if:<[icon].equals[null]>

      # Check for Chat Lock
      - if <yaml[global.player.<player.uuid>].read[chat.locked].if_null[false]> && <yaml[chat_config].parsed_key[channels.<[channel]>.chat_lock_deny].if_null[false]>:
        - narrate "<&c>You are unable to speak in this channel, due to being chat locked."
        - stop

      # Allow Chat Colors in Chat
      - if <player.has_permission[adriftus.chat.color]>:
        # Custom Color Codes
        - if <[msg].starts_with[&z]>:
          - define msg <[msg].after[&z].rainbow>
        - else:
          - define msg <[msg].parse_color>
      - else:
        - define msg <[msg].parse_color.strip_color>

      # Allow Items in Chat
      - if <[msg].contains_text[<&lb>item<&rb>]> && <player.has_permission[adriftus.chat.link_item]>:
        - define msg <[msg].replace_text[<&lb>item<&rb>].with[<&hover[<player.item_in_hand>].type[SHOW_ITEM]><&7><&lb><player.item_in_hand.display||<player.item_in_hand.material.translated_name>><&7><&rb><&r><&end_hover>]>

      # Build the Channel Text
      - define Hover "<&color[#F3FFAD]>Click to switch to<&color[#26FFC9]>: <&color[#C1F2F7]><[channel].to_titlecase>"
      - define Text <&font[adriftus:chat]><[Icon]><&r><&sp><yaml[chat_config].parsed_key[channels.<[channel]>.format.channel]>
      - define Command "chat <[channel]>"
      - define ChannelText <proc[msg_cmd].context[<list_single[<[hover]>].include_single[<[text]>].include_single[<[command]>]>]>
      - define ChannelSpaceText <proc[msg_cmd].context[<list_single[<[hover]>].include_single[<&sp><&sp><&sp><&sp>].include_single[<[command]>]>]>

      # Build the Player Text
      - if <yaml[global.player.<player.uuid>].contains[masks.current]>:
        - define Hover "<&color[#F3FFAD]>Name<&color[#26FFC9]>: <&d>DISGUISED<&nl><&color[#F3FFAD]>Title<&color[#26FFC9]>: <player.proc[get_player_title]><&nl><&color[#F3FFAD]>Server<&color[#26FFC9]>: <&color[#C1F2F7]><bungee.server.to_titlecase>"
        - define Text <&chr[F802]><yaml[chat_config].parsed_key[channels.<[channel]>.format.name]>
        - define NameText <proc[msg_hover].context[<list_single[<[hover]>].include_single[<[text]>]>]>
      - else:
        - define Hover "<&color[#F3FFAD]>Name<&color[#26FFC9]>: <proc[get_player_display_color]><proc[get_player_display_name]><&nl><&color[#F3FFAD]>Title<&color[#26FFC9]>: <player.proc[get_player_title]><&nl><&color[#F3FFAD]>Server<&color[#26FFC9]>: <&color[#C1F2F7]><bungee.server.to_titlecase>"
        - define Hint "msg <player.name> "
        - define Text <&chr[F802]><yaml[chat_config].parsed_key[channels.<[channel]>.format.name]>
        - define NameText <proc[msg_hint].context[<list_single[<[hover]>].include_single[<[text]>].include_single[<[hint]>]>]>

      # Separator
      - define Separator <yaml[chat_config].parsed_key[channels.<[channel]>.format.separator]>

      # Build the Message Content
      - define Hover "<&color[#F3FFAD]>Timestamp<&color[#26FFC9]>: <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>]>"
      - define Text <yaml[chat_config].parsed_key[channels.<[channel]>.format.message]>
      - define Command "chat interact <[channel]> <[uuid]>"
      - define MessageText <[Text].on_hover[<[Hover]>].on_click[/<[Command]>]>

      ## Needs to be made per-player, depending on chat channels.
      #- if <player.uuid> == <yaml[chat_history].read[<[channel]>_history].last.get[sender]> && <server.current_time_millis.sub[<yaml[chat_history].read[<[channel]>_history].last.get[time]>]> < 120000:
        #- define Message <&sp><&sp><&sp><&sp><&sp><[MessageText]>
      #- else:
        #- define Message <&nl><&font[adriftus:chat]><[Icon]><&r><&sp><[ChannelText]><&r><[NameText]><&nl><&sp><&sp><&sp><&sp><&sp><[MessageText]>

      - define Message <[ChannelText]><&r><[NameText]><&co><&nl><[ChannelSpaceText]><&sp><[MessageText]>

      - narrate <[message]> targets:<server.online_players_flagged[chat.channels.<[channel]>]>
      - if <yaml[chat_config].read[channels.<[channel]>.global]>:
        - define Servers <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>].exclude[<bungee.server>]>
        - bungeerun <[Servers]> chat_send_message def:<list_single[<[channel]>].include_single[<[message]>].include_single[<[uuid]>].include_single[<[sender]>]>
      - if <[channel]> == server:
        - if <yaml[chat_config].read[channels.<[channel]>.integrations.Discord.<bungee.server>.active].if_null[false]> && <yaml[chat_config].read[channels.<[channel]>.integrations.Discord.<bungee.server>.to-Discord].if_null[false]>:
          - bungeerun relay chat_send_message def:<list_single[<[raw_message]>].include[<[Channel]>|<bungee.server>|<player.uuid>].include_single[<player.name.strip_color>].include_single[<[uuid]>].include[<[Message]>]>
      - else if <yaml[chat_config].read[channels.<[channel]>.integrations.Discord.active]> && <yaml[chat_config].read[channels.<[channel]>.integrations.Discord.to-Discord]>:
        - bungeerun relay chat_send_message def:<list_single[<[raw_message]>].include[<[Channel]>|<bungee.server>|<player.uuid>].include_single[<player.name.strip_color>].include_single[<[uuid]>].include[<[Message]>]>
      - run chat_history_save def:<list_single[<[channel]>].include_single[<[message]>].include_single[<[uuid]>].include_single[<[sender]>]>

chat_history_save:
  type: task
  debug: false
  definitions: Channel|Message|UUID|sender
  script:
    - if !<[Channel].exists> || !<[Message].exists> || !<[UUID].exists> || !<[sender].exists>:
      - stop
    - yaml id:chat_history set <[channel]>_history:->:<map[channel=<[channel]>;time=<server.current_time_millis>;uuid=<[UUID]>;sender=<[sender]>].with[message].as[<[message]>]>
    - if <yaml[chat_history].read[<[channel]>_history].size> > 40:
      - define temp <yaml[chat_history].read[<[channel]>_history].remove[first]>
      - yaml id:chat_history set <[channel]>_history:!
      - yaml id:chat_history set <[channel]>_history:|:<[temp]>

chat_history_show:
  type: task
  debug: false
  script:
    - narrate <element[<&nl>].repeat_as_list[30].separated_by[<&nl>]>
    - define list <list>
    - foreach <yaml[global.player.<player.uuid>].list_keys[chat.channels.active].filter_tag[<yaml[chat_config].list_keys[channels].contains[<[Filter_Value]>]>]> as:Channel:
      - if !<yaml[chat_history].contains[<[Channel]>_history]> || !<player.has_flag[chat.channels.<[channel]>]>:
        - foreach next
      - define list:|:<yaml[chat_history].read[<[Channel]>_history].filter[get[time].is_integer]>
    - if <yaml[global.player.<player.uuid>].contains[chat.message.history]>:
      - define list:|:<yaml[global.player.<player.uuid>].read[chat.message.history].filter[get[time].is_integer]>
    - if <[List].is_empty>:
      - stop
    - define sorted_list <[list].sort_by_number[get[time]].reverse>
    #- foreach <[list].sort_by_number[get[time]].reverse.get[1].to[30].reverse.parse[get[message]]> as:Message:
      #- narrate <[Message]>
    #- if <[sorted_list].size> > 30:
      #- narrate <[sorted_list].get[31].to[60].reverse.parse[get[message]].separated_by[<&nl>]>
    - narrate <element[<&nl>].repeat_as_list[50].include[<[sorted_list].get[1].to[40].reverse.parse[get[message]]>].separated_by[<&nl>]>

chat_delete_message:
  type: task
  debug: false
  definitions: channel|uuid|relay|lock|from_relay
  script:
    - define from_relay false if:<[from_relay].exists.not>
    - if <yaml[chat_config].read[channels.<[channel]>.global]>:
      - define Servers <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>].exclude[<bungee.server>]>
      - bungeerun <[Servers]> chat_delete_message def:<[channel]>|<[uuid]>|false if:<[relay]>
    - if <[relay]> && !<[from_relay]>:
      - if <[channel]> == server:
        - if <yaml[chat_config].read[channels.<[channel]>.integrations.Discord.<bungee.server>.active].if_null[false]>:
          - bungeerun relay discord_delete_message_from_chat def:<[channel]>_<bungee.server>|<[uuid]>
      - else if <yaml[chat_config].read[channels.<[channel]>.integrations.Discord.active]>:
        - bungeerun relay discord_delete_message_from_chat def:<[channel]>|<[uuid]>
    - define message <yaml[chat_history].read[<[channel]>_history].filter_tag[<[filter_value].get[uuid].equals[<[uuid]>]>].get[1]>
    - define new_message_map "<[message].with[message].as[<&7><&lb>Message Deleted<&rb>]>"
    - foreach <yaml[chat_history].read[<[channel]>_history]> as:message_map:
      - if <[message_map].get[uuid]> == <[uuid]>:
        - yaml id:chat_history set <[channel]>_history:!|:<yaml[chat_history].read[<[channel]>_history].overwrite[<[new_message_map]>].at[<[loop_index]>]>
    - foreach <server.online_players_flagged[chat.channels.<[channel]>]>:
      - run chat_history_show player:<[value]>
      - wait 1t
    - if <[lock]||false>:
      - run chatlock_task def:<list_single[<[message].get[sender]>].include_single[<[message]>]>
    - inject chat_unpause if:<player.exists>

chat_edit_message:
  type: task
  debug: false
  definitions: channel|message|uuid
  script:
    - define channel server if:<[channel].starts_with[server]>
    - foreach <yaml[chat_history].read[<[channel]>_history]>:
      - if <[value].get[uuid]> == <[uuid]>:
        - define map <[value].with[message].as[<[message]>]>
        - yaml id:chat_history set <[channel]>_history:!|:<yaml[chat_history].read[<[channel]>_history].overwrite[<[map]>].at[<[loop_index]>]>
    - foreach <server.online_players_flagged[chat.channels.<[channel]>]>:
      - run chat_history_show player:<[value]>
      - wait 1t

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
    - run chat_delete_message def:<context.args.get[1]>|<context.args.get[2]>|true|<context.args.get[3]||false>

chatlock_command:
  type: command
  name: chatlock
  usage: /chatlock (player name)
  description: Will prevent player from speaking in chatlock-able channels
  debug: false
  tab completions:
    1: <server.flag[player_map.names].keys>
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
      - if <[message_map].get[sender].starts_with[DiscordUser_]>:
        - narrate "<&c>Unable to Chat Lock a Discord User at this time."
        - stop
      - run global_player_data_modify def:<[uuid]>|chat.locked|true
      - define border <element[------------------].color_gradient[from=<color[aqua]>;to=<color[white]>]>
      - define message "<&c>You have been chat locked for the above message. You are restricted to speaking in the <&b>Anarchy<&c> channel only."
      - define chatlock_notification <[border]><&nl><&nl><[message_map].get[message]><&nl><&nl><[message]><&nl><[border]>
      - run bungee_send_message def:<[uuid]>|system|<[chatlock_notification]>
      - inject chat_unpause
      - narrate "<&a>Player <&b><server.flag[player_map.uuids.<[uuid]>.name]> <&a>has been Chat Locked."
    - else:
      - run global_player_data_modify def:<[uuid]>|chat.locked|true
      - define message "<&c>You have been chat locked. You are restricted to speaking in <&b>Anarchy<&c> channel only."
      - run bungee_send_message def:<[uuid]>|system|<[message]>
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
      - foreach <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers].include[<bungee.server>]>]> as:server:
        - bungeerun <[server]> chat_settings_reload
      - bungee relay:
        - reload
      - narrate "<&a>Chat config has been globally reloaded."
    - if <[channel]> == debug_history && <player.has_permission[adriftus.admin]>:
      - narrate <element[<&nl>].repeat_as_list[30].separated_by[<&nl>]>
      - define list <list>
      - foreach <yaml[global.player.<player.uuid>].list_keys[chat.channels.active].filter_tag[<yaml[chat_config].list_keys[channels].contains[<[Filter_Value]>]>]> as:Channel:
        - if !<yaml[chat_history].contains[<[Channel]>_history]> || !<player.has_flag[chat.channels.<[channel]>]>:
          - foreach next
        - define list:|:<yaml[chat_history].read[<[Channel]>_history]>
      - if <[List].is_empty>:
        - stop
      - define sorted_list <[list].sort_by_number[get[time]]>
      - foreach <[sorted_list].filter[contains[time]]> as:Message:
        - if <[message].get[time]||null> == null:
          - narrate <[message]>


chat_interact:
  type: task
  debug: false
  script:
    - if !<player.has_permission[adriftus.chat.moderate]>:
      - stop
    - if <context.args.get[2]> == cancel:
      - inject chat_unpause
      - stop
    - if <yaml[global.player.<player.uuid>].list_keys[chat.channels.active].contains[<context.args.get[2]>]>:
      - define message <yaml[chat_history].parsed_key[<context.args.get[2]>_history].filter_tag[<[filter_value].get[uuid].equals[<context.args.get[3]>]>]>
      - if !<[message].is_empty>:
        - define message <[message].get[1]>
        - run chat_pause
        - narrate <element[------------------].color_gradient[from=<color[aqua]>;to=<color[white]>]>
        - narrate <&nl><&nl><[message].get[message]><&nl>
        - define list "<element[<&c><&lb>Delete<&rb><&r>].on_hover[<&c>Delete this message].on_click[/chatdelete <context.args.get[2]> <[message].get[uuid]>].type[run_command]>"
        - define "list:->:<element[<&4><&lb>Delete & Lock<&rb><&r>].on_hover[<&c>Delete this message, and pemanently chat lock the player].on_click[/chatdelete <context.args.get[2]> <[message].get[uuid]> true].type[run_command]>" if:<[message].get[sender].starts_with[DiscordUser_].not>
        - define "list:->:<element[<&b><&lb>Cancel<&rb><&r>].on_hover[<&c>Cancel Moderation Action].on_click[/chat interact cancel].type[run_command]>"
        - narrate "   <[list].separated_by[      ]>"
        - narrate <element[------------------].color_gradient[from=<color[aqua]>;to=<color[white]>]>
    - stop

chat_pause:
  type: task
  debug: false
  script:
    - if <player.has_flag[chat.paused]>:
      - stop
    - flag player chat.paused:<player.flag[chat.channels].keys>
    - flag player chat.channels:!
    - narrate <element[<&nl>].repeat_as_list[40].separated_by[<&nl>]>

chat_unpause:
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
  definitions: Channel|Message|UUID|Sender
  script:
      - narrate <[Message]> targets:<server.online_players_flagged[chat.channels.<[channel]>]>
      - inject chat_history_save

chat_send_server_message:
  type: task
  debug: false
  definitions: Channel|msg|UUID|Sender|author_name|edit|reply
  script:
        - define edit false if:<[edit].exists.not>
        - define Hover "<&color[#F3FFAD]>Message is from <&color[#738adb]>Discord<&color[#F3FFAD]>!"
        - define Text <&f><&chr[0044].font[adriftus:chat]>
        - define DiscIcon <proc[msg_hover].context[<[Hover]>|<[Text]>]>

      # Determine Chat Icon
        - define icon <yaml[chat_config].parsed_key[channels.<[channel]>.icon.<bungee.server>].if_null[null]>
        - define icon <&chr[0001]> if:<[icon].equals[null]>

        - define Hover "<&color[#F3FFAD]>Click to switch to<&color[#26FFC9]>: <&color[#C1F2F7]><[channel].to_titlecase>"
        - define Text <&font[adriftus:chat]><[icon]><&r><&f><&sp><&r><yaml[chat_config].parsed_key[channels.<[channel]>.format.channel]>
        - define Command "chat <[channel]>"
        - define ChannelText <proc[msg_cmd].context[<[Hover]>|<[Text]>|<[Command]>]>
        - define ChannelSpaceText <proc[msg_cmd].context[<list_single[<[hover]>].include_single[<&sp><&sp><&sp><&sp><&sp>].include_single[<[command]>]>]>

        - define Name <[author_name]>
        - define Hover "<&color[#F3FFAD]>Name<&color[#26FFC9]>: <&color[#C1F2F7]><[Name]><&nl><&color[#F3FFAD]>in-game name<&color[#26FFC9]>: <&7>Not Linked<&nl><&color[#F3FFAD]>Shift-Click to ping"
        - define Text <&7><[Name]>
        - define Insert @<[author_name]>
        - if <[reply].exists> && <[reply]> != none:
          - define NameText <proc[msg_hover_ins].context[<list_single[<[Hover]>].include[<[Text]>].include[<[Insert]>]>]><&co><&sp><[reply]>
        - else:
          - define NameText <proc[msg_hover_ins].context[<list_single[<[Hover]>].include[<[Text]>].include[<[Insert]>]>]>

        - define Separator <yaml[chat_config].parsed_key[channels.<[channel]>.format.separator]>

        - define Hover "<&color[#F3FFAD]>Timestamp<&color[#26FFC9]>: <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>]>"
        - define Text <yaml[chat_config].parsed_key[channels.<[channel]>.format.message].replace[]>
        - define Insert "chat interact <[channel]> <[uuid]>"
        - define MessageText <proc[msg_cmd].context[<list_single[<[Hover]>].include[<[Text]>].include[<[Insert]>]>]>
        - define Message <[ChannelText]><[DiscIcon]><&sp><[NameText]><&co><&nl><[ChannelSpaceText]><[MessageText]>
        - if <[edit]>:
          - run chat_edit_message def:server|<[message]>|<[uuid]>
        - else:
          - narrate <[Message]> targets:<server.online_players_flagged[chat.channels.server]>
          - inject chat_history_save

chat_system_flag_manager:
  type: world
  debug: false
  events:
    on custom event id:global_player_data_loaded:
      - flag player chat.channels:!
      - waituntil rate:10t <yaml.list.contains[global.player.<player.uuid>].or[<player.is_online.not>]>
      - if !<player.is_online>:
        - stop
      - if !<yaml[global.player.<player.uuid>].contains[chat.channels.active]> || <yaml[global.player.<player.uuid>].read[chat.channels.active].object_type> != Map:
          - define map <map[chat.channels.active.server=true;chat.channels.current=server]>
          - run global_player_data_modify_multiple def:<list_single[<player.uuid>].include_single[<[map]>]>
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

chat_back_to_main_menu:
  type: item
  material: feather
  display name: <&e>Back To Main Menu
  flags:
    run_script:
    - main_menu_inventory_open
    - cancel
  mechanisms:
    color: red
    custom_model_data: 3


chat_settings:
  type: inventory
  debug: false
  inventory: chest
  gui: true
  title: <&f><&font[adriftus:guis]><&chr[F808]><&chr[6926]>
  size: 45
  slots:
   - [] [] [] [] [] [] [] [] []
   - [] [] [] [] [] [] [] [] []
   - [] [] [] [] [] [] [] [] []
   - [] [] [] [] [] [] [] [] []
   - [chat_back_to_main_menu] [] [] [] [] [] [] [] []

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
            - if <yaml[global.player.<player.uuid>].read[chat.channels.active.<context.item.flag[action]>]||false>:
              - if <yaml[global.player.<player.uuid>].read[chat.channels.current]> == <context.item.flag[action]>:
                - narrate "<&c>You cannot stop listening to the channel you're talking in."
                - stop
              - run global_player_data_modify def:<player.uuid>|chat.channels.active.<context.item.flag[action]>|!
              - flag player chat.channels.<context.item.flag[action]>:!
              - narrate "<&b>You are no longer listening to <yaml[chat_config].parsed_key[channels.<context.item.flag[action]>.format.channel]>"
            - else:
              - run global_player_data_modify def:<player.uuid>|chat.channels.active.<context.item.flag[action]>|true
              - flag player chat.channels.<context.item.flag[action]>
              - narrate "<&b>You are now listening to <yaml[chat_config].parsed_key[channels.<context.item.flag[action]>.format.channel]>"
          - case LEFT:
            - if <yaml[global.player.<player.uuid>].read[chat.channels.current]> != <context.item.flag[action]>:
              - if !<yaml[global.player.<player.uuid>].read[chat.channels.active.<context.item.flag[action]>]||false>:
                - define map <map[chat.channels.current=<context.item.flag[action]>;chat.channels.active.<context.item.flag[action]>=true]>
                - run global_player_data_modify_multiple def:<list_single[<player.uuid>].include_single[<[map]>]>
                - flag player chat.channels.<context.item.flag[action]>
              - else:
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
    - define slots <list[11|13|15|17|29|31|33|35]>
    - foreach <yaml[chat_config].list_keys[channels]> as:channel:
      - define name <yaml[chat_config].parsed_key[channels.<[channel]>.format.channel]>
      - if ( !<player.is_op> && <player.has_permission[<yaml[chat_config].read[channels.<[channel]>.permission]>]> ) || <yaml[chat_config].read[channels.<[channel]>.permission]> == none:
        - if <yaml[global.player.<player.uuid>].read[chat.channels.active.<[channel]>]||false>:
          - if <[channel]> == server:
            - define icon <item[<yaml[chat_config].read[channels.server.settings_icon.<bungee.server>.active]>]>
          - else:
            - define icon <item[<yaml[chat_config].read[channels.<[channel]>.settings_icon.active]>]>
          - define "lore:!|:<&a>You are listening to this channel."
          - define lore:->:<&a>-----------------------------
          - define "lore:|:<&b>Right click to stop listening."
        - else:
          - if <[channel]> == server:
            - define icon <item[<yaml[chat_config].read[channels.server.settings_icon.<bungee.server>.inactive]>]>
          - else:
            - define icon <item[<yaml[chat_config].read[channels.<[channel]>.settings_icon.inactive]>]>
          - define "lore:!|:<&c>You are not listening to this channel."
          - define lore:->:<&a>-----------------------------
          - define "lore:|:<&b>Right click to start listening."
        - if <yaml[global.player.<player.uuid>].read[chat.channels.current]> == <[channel]>:
          # Need Icon Here
          #- define icon <item[yellow_wool]>
          - define lore "<[lore].insert[<&e>You are talking in this channel.].at[2]>"
        - else:
          - define "lore:|:<&b>Left click to speak in this channel."
        - define list:->:<[icon].with[display_name=<[name]>;lore=<[lore]>].with_flag[action:<[channel]>]>
    - repeat <[list].size.sub[8].abs>:
      - define list:->:<item[standard_filler].with_flag[unique:<util.random_uuid>]>
    - foreach <[list]>:
      - inventory set slot:<[slots].get[<[loop_index]>]> o:<[value]> d:<[inventory]>
    - inventory open d:<[inventory]>

message_command:
  type: command
  name: msg
  debug: false
  usage: /msg (player) (message)
  aliases:
    - reply
    - r
  description: Message another player
  tab completions:
    1: <server.flag[player_map.names].keys>
  script:
    - if <context.alias> == reply || <context.alias> == r:
      - if <yaml[global.player.<player.uuid>].contains[chat.last_message.sender]>:
        - define target_name <yaml[global.player.<player.uuid>].read[chat.last_message.sender]>
      - else:
        - narrate "<&c>No one has messaged you recently."
        - stop
    - else:
      - if <context.args.size> <= 1:
         - narrate "<&c>You need to include a player and a message!"
         - stop
      - define target_name <context.args.get[1]>
    - if !<server.has_flag[player_map.names.<[target_name]>]>:
      - narrate "<&c>Unknown Player<&co> <&e><[target_name]>"
      - stop
    - if <server.flag[player_map.names.<[target_name]>.uuid]> == <player.uuid>:
      - narrate "<&c>You can't message yourself..."
      - stop
    # definitions
    - define msg <context.args.get[2].to[last].separated_by[<&sp>]>
    - define sender <proc[get_player_display_name].strip_color.replace[<&sp>].with[_]>
    - define self_name <proc[get_player_display_name]>
    - define other_name <proc[get_player_display_name].context[<player[<server.flag[player_map.names.<[target_name]>.uuid]>]>]>
    - define icon <&chr[1001]>
    # Allow Chat Colors in Chat
    - if <player.has_permission[adriftus.chat.color]>:
      - define msg <[msg].parse_color>
    - else:
      - define msg <[msg].parse_color.strip_color>

      # Allow Items in Chat
    - if <[msg].contains_text[<&lb>item<&rb>]> && <player.has_permission[adriftus.chat.link_item]>:
      - define msg <[msg].replace_text[<&lb>item<&rb>].with[<&hover[<player.item_in_hand>].type[SHOW_ITEM]><&lb><player.item_in_hand.display||<player.item_in_hand.material.translated_name>><&r><&rb><&end_hover>]>

    #- define Message <&font[adriftus:chat]><[Icon]><&r><&sp><[ChannelText]><&r><[NameText]><&nl><&sp><&sp><&sp><&sp><&sp><[MessageText]>
    - define WhisperTextSelf <&font[adriftus:chat]><[Icon]><&r><&sp><&7><&lb>MSG<&rb><&r><&e>You<&b>-<&gt><&e><[other_name]><&co><&nl><&sp><&sp><&sp><&sp><&sp>
    - define WhisperTextOther <&font[adriftus:chat]><[Icon]><&r><&sp><&7><&lb>MSG<&rb><&r><&e><[self_name]><&b>-<&gt><&e>You<&co><&nl><&sp><&sp><&sp><&sp><&sp>
    # Whisper Channel
    #- define WhisperTextSelf "<&7><&lb>MSG<&rb><&r><&e>You<&b>-<&gt><&e><[other_name]><&co> "
    #- define WhisperTextOther "<&7><&lb>MSG<&rb><&r><&e><[self_name]><&b>-<&gt><&e>You<&co> "
    # Disabled for Freedom!
    #- define WhisperTextMods "<&7><&lb>MSG<&rb><&r><proc[get_player_display_name]><&b>-<&gt><context.args.get[1].to_titlecase> "

    - define message "<element[<[WhisperTextOther]><&f><[msg]>].on_click[/msg <[self_name].strip_color.replace_text[<&sp>].with[_]> ].type[SUGGEST_COMMAND].on_hover[<&e>Click to Reply]>"
    - run bungee_send_message def:<list_single[<server.flag[player_map.names.<[target_name]>.uuid]>].include_single[<[sender]>].include_single[<[message]>].include_single[true]>
    - define message <[WhisperTextSelf]><&f><[msg]>
    - narrate <[message]>
    - define map <map[time=<server.current_time_millis>;message=<[message]>]>
    - run global_player_data_message_history def:<list_single[<player.uuid>].include_single[<[map]>]>
