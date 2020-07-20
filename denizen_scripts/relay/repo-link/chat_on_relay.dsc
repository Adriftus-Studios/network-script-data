
chat_send_message:
  type: task
  debug: false
  definitions: game_channel|name|game_message|server
  script:
      - define channel <yaml[chat_config].read[channels.<[game_channel]>.integrations.Discord.channel]>
    #^- define group <yaml[chat_config].read[channels.<[game_channel]>.integrations.Discord.group]>
    #^- define messageEscaped "<element[**[<[server].to_titlecase>]** <[name]><&co> <[game_message].unescaped>].escaped>"

      - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    #^- define data '{"content": "<[game_message].unescaped>", "username": "<[Name]>", "avatar_url": "https://minotar.net/helm/<[Name]>"}'
    #$- define Data <map[content/<[game_message].unescaped.parse_color.strip_color>|username/<[Name]><&sp>[<[Server]>]|avatar_url/https://minotar.net/helm/<[Name]>].to_json>
      - define Data <map[content/<[game_message].parse_color.strip_color>|username/<[Name]><&sp>[<[Server]>]|avatar_url/https://minotar.net/cube/<[Name]>/100.png].to_json>
      - define headers <list[User-Agent/Behr|Content-Type/application/json]>
      - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>

    #^- inject discord_sendMessage

discord_watcher:
  type: world
  debug: false
  events:
    on discord message received:
      - if <context.author||invalid> == invalid || <context.message||invalid> == invalid:
        - stop
      #$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ so if i rename myself Adriftus, my messages won't work? /s
      - if <yaml[discord_watcher].read[watched.<context.channel.id>]||null> != null && !<context.author.name.contains[Adriftus]>:
        - define channel <yaml[discord_watcher].read[watched.<context.channel.id>]>
        
     #^- if !<context.mentions.is_empty>:
     #^  - foreach <context.mentions> as:User:
     #^    - define msg <context.message.replace[<&lt>@!<[User].ID><&gt>].with[<&3>@<&b><[User].nickname[<context.group>]||<[User].name>><&r>]>
        - foreach <bungee.list_servers.exclude[<yaml[chat_config].read[settings.excluded_servers]>]> as:server:
        #^- bungeerun <[server]> chat_send_message "def:<yaml[discord_watcher].read[watched.<context.channel.id>]>|<element[<element[<&7><&lb><&color[#738adb]>D<&7><&rb>].on_hover[<&e>Message is from Discord]><yaml[chat_config].read[channels.<[channel]>.format.channel].parsed.on_hover[<&e>Click to switch to this channel].on_click[/chat <[channel]>]><&7><context.author.name><yaml[chat_config].read[channels.<[channel]>.format.separator].parsed><yaml[chat_config].read[channels.<[channel]>.format.message].parsed.on_hover[<util.date> <util.date.time>]>].escaped>"

          - define Hover "<&color[#F3FFAD]>Message is from <&color[#738adb]>Discord<&color[#F3FFAD]>!"
          - define Text <&7><&lb><&color[#738adb]>D<&7><&rb>
          - define DiscIcon <proc[MsgHover].context[<[Hover]>|<[Text]>]>

          - define Hover "<&color[#F3FFAD]>Click to switch to<&color[#26FFC9]>: <&color[#C1F2F7]><[channel].to_titlecase>"
          - define Text <yaml[chat_config].read[channels.<[channel]>.format.channel].parsed>
          - define Command "chat <[channel]>"
          - define ChannelText <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>

        #^- define Name <context.author.nickname[<context.group>]||<context.author.name>>
          - define Name <context.author.name>
          - define Hover "<&color[#F3FFAD]>Name<&color[#26FFC9]>: <&color[#C1F2F7]><[Name]><&nl><&color[#F3FFAD]>in-game name<&color[#26FFC9]>: <&7>Not Linked<&nl><&color[#F3FFAD]>Shift-Click to ping"
          - define Text <&7><[Name]>
          - define Insert @<context.author.nickname[<context.group>]||<context.author.name>>
          - define NameText <proc[MsgHoverIns].context[<list_single[<[Hover]>].include[<[Text]>].include[<[Insert]>]>]>
          
          - define Separator <yaml[chat_config].read[channels.<[channel]>.format.separator].parsed>

          - define Hover "<&color[#F3FFAD]>Timestamp<&color[#26FFC9]>: <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>]>"
          - define Text <yaml[chat_config].read[channels.<[channel]>.format.message].replace[].parsed>
          - define Insert <[Text]>
          - define MessageText <proc[MsgHoverIns].context[<list_single[<[Hover]>].include[<[Text]>].include[<[Insert]>]>]>
          - define Attachments <list[<empty>]>
          - if <context.attachments||invalid> != invalid:
            - foreach <context.attachments> as:Attachment:
              - define Hover "<&color[#F3FFAD]>Click to Open Link <&color[#26FFC9]>:<&nl><&color[#F3FFAD]><[Attachment]>"
              - define Text <&3>[<&b><&n>Link<&3>]<&r>
              - define Url <[Attachment]>
              - define Attachments <[Attachments].include[<proc[MsgURL].context[<[Hover]>|<[Text]>|<[Attachment]>]>]>
          - define Attachments <[Attachments].unseparated><&sp>
          - define Message <[DiscIcon]><[ChannelText]><[NameText]><[Separator]><[Attachments]><[MessageText]>
          - define Definitions <list_single[<[Channel]>].include[<[Message]>]>
          - bungeerun <[Server]> chat_send_message def:<[Definitions]>

chat_system_data_manager:
  type: world
  debug: false
  load:
    - if <server.has_file[data/globalLiveData/chat/channels.yml]>:
      - yaml id:chat_config load:data/globalLiveData/chat/channels.yml
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