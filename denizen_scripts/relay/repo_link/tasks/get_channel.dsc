get_channel:
  type: task
  debug: false
  definitions: channel_id
  script:
    - define url https://discord.com/api/channels/<[channel_id]>
    - define headers <yaml[saved_headers].parsed_key[discord.bot_auth]>
    - ~webget <[url]> headers:<[headers]> save:response
    - if <entry[response].failed>:
      - stop
    - inject web_debug.webget_response
    - define channel_map <util.parse_yaml[<entry[response].result>]>
    - define channel_id <[channel_map].get[id]>
    - define channel_name <[channel_map].get[name]>
