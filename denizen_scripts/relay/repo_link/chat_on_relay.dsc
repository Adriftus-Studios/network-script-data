
chat_send_message:
  type: task
  debug: false
  definitions: game_message|game_channel|server|uuid|display_name|message_uuid
  script:
      - if <[game_channel]> == server:
        - define channel <yaml[chat_config].read[channels.<[game_channel]>.integrations.Discord.<[server]>.channel]>
      - else:
        - define channel <yaml[chat_config].read[channels.<[game_channel]>.integrations.Discord.channel]>
      - ~run discord_get_or_create_webhook def:<[channel]> save:webhook

      # Ping Sanitization
      - if !<list[staff|admin|development].contains[<[game_channel]>]>:
        - define game_message <[game_message].replace[@].with[(a)]>

      - define Hook <entry[webhook].created_queue.determination.get[1]>
      - define Data <script.parsed_key[webhook].to_json>
      - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
      - ~webget <[Hook]>?wait=true data:<[Data]> headers:<[Headers]> save:webget
      - define discord_id <util.parse_yaml[<entry[webget].result>].get[id]>
      - if <[game_channel]> == server:
        - run discord_save_message def:<[game_channel]>_<[server]>|<[message_uuid]>|<[discord_id]>|<[channel]>
      - else:
        - run discord_save_message def:<[game_channel]>|<[message_uuid]>|<[discord_id]>|<[channel]>

  webhook:
    content: <[game_message].strip_color>
    username: <[display_name]><&sp><&lb><[Server]><&rb>
    avatar_url: https://mc-heads.net/head/<[uuid]>/50

