get_webhooks:
  type: task
  debug: false
  definitions: channel_id
  script:
    - define url https://discord.com/api/channels/<[channel_id]>/webhooks
    - define headers <yaml[saved_headers].parsed_key[discord.bot_auth]>
    - ~webget <[url]> headers:<[headers]> save:response
    - if <entry[response].failed>:
      - stop
    - inject web_debug.webget_response
    - define result <util.parse_yaml[{"data":<entry[response].result>}].get[data]>

    - if <[result].is_empty>:
      - inject get_channel
      - inject create_webhook
    - else:
      - define hook https://discordapp.com/api/webhooks/<[result].first.get[id]>/<[result].first.get[token]>
