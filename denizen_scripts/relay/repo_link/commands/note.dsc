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
    - define message "<[message].after[/note ]>"

  # % ██ [ verify arguments             ] ██
    - if <[args].size> == 0:
      - stop

  # % ██ [ obtain user info             ] ██
    - define user_id <[author].id>
    - ~webget https<&co>//discordapp.com/api/users/<[user_id]> headers:<[headers]> save:response
    - define user_avatar https<&co>//cdn.discordapp.com/avatars/<[user_id]>/<util.parse_yaml[<entry[response].result>].get[avatar]>

  # % ██ [ reply with note verification ] ██
    - define url https<&co>//discordapp.com/api/channels/<[channel_id]>/messages
    - define description "**Message note saved to**<&co> <&lt>#731607719165034538<&gt><&nl><&gt> <[message]>"
    - define data <script.parsed_key[response].to_json>

    - ~webget <[url]> method:post data:<[data]> headers:<[headers]> save:response_reference
    - define response_reference_id <util.parse_yaml[<entry[response_reference].result>].get[id]>
    - define response_reference_message_url https<&co>//discordapp.com/channels/<[group].id>/<[channel_id]>/<[response_reference_id]>

  # % ██ [ save message note            ] ██
    - define url https<&co>//discordapp.com/api/channels/731607719165034538/messages
    - define description "<&lb>`<&lb>Message Reference<&rb>`<&rb>(<[response_reference_message_url]>) from <&lt><&ns><[channel_id]><&gt><n><&lt><&co>Tequila<&co>756265228471369889<&gt> <[message]>"
    - define data <script.parsed_key[response].exclude[message_reference|allowed_mentions].to_json>

    - ~webget <[url]> method:post data:<[data]> headers:<[headers]> save:notes_reference
    - define notes_reference_id <util.parse_yaml[<entry[notes_reference].result>].get[id]>
    - define notes_reference_message_url https<&co>//discordapp.com/channels/<[group].id>/731607719165034538/<[notes_reference_id]>

  # % ██ [ edit in referenced message   ] ██
  #^- define url https<&co>//discordapp.com/api/channels/<[channel_id]>/messages/<[response_reference_id]>
  #^- define data "<map.with[embed].as[<script.parsed_key[response.embed].with[title].as[`<&lb>Message Reference<&rb>`].with[url].as[<[response_reference_message_url]>]>].to_json>"
  #^- ~betterwebget <[url]> method:patch data:<[data]> headers:<[headers]>

  response:
    embed:
      description: <[description]>
      color: <[color]>
      author:
        name: <[author].name>
        icon_url: <[user_avatar]>
    message_reference:
      message_id: <[message_id]>
      guild_id: <[group].id>
    allowed_mentions:
      parse: <list>
