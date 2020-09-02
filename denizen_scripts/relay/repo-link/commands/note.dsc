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
    
  # % ██ [ verify arguments            ] ██
    - if <[args].size> == 0:
      - stop

    - if !<script[ddtbcty].list_keys[webhooks].contains[<[channel]>]>:
      - stop
    - define user_id <[author].id>
    - define headers <yaml[saved_headers].parsed_key[discord.bot_auth]>

    - ~webget https://discordapp.com/api/users/<[user_id]> headers:<[headers]> save:response
    - define user_avatar https://cdn.discordapp.com/avatars/<[userid]>/<util.parse_yaml[<entry[response].result>].get[avatar]>
    - inject web_debug.webget_response

    - define message <&lt>:hambehrgeur:732716255567413309<&gt><&sp><[message].after[/note<&sp>]>
    - define color yellow
    - inject embedded_color_formatting
    - define author <map.with[name].as[<[author].name>].with[icon_url].as[<[user_avatar]>]>
    - define embeds <list[<map.with[color].as[<[color]>].with[description].as[<[message]>].with[author].as[<[author]>]>]>
    - define data <map.with[username].as[notehook].with[avatar_url].as[https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png].with[author].as[<[author]>].to_json>

    - define hook <script[ddtbcty].data_key[webhooks.731607719165034538.hook]>
    - define headers <yaml[saved_headers].read[discord.webhook_message]>
    - ~webget <[hook]> data:<[data]> headers:<[headers]>


    - define message "note saved to: <&lt>#731607719165034538<&gt><&nl><&gt> `<[message].after[<&lt>:hambehrgeur:732716255567413309<&gt><&sp>]>`"
    - define embeds <list[<map.with[color].as[<[color]>].with[description].as[<[message]>].with[author].as[<[author]>]>]>
    - define data <map.with[username].as[notehook].with[avatar_url].as[https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png].with[author].as[<[author]>].to_json>

    - define hook <script[ddtbcty].data_key[webhooks.<[channel]>.hook]>
    - define headers <yaml[saved_headers].read[discord.webhook_message]>
    - ~webget <[hook]> data:<[data]> headers:<[headers]>
