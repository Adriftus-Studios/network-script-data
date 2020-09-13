
chat_send_message:
  type: task
  debug: false
  definitions: game_message|game_channel|server|name|display_name
  script:
      - define channel <yaml[chat_config].read[channels.<[game_channel]>.integrations.Discord.channel]>
      - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
      - define Data <map[content/<[game_message].parse_color.strip_color>|username/<[display_name]><&sp>[<[Server]>]|avatar_url/https://minotar.net/cube/<[name]>/100.png].to_json>
      - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
      - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>

discord_watcher:
  type: world
  debug: false
  events:
    on discord message received for:adriftusbot:
      - if <context.author||invalid> == invalid || <context.message||invalid> == invalid:
        - stop
      - if <yaml[discord_watcher].read[watched.<context.channel.id>]||null> != null && !<context.author.name.contains[Adriftus]>:
        - define channel <yaml[discord_watcher].read[watched.<context.channel.id>]>
        
        - define Hover "<&color[#F3FFAD]>Message is from <&color[#738adb]>Discord<&color[#F3FFAD]>!"
        - define Text <&7><&lb><&color[#738adb]>D<&7><&rb>
        - define DiscIcon <proc[MsgHover].context[<[Hover]>|<[Text]>]>

        - define Hover "<&color[#F3FFAD]>Click to switch to<&color[#26FFC9]>: <&color[#C1F2F7]><[channel].to_titlecase>"
        - define Text <yaml[chat_config].parsed_key[channels.<[channel]>.format.channel]>
        - define Command "chat <[channel]>"
        - define ChannelText <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>

        - define Name <context.author.name>
        - define Hover "<&color[#F3FFAD]>Name<&color[#26FFC9]>: <&color[#C1F2F7]><[Name]><&nl><&color[#F3FFAD]>in-game name<&color[#26FFC9]>: <&7>Not Linked<&nl><&color[#F3FFAD]>Shift-Click to ping"
        - define Text <&7><[Name]>
        - define Insert @<context.author.nickname[<context.group>]||<context.author.name>>
        - define NameText <proc[MsgHoverIns].context[<list_single[<[Hover]>].include[<[Text]>].include[<[Insert]>]>]>
        
        - define Separator <yaml[chat_config].parsed_key[channels.<[channel]>.format.separator]>

        - define Hover "<&color[#F3FFAD]>Timestamp<&color[#26FFC9]>: <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>]>"
        - define Text <yaml[chat_config].parsed_key[channels.<[channel]>.format.message].replace[]>
        - define Insert <[Text]>
        - define MessageText <proc[MsgHoverIns].context[<list_single[<[Hover]>].include[<[Text]>].include[<[Insert]>]>]>
        - define Attachments <list>
        - if !<context.message.attachments.is_empty>:
          - foreach <context.message.attachments> as:Attachment:
            - define Hover "<&color[#F3FFAD]>Click to Open Link <&color[#26FFC9]>:<&nl><&color[#F3FFAD]><[Attachment]>"
            - define Text <&3>[<&b><&n>Link<&3>]<&r>
            - define Url <[Attachment]>
            - define Attachments <[Attachments].include[<proc[MsgURL].context[<[Hover]>|<[Text]>|<[Attachment]>]>]>
        - define Attachments <[Attachments].unseparated><&sp>
        - define Message <[DiscIcon]><[ChannelText]><[NameText]><[Separator]><[Attachments]><[MessageText]>
        - define Definitions <list_single[<[Channel]>].include[<[Message]>]>
        - define Servers <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>]>
        - bungeerun <[Servers]> chat_send_message def:<[Definitions]>

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
      - if <yaml[chat_config].read[channels.<[value]>.integrations.Discord.active]> && <yaml[chat_config].read[channels.<[value]>.integrations.Discord.to-MC]>:
        - yaml id:discord_watcher set watched.<yaml[chat_config].read[channels.<[value]>.integrations.Discord.channel]>:<[value]>
  events:
    on server start:
      - inject locally load
    on script reload:
      - inject locally load
