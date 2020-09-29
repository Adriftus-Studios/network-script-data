Repository_DCommand:
  type: task
  definitions: Channel
  debug: false
  script:
  # - ██ [ Clean Definitions & Inject Dependencies ] ██
    - define color Code
    - inject embedded_color_formatting
    - define hook <script[DDTBCTY].data_key[webhooks.<[channel]>.hook]>
    - define headers <yaml[saved_headers].read[discord.webhook_message]>

    - define data <yaml[SDS_Repository].to_json>
    - ~webget <[hook]> data:<[data]> headers:<[headers]>
