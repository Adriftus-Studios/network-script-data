discord_get_or_create_webhook:
  type: task
  debug: false
  definitions: channel_id
  data:
    headers:
      User-Agent: Adriftus
      Authorization: Bot <[token]>
      Content-Type: json/application
    create_webhook:
      name: DenizenGenerated
  script:
    - define token <yaml[tokens].read[discord.AdriftusBotToken]>
    - if <server.has_flag[discord.webhooks.<[channel_id]>]>:
      - determine <server.flag[discord.webooks.<[channel_id]>]>
    - ~webget headers:<script.parsed_key[data.headers]> https://discord.com/api/channels/<[channel_id]>/webhooks save:webhooks
    - define webhook <util.parse_yaml[<entry[webhooks].result>]>
    - if <[webhook].get[1].get[id].if_null[null]> != null:
      - flag server discord.webhooks.<[channel_id]>:https<&co>//discord.com/api/webhooks/<[webhook].get[1].get[id]>/<[webhook].get[1].get[token]>
      - determine <server.flag[discord.webooks.<[channel_id]>]>
    - ~webget headers:<script.parsed_key[data.headers]> method:POST data:<script.parsed_key[data.create_webhook]> https://discord.com/api/channels/<[channel_id]>/webhooks save:created_webhook
    - announce to_console <entry[created_webhook].result>