discord_watcher:
  type: world
  debug: false
  events:
    on discord message received for:a_bot:
      - if <context.new_message.author.discriminator> == 0000 || <context.new_message.author.is_bot>:
        - stop
      - if <yaml[discord_watcher].read[watched.<context.channel.id>]||null> != null && !<context.new_message.author.name.contains[Adriftus]>:
        - define uuid <context.new_message.channel.id>_<context.new_message.id>
        - define channel <yaml[discord_watcher].read[watched.<context.channel.id>]>
        - define sender DiscordUser_<context.new_message.author.id>

        - if <[channel].starts_with[server_]>:
          - stop if:<yaml[chat_config].read[channels.server.integrations.Discord.<[channel].after[_]>.to-MC].if_null[true].not>
        - else:
          - stop if:<yaml[chat_config].read[channels.<[channel]>.integrations.Discord.to-MC].if_null[true].not>

        # Server chat Override
        - if <[channel].starts_with[server_]>:
          - stop if:<context.new_message.attachments.is_empty.not>
          - define Definitions <list_single[server].include[<context.new_message.text_display>].include[<[uuid]>].include[<[sender]>].include[<context.new_message.author.name>]>
          - bungeerun <[channel].after[_]> chat_send_server_message def:<[definitions]>
          - run discord_save_message def:<[channel]>|<[uuid]>|<context.new_message.id>|<context.channel.id>
          - stop

        - define Hover "<&color[#F3FFAD]>Message is from <&color[#738adb]>Discord<&color[#F3FFAD]>!"
        - define Text <&f><&chr[0044].font[adriftus:chat]>
        - define DiscIcon <proc[msg_hover].context[<[Hover]>|<[Text]>]>

      # Determine Chat Icon
        - define icon <yaml[chat_config].parsed_key[channels.<[channel]>.icon].if_null[null]>
        - define icon <&chr[1001]> if:<[icon].equals[null]>

        - define Hover "<&color[#F3FFAD]>Click to switch to<&color[#26FFC9]>: <&color[#C1F2F7]><[channel].to_titlecase>"
        - define Text <&font[adriftus:chat]><[icon]><&f><&sp><&r><yaml[chat_config].parsed_key[channels.<[channel]>.format.channel]>
        - define Command "chat <[channel]>"
        - define ChannelText <proc[msg_cmd].context[<[Hover]>|<[Text]>|<[Command]>]>
        - define ChannelSpaceText <proc[msg_cmd].context[<list_single[<[hover]>].include_single[<&sp><&sp><&sp><&sp>].include_single[<[command]>]>]>

        - define Name <context.new_message.author.name>
        - define Hover "<&color[#F3FFAD]>Name<&color[#26FFC9]>: <&color[#C1F2F7]><[Name]><&nl><&color[#F3FFAD]>in-game name<&color[#26FFC9]>: <&7>Not Linked<&nl><&color[#F3FFAD]>Shift-Click to ping"
        - define Text <&7><[Name]>
        - define Insert @<context.new_message.author.name>
        - define NameText <proc[msg_hover_ins].context[<list_single[<[Hover]>].include[<[Text]>].include[<[Insert]>]>]>

        - define Separator <yaml[chat_config].parsed_key[channels.<[channel]>.format.separator]>

        - define Hover "<&color[#F3FFAD]>Timestamp<&color[#26FFC9]>: <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>]>"
        - define Text <yaml[chat_config].parsed_key[channels.<[channel]>.format.message].replace[]>
        - define Insert "chat interact <[channel]> <[uuid]>"
        - define MessageText <proc[msg_cmd].context[<list_single[<[Hover]>].include[<[Text]>].include[<[Insert]>]>]>
        - define Attachments <list>
        - if !<context.new_message.attachments.is_empty>:
          - foreach <context.new_message.attachments> as:Attachment:
            - define Hover "<&color[#F3FFAD]>Click to Open Link <&color[#26FFC9]>:<&nl><&color[#F3FFAD]><[Attachment]>"
            - define Text <&sp><&6>[<&e><&n>Link<&6>]<&r>
            - define Url <[Attachment]>
            - define Attachments <[Attachments].include[<proc[msg_url].context[<[Hover]>|<[Text]>|<[Attachment]>]>]>
        - define Attachments <[Attachments].unseparated><&sp>
        - define Message <[ChannelText]><[DiscIcon]><&sp><[NameText]><&co><&nl><[ChannelSpaceText]><[Attachments]><[MessageText]>
        - define Definitions <list_single[<[Channel]>].include[<[Message]>].include[<[uuid]>].include[<[sender]>]>
        - define Servers <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>]>
        - bungeerun <[Servers]> chat_send_message def:<[Definitions]>
        - run discord_save_message def:<[channel]>|<[uuid]>|<context.new_message.id>|<context.channel.id>

    on discord message deleted for:a_bot:
      - if <yaml[discord_watcher].read[watched.<context.channel.id>].if_null[null]> != null:
        - define channel <yaml[discord_watcher].read[watched.<context.channel.id>]>
        - foreach <yaml[chat_history].read[<[channel]>_history]>:
          - if <[value].get[discord_id]> == <context.old_message.id>:
            - if <[channel].starts_with[server_]>:
              - bungeerun <[channel].after[_]> chat_delete_message def:server|<[value].get[uuid]>|true|false|true
            - else:
              - bungeerun hub chat_delete_message def:<[channel]>|<[value].get[uuid]>|true|false
    
    on discord message modified for:a_bot:
      - if <context.new_message.author.discriminator> == 0000 || <context.new_message.author.is_bot>:
        - stop
      - if <yaml[discord_watcher].read[watched.<context.channel.id>]||null> != null && !<context.new_message.author.name.contains[Adriftus]>:
        - define uuid <context.new_message.channel.id>_<context.new_message.id>
        - define channel <yaml[discord_watcher].read[watched.<context.channel.id>]>
        - define sender DiscordUser_<context.new_message.author.id>

        - if <[channel].starts_with[server_]>:
          - stop if:<yaml[chat_config].read[channels.server.integrations.Discord.<[channel].after[_]>.to-MC].if_null[true].not>
        - else:
          - stop if:<yaml[chat_config].read[channels.<[channel]>.integrations.Discord.to-MC].if_null[true].not>

        # Server chat Override
        - if <[channel].starts_with[server_]>:
          - stop if:<context.new_message.attachments.is_empty.not>
          - define Definitions <list_single[server].include[<context.new_message.text_display>].include[<[uuid]>].include[<[sender]>].include[<context.new_message.author.name>]>
          - bungeerun <[channel].after[_]> chat_send_server_message def:<[definitions]>
          - run discord_save_message def:<[channel]>|<[uuid]>|<context.new_message.id>|<context.channel.id>
          - stop

        - define Hover "<&color[#F3FFAD]>Message is from <&color[#738adb]>Discord<&color[#F3FFAD]>!"
        - define Text <&f><&chr[0044].font[adriftus:chat]>
        - define DiscIcon <proc[msg_hover].context[<[Hover]>|<[Text]>]>

      # Determine Chat Icon
        - define icon <yaml[chat_config].parsed_key[channels.<[channel]>.icon].if_null[null]>
        - define icon <&chr[1001]> if:<[icon].equals[null]>

        - define Hover "<&color[#F3FFAD]>Click to switch to<&color[#26FFC9]>: <&color[#C1F2F7]><[channel].to_titlecase>"
        - define Text <&font[adriftus:chat]><[icon]><&f><&sp><&r><yaml[chat_config].parsed_key[channels.<[channel]>.format.channel]>
        - define Command "chat <[channel]>"
        - define ChannelText <proc[msg_cmd].context[<[Hover]>|<[Text]>|<[Command]>]>
        - define ChannelSpaceText <proc[msg_cmd].context[<list_single[<[hover]>].include_single[<&sp><&sp><&sp><&sp>].include_single[<[command]>]>]>

        - define Name <context.new_message.author.name>
        - define Hover "<&color[#F3FFAD]>Name<&color[#26FFC9]>: <&color[#C1F2F7]><[Name]><&nl><&color[#F3FFAD]>in-game name<&color[#26FFC9]>: <&7>Not Linked<&nl><&color[#F3FFAD]>Shift-Click to ping"
        - define Text <&7><[Name]>
        - define Insert @<context.new_message.author.name>
        - define NameText <proc[msg_hover_ins].context[<list_single[<[Hover]>].include[<[Text]>].include[<[Insert]>]>]>

        - define Separator <yaml[chat_config].parsed_key[channels.<[channel]>.format.separator]>

        - define Hover "<&color[#F3FFAD]>Timestamp<&color[#26FFC9]>: <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>]>"
        - define Text <yaml[chat_config].parsed_key[channels.<[channel]>.format.message].replace[]>
        - define Insert "chat interact <[channel]> <[uuid]>"
        - define MessageText <proc[msg_cmd].context[<list_single[<[Hover]>].include[<[Text]>].include[<[Insert]>]>]>
        - define Attachments <list>
        - if !<context.new_message.attachments.is_empty>:
          - foreach <context.new_message.attachments> as:Attachment:
            - define Hover "<&color[#F3FFAD]>Click to Open Link <&color[#26FFC9]>:<&nl><&color[#F3FFAD]><[Attachment]>"
            - define Text <&sp><&6>[<&e><&n>Link<&6>]<&r>
            - define Url <[Attachment]>
            - define Attachments <[Attachments].include[<proc[msg_url].context[<[Hover]>|<[Text]>|<[Attachment]>]>]>
        - define Attachments <[Attachments].unseparated><&sp>
        - define Message <[ChannelText]><[DiscIcon]><&sp><[NameText]><&co><&nl><[ChannelSpaceText]><[Attachments]><[MessageText]>
        - define Definitions <list_single[<[Channel]>].include[<[Message]>].include[<[uuid]>]>
        - define Servers <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>]>
        - bungeerun <[Servers]> chat_edit_message def:<[Definitions]>
        #- run discord_save_message def:<[channel]>|<[uuid]>|<context.new_message.id>|<context.channel.id>


