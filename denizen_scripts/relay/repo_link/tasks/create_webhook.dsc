create_webhook:
  type: task
  debug: false
  definitions: channel_id|channel_name
  script:
    - define url https://discord.com/api/channels/<[channel_id]>/webhooks
    - define headers <yaml[saved_headers].parsed_key[discord.bot_auth]>
    - define channel_data <map.with[name].as[#<[channel_name]>].to_json>
    - ~webget <[url]> headers:<[headers]> data:<[channel_data]> save:response
    - if <entry[response].failed>:
      - stop
    - define hook_map <util.parse_yaml[<entry[response].result>]>
    - define hook https://discordapp.com/api/webhooks/<[hook_map].get[id]>/<[hook_map].get[token]>
