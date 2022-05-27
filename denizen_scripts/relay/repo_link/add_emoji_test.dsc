discord_add_react:
  type: task
  debug: false
  # emoji must be `name:id`
  definitions: channel|message|emoji
  data:
    headers:
      User-Agent: Rachelalala
      Authorization: <[token]>
  script:
    - define token <secret[adriftus_bot]>
    - define headers <script.parsed_key[data.headers]>
    - define hook https://discord.com/api/channels/<[channel]>/messages/<[message]>/reactions/<[emoji].url_encode>/@me
    - ~webget <[Hook]> headers:<[Headers]> method:PUT