discord_delete_message_from_chat:
  type: task
  debug: false
  definitions: channel|uuid
  data:
    headers:
      User-Agent: Adriftus
      Authorization: <[token]>
      Content-Type: application/json
  script:
    - define token <secret[adriftus_bot]>
    - foreach <yaml[chat_history].read[<[channel]>_history]>:
      - if <[value].get[uuid]> == <[uuid]>:
        - webget https://discord.com/api/channels/<[value].get[discord_channel]>/messages/<[value].get[discord_id]> headers:<script.parsed_key[data.headers]> method:DELETE

discord_save_message:
  type: task
  debug: false
  definitions: channel|uuid|discord_id|discord_channel
  script:
    - yaml id:chat_history set <[channel]>_history:->:<map[discord_id=<[discord_id]>;uuid=<[UUID]>;discord_channel=<[discord_channel]>]>
    - if <yaml[chat_history].read[<[channel]>_history].size> > 40:
      - define temp <yaml[chat_history].read[<[channel]>_history].remove[first]>
      - yaml id:chat_history set <[channel]>_history:!
      - yaml id:chat_history set <[channel]>_history:|:<[temp]>

chat_system_data_manager:
  type: world
  debug: false
  load:
    - if <server.has_file[data/global/chat/channels.yml]>:
      - yaml id:chat_config load:data/global/chat/channels.yml
    - if <yaml.list.contains[discord_watcher]>:
      - yaml id:discord_watcher unload
    - yaml create id:discord_watcher
    - foreach <yaml[chat_config].list_keys[channels]>:
      - if <yaml[chat_config].read[channels.<[value]>.integrations.Discord.active]>:
        - yaml id:discord_watcher set watched.<yaml[chat_config].read[channels.<[value]>.integrations.Discord.channel]>:<[value]>
    - foreach <yaml[chat_config].list_keys[channels.server.integrations.Discord]>:
      - if <yaml[chat_config].read[channels.server.integrations.Discord.<[value]>.active]>:
        - yaml id:discord_watcher set watched.<yaml[chat_config].read[channels.server.integrations.Discord.<[value]>.channel]>:server_<[value]>
    - if !<yaml.list.contains[chat_history]>:
      - if <server.has_file[data/chat_history.yml]>:
        - yaml id:chat_history load:data/chat_history.yml
      - else:
        - yaml create id:chat_history
  events:
    on server start:
      - inject local path:load
    on script reload:
      - inject local path:load
