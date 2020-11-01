Repository_DCommand:
  type: task
  definitions: Message|Channel
  debug: false
  script:
  # - ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject command_arg_registry
    - define color Code
    - inject embedded_color_formatting
    - define hook <script[DDTBCTY].data_key[webhooks.<[channel]>.hook]>
    - define headers <yaml[saved_headers].read[discord.webhook_message]>

    - if !<[args].is_empty> && <[args].first> == Gielinor:
      - define data <yaml[SDS_Repository_Gielinor].to_json>
    - else:
      - define data <yaml[SDS_Repository].to_json>
    - ~webget <[hook]> data:<[data]> headers:<[headers]>
