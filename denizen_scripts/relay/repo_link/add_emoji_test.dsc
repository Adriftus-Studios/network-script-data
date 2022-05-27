discord_add_react:
  type: task
  debug: false
  # emoji must be `name:id`
  definitions: channel|message|emoji
  data:
    headers:
      User-Agent: Rachelalala
      Authorization: <[token]>
      Content-Type: application/json
  script:
    - define token <secret[adriftus_bot]>
    - define headers <script.parsed_key[data.headers]>
    - define hook https://discord.com/api/channels/<[channel]>/messages/<[message]>/reactions/<[emoji]>/@me
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>