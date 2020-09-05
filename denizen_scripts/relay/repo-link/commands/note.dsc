note_dcommand:
  type: task
  permissionroles:
  # % ██ [ staff roles  ] ██
    - Lead Developer
    - External Developer
    - Developer

  # % ██ [ public roles ] ██
    - lead Developer
    - Developer
  definitions: message|channel|author|group
  debug: false
  script:
  # % ██ [ clean definitions & inject dependencies ] ██
    - inject role_verification
    - inject command_arg_registry

  # % ██ [ verify arguments             ] ██
    - if <[args].size> == 0:
      - stop

  # % ██ [ verify webhook               ] ██
  #^- if !<script[ddtbcty].list_keys[webhooks].contains[<[channel]>]>:
  #^  - stop

  # % ██ [ obtain user info             ] ██
    - define user_id <[author].id>
    - define headers <yaml[saved_headers].parsed_key[discord.bot_auth]>
    - ~webget https://discordapp.com/api/users/<[user_id]> headers:<[headers]> save:response
    - define user_avatar https://cdn.discordapp.com/avatars/<[user_id]>/<util.parse_yaml[<entry[response].result>].get[avatar]>

  # % ██ [ build note message           ] ██
    - define message <&lt>:hambehrgeur:732716255567413309<&gt><&sp><[message].after[/note<&sp>]>
    - define color yellow
    - inject embedded_color_formatting
    - define author <map.with[name].as[<[author].name>].with[icon_url].as[<[user_avatar]>]>
    - define embeds <list[<map.with[color].as[<[color]>].with[description].as[<[message]>].with[author].as[<[author]>]>]>
    - define data <map.with[username].as[notehook].with[avatar_url].as[https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png].with[embeds].as[<[embeds]>].to_json>

  # % ██ [ reply with note verification ] ██
    - define channel_id 731607719165034538
    - inject get_webhooks
    - define headers <yaml[saved_headers].read[discord.webhook_message]>
    - ~webget <[hook]> data:<[data]> headers:<[headers]>
  #^- discord id:AdriftusBot channel:<[channel_id]> send_embed embed:<discordembed[note_embed]>

  # % ██ [ build note message           ] ██
    - define message "note saved to: <&lt>#731607719165034538<&gt><&nl><&gt> `<[message].after[<&lt>:hambehrgeur:732716255567413309<&gt><&sp>]>`"
    - define embeds <list[<map.with[color].as[<[color]>].with[description].as[<[message]>].with[author].as[<[author]>]>]>
    - define data <map.with[username].as[notehook].with[avatar_url].as[https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png].with[embeds].as[<[embeds]>].to_json>

  # % ██ [ save message note            ] ██
    - define channel_id <[channel]>
    - inject get_webhooks
    - define headers <yaml[saved_headers].read[discord.webhook_message]>
    - ~webget <[hook]> data:<[data]> headers:<[headers]>
  #^- discord id:AdriftusBot channel:<[channel]> send_embed embed:<discordembed[note_embed]>

note_embed:
  type: discord_embed
#@title: test_title
  author_name: <[author].name>
#@author_url:
  author_icon_url: <[user_avatar]>
#@footer_text:
#@footer_icon_url:
#@image_url:
#@image_width:
#@image_height:
#@video_url:
#@video_width:
#@video_height:
#@thumbnail_url:
#@thumbnail_width:
#@thumbnail_height:
#@provider_name:
#@provider_url:
#@title:
  description: <[message]>
#@embed_type:
  color: 13544704
#@url:

#@send_embed_message:
#@  type: task
#@  script:
#^    - discord id:AdriftusBot channel:626080540638052382 send_embed embed:<discordembed[embed_script_container]>