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
  definitions: message|channel_id|author|group|message_id
  debug: false
  script:
  # % ██ [ clean definitions & inject dependencies ] ██
    - inject role_verification
    - inject command_arg_registry
    - define color code
    - inject embedded_color_formatting
    - define headers <yaml[saved_headers].parsed_key[discord.Bot_Auth]>

  # % ██ [ verify arguments             ] ██
    - if <[args].size> == 0:
      - stop

  # % ██ [ obtain user info             ] ██
    - define user_id <[author].id>
    - ~webget https://discordapp.com/api/users/<[user_id]> headers:<[headers]> save:response
    - define user_avatar https://cdn.discordapp.com/avatars/<[user_id]>/<util.parse_yaml[<entry[response].result>].get[avatar]>

  # % ██ [ reply with note verification ] ██
    - define url https://discordapp.com/api/channels/731607719165034538/messages
    - define message "<&lt>:hambehrgeur:732716255567413309<&gt> <[message].after[/note ]>"
    - define data <script.parsed_key[response].to_json>

    - ~webget <[url]> method:post data:<[data]> headers:<[headers]> save:verification_post
    - inject web_debug.webget_response

  # % ██ [ save message note            ] ██
    - define url https://discordapp.com/api/channels/<[channel_id]>/messages
    - define message "**Message note saved to**: <&lt>#731607719165034538<&gt><&nl><&gt> <[message].after[<&lt>:hambehrgeur:732716255567413309<&gt> ]>"
    - define data <script.parsed_key[response].exclude[message_reference|allowed_mentions].to_json>

    - ~webget <[url]> method:post data:<[data]> headers:<[headers]> save:verification_post
    - inject web_debug.webget_response

  response:
    embed:
    #^title: "**[`[Reference]`](https://discordapp.com/channels/{group.id}/{channel.id}/{message.id}) Message note saved to**: <#626098849127071746>"
    #^url: https://discordapp.com/channels/{group.id}/{channel.id}/{message.id}
      description: <[message]>
      color: <[color]>
      author:
        name: <[author].name>
        icon_url: <[user_avatar]>
    message_reference:
      message_id: <[message_id]>
      guild_id: <[group].id>
    allowed_mentions:
      parse: <list